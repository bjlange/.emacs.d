;; ace jump mode:
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; buffer cleanup:
(global-set-key (kbd "C-c n") 'cleanup-buffer)

;; idomenu symbol jump:
(define-key (current-global-map) [remap imenu] 'idomenu)

;; buffer jump by C-tab
(global-set-key [C-tab] 'other-window)

;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)

;; multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; When you want to add multiple cursors not based on continuous lines, but based on
;; keywords in the buffer, use:

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; mac switch meta key
;; via https://gist.github.com/railwaycat/3498096
;; Keybonds
(global-set-key [(hyper a)] 'mark-whole-buffer)
(global-set-key [(hyper v)] 'yank)
(global-set-key [(hyper c)] 'kill-ring-save)
(global-set-key [(hyper s)] 'save-buffer)
(global-set-key [(hyper l)] 'goto-line)
(global-set-key [(hyper w)]
                (lambda () (interactive) (delete-window)))
(global-set-key [(hyper z)] 'undo)


(defun mac-switch-meta nil
  "switch meta between Option and Command"

  (interactive)
  (if (eq mac-option-modifier nil)
      (progn
        (setq mac-option-modifier 'meta)
        (setq mac-command-modifier 'hyper)
        )
    (progn
      (setq mac-option-modifier nil)
      (setq mac-command-modifier 'meta)
      )
    )
  )

;; mac switch meta key
;;(mac-switch-meta)

(provide 'init-keybindings)
