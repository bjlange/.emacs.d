;; pony-mode for Django templates
(require 'pony-mode)

;; rainbow mode for css
(add-hook 'css-mode-hook
          (lambda () (rainbow-mode 1)))

;; 2-space indents in css/scss because that's what datascope people use?
(setq css-indent-offset 2)

;; scss mode
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(setq scss-compile-at-save nil)

(provide 'init-html)
