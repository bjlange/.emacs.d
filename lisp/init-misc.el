;; turn off the friggin bell
(setq-default visible-bell t)

;; Ask "y" or "n" instead of "yes" or "no"
(fset 'yes-or-no-p 'y-or-n-p)

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Switching RE mode to a sane one
(require 're-builder)
(setq reb-re-syntax 'string)

;; System copy and paste works with kill ring
(setq x-select-enable-clipboard t)

;; try to get emacs to load faster...this is ridiculous
;; EUREKA!!! http://ubuntuforums.org/archive/index.php/t-183638.html
(modify-frame-parameters nil '((wait-for-wm . nil)))

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" system-name))

;; emacs vc-hg not working properly
(setq vc-handled-backends nil)

;; make emacs retain hard links appropriatly
(setq backup-by-copying 1)

;; tab size = 4 spaces unless otherwise stated
(setq-default default-tab-width 4)

;; idomenu - ido symbol jump within files
(autoload 'idomenu "idomenu" nil t)

;; puppetmode
(autoload 'puppet-mode "puppet-mode" "Major mode for puppet manifests")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

;; ace-jump-mode- quick jumpin'
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)

;; expand region - expanding selection progressively via magnars
(require 'expand-region)

;; multiple-cursors - multicursor goodness a la Sublime Text via magnars
;; turned off in terminal mode for now, since it fucks stuff up during init
(when (display-graphic-p)
  (defvar rectangular-region-mode nil)
  (require 'multiple-cursors))

;; recent files mode- lets you navigate last n files opened using ido
(require 'recentf)
(global-set-key (kbd "C-x C-r") 'ido-recentf-open) ;; bind to C-x C-r
(recentf-mode t)
(setq recentf-max-saved-items 20) ; 20 files ought to be enough.

;; draw a line at 80 chars
(require 'fill-column-indicator)
(setq fci-rule-column 80)
;; enable for all files for now..
(add-hook 'after-change-major-mode-hook 'fci-mode)

;; more niceties from https://github.com/pierre-lecocq/emacs4developers/blob/master/chapters/03-building-your-own-editor.org
;; Highlight corresponding parenthese when cursor is on one
(show-paren-mode t)

;; Highlight tabulations
(setq-default highlight-tabs t)

;; Show trailing white spaces
(setq-default show-trailing-whitespace t)

;; Remove useless whitespaces before saving a file
;; (add-hook 'before-save-hook 'whitespace-cleanup)
;; (add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

;; Rainbow delimiters!
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; enables colors? I don't know, but everyone has it in their inits lol
(global-font-lock-mode 1)

;; Sentences end with one space, damnit
(setq sentence-end-double-space nil)

;; Trying out a bar cursor instead of a box...
(set-default 'cursor-type 'bar)

;; Setup markdown mode to use Marked 2 for rendering
(setq markdown-open-command "/usr/local/bin/mark")

(provide 'init-misc)
;; init-misc.el ends here
