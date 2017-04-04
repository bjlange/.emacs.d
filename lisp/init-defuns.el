(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (untabify-buffer)
  (delete-trailing-whitespace)
  (indent-buffer))

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

(defun toggle-fullscreen ()
  "Toggle full screen"
  (interactive)
  (set-frame-parameter
     nil 'fullscreen
     (when (not (frame-parameter nil 'fullscreen)) 'fullboth)))

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


(defun set-window-width (n)
  "Set the selected window's width."
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t))

(defun 80-wide ()
  "Set the selected window to 80 columns."
  (interactive)
  (set-window-width 80))

(defun number-line (n padding)
  (beginning-of-line)
  (insert (number-to-string n))
  (let ((counter 0))
    (while (< counter padding)
      (insert " ")
      (setf counter (+ counter 1))))
  (forward-line))

(defun compute-padding (i n)
  (+ 1 (- (truncate (log10 n))
          (truncate (log10 i)))))

(defun number-lines (n)
  (interactive "p")
  (let ((counter 1))
    (while (<= counter n)
      (number-line counter (compute-padding counter n))
      (setf counter (+ counter 1)))))

(defun number-lines-region (start end)
  (interactive "r")
  (let ((num-lines (count-lines start end)))
    (save-excursion
      (save-restriction
        (narrow-to-region start end)
        (goto-char (point-min))
        (number-lines num-lines)))))

(provide 'init-defuns)
