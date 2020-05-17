;; .emacs

(custom-set-variables
 ;; uncomment to always end a file with a newline
 ;'(require-final-newline t)
 ;; uncomment to disable loading of "default.el" at startup
 ;'(inhibit-default-init t)
 ;; default to unified diffs
 '(diff-switches "-u"))

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

;; ショートカットいろいろ

;; タブの代わりにタブ相当のスペースを挿入する
(setq-default indent-tabs-mode nil)

(global-set-key "\e "  'toggle-egg-mode)

(global-set-key "\C-u" 'advertised-undo)
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-?" 'help-for-help)

(global-set-key "\C-xj" 'goto-line)
(global-set-key "\C-xm" 'set-mark-command)
(global-set-key "\C-xk" 'kill-rectangle)
(global-set-key "\C-xy" 'yank-rectangle)

(global-set-key "\M-c" 'compile)
(global-set-key "\M-n" 'next-error)

(setq-default tab-width 4)

