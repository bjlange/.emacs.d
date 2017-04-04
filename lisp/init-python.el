;; use python-mode instead of the default python major mode
;; (setq py-install-directory
;;       (concat user-emacs-directory "/python-mode.el-6.1.3/"))
;; (add-to-list 'load-path py-install-directory)
;; (require 'python-mode)

;; (autoload 'python-mode "python-mode" "Python Mode." t)
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; (add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; try to get C-c C-c to work
(defadvice python-send-region (around advice-python-send-region-goto-end)
  "Fix a little bug if the point is not at the prompt when you do
    C-c C-[rc]"
  (let ((oldpoint (with-current-buffer (process-buffer (python-proc)) (point)))
        (oldinput
         (with-current-buffer (process-buffer (python-proc))
           (goto-char (point-max))
           ;; Do C-c C-u, but without modifying the kill ring:
           (let ((pmark (process-mark (get-buffer-process (current-buffer)))))
             (when (> (point) (marker-position pmark))
               (let ((ret (buffer-substring pmark (point))))
                 (delete-region pmark (point))
                 ret))))))
    ad-do-it
    (with-current-buffer (process-buffer (python-proc))
      (when oldinput (insert oldinput))
      (goto-char oldpoint))))
(ad-enable-advice 'python-send-region
                  'around
                  'advice-python-send-region-goto-end)
(ad-activate 'python-send-region)

;; python jedi autocomplete/IDE functions
(require 'jedi)

(defun get-project-root-with-file (buf repo-file &optional init-file)
  "Guesses that the python root is the less 'deep' of either:
         -- the root directory of the repository, or
         -- the directory before the first directory after the root
            having the init-file file (e.g., '__init__.py'."

  ;; make list of directories from root, removing empty
  (defun make-dir-list (path)
    (delq nil (mapcar (lambda (x) (and (not (string= x "")) x))
                      (split-string path "/"))))
  ;; convert a list of directories to a path starting at "/"
  (defun dir-list-to-path (dirs)
    (mapconcat 'identity (cons "" dirs) "/"))
  ;; a little something to try to find the "best" root directory
  (defun try-find-best-root (base-dir buffer-dir current)
    (cond
     (base-dir ;; traverse until we reach the base
      (try-find-best-root (cdr base-dir) (cdr buffer-dir)
                          (append current (list (car buffer-dir)))))
     
     (buffer-dir ;; try until we hit the current directory
      (let* ((next-dir (append current (list (car buffer-dir))))
             (file-file (concat (dir-list-to-path next-dir) "/" init-file)))
        (if (file-exists-p file-file)
            (dir-list-to-path current)
          (try-find-best-root nil (cdr buffer-dir) next-dir))))
     
     (t nil)))
  
  (let* ((buffer-dir (expand-file-name (file-name-directory (buffer-file-name buf))))
         (vc-root-dir (vc-find-root buffer-dir repo-file)))
    (if (and init-file vc-root-dir)
        (try-find-best-root
         (make-dir-list (expand-file-name vc-root-dir))
         (make-dir-list buffer-dir)
         '())
      vc-root-dir))) ;; default to vc root if init file not given

;; Set this variable to find project root
(defvar jedi-config:find-root-function 'get-project-root-with-file)

(defun current-buffer-project-root ()
  (funcall jedi-config:find-root-function
           (current-buffer)
           jedi-config:vcs-root-sentinel
           jedi-config:python-module-sentinel))

(defun jedi-config:setup-server-args ()
  ;; little helper macro for building the arglist
  (defmacro add-args (arg-list arg-name arg-value)
    `(setq ,arg-list (append ,arg-list (list ,arg-name ,arg-value))))
  ;; and now define the args
  (let ((project-root (current-buffer-project-root)))
    
    (make-local-variable 'jedi:server-args)

    (when project-root
      (message (format "Adding system path: %s" project-root))
      (add-args jedi:server-args "--sys-path" project-root))
    
    (when jedi-config:with-virtualenv
      (message (format "Adding virtualenv: %s" jedi-config:with-virtualenv))
      (add-args jedi:server-args "--virtual-env" jedi-config:with-virtualenv))))

;; Use system python
(defun jedi-config:set-python-executable ()
  (set-exec-path-from-shell-PATH)
  (make-local-variable 'jedi:server-command)
  (set 'jedi:server-command
       (list (executable-find "python") ;; may need help if running from GUI
             (cadr default-jedi-server-command))))


(add-to-list 'ac-sources 'ac-source-jedi-direct)
(add-hook 'python-mode-hook 'jedi:setup)


;; Don't let tooltip show up automatically
(setq jedi:get-in-function-call-delay 10000000)
;; Start completion at method dot
(setq jedi:complete-on-dot t)

;; set python block comment prefix
(defvar py-block-comment-prefix "##")

(provide 'init-python)
