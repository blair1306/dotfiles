;;

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(when window-system (set-frame-size (selected-frame) 106 30))

(load-theme 'tango t)

;; We don't want to type yes and no all the time so, do y and n
(defalias 'yes-or-no-p 'y-or-n-p)

;; Disable autosaving and auto-backup
(setq auto-save-default nil)
(setq make-backup-files nil)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;; You might already have this line
(package-initialize)
;; list the packages you want
(defvar package-list)
(setq package-list '(async auctex auto-complete autopair clang-format cmake-ide
                           cmake-mode company company-irony company-rtags
                           company-irony-c-headers dash epl flycheck
                           flycheck-irony flycheck-pyflakes 
                           google-c-style helm helm-core helm-ctest
                           helm-flycheck helm-flyspell helm-ls-git helm-ls-hg
                           hungry-delete irony
                           let-alist levenshtein magit markdown-mode pkg-info
                           popup rtags seq solarized-theme vlf web-mode
                           window-numbering writegood-mode yasnippet
			   dracula-theme github-modern-theme
			   realgud))
;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))
;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; Require flycheck to be present
(require 'flycheck)
;; Force flycheck to always use c++11 support. We use
;; the clang language backend so this is set to clang
(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-clang-language-standard "c++11")))
;; Turn flycheck on everywhere
(global-flycheck-mode)

;; Use flycheck-pyflakes for python. Seems to work a little better.
(require 'flycheck-pyflakes)

;; Load rtags and start the cmake-ide-setup process
(require 'rtags)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup cmake-ide
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cmake-ide)
(cmake-ide-setup)
;; Set cmake-ide-flags-c++ to use C++11
(setq cmake-ide-flags-c++ (append '("-std=c++11")))
;; We want to be able to compile with a keyboard shortcut
(global-set-key (kbd "C-c m") 'cmake-ide-compile)


;; Set rtags to enable completions and use the standard keybindings.
;; A list of the keybindings can be found at:
;; http://syamajala.github.io/c-ide.html
(setq rtags-autostart-diagnostics t)
(rtags-diagnostics)
(setq rtags-completions-enabled t)
(rtags-enable-standard-keybindings)


;; clang-format can be triggered using C-M-tab
(require 'clang-format)
(global-set-key [C-M-tab] 'clang-format-region)
;; Create clang-format file using google style
;; clang-format -style=google -dump-config > .clang-format


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load helm and set M-x to helm, buffer to helm, and find files to herm
(require 'helm-config)
(require 'helm)
(require 'helm-ls-git)
(require 'helm-ctest)
;; Use C-c h for helm instead of C-x c
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c t") 'helm-ctest)
(setq
 helm-split-window-in-side-p           t
   ; open helm buffer inside current window,
   ; not occupy whole other window
 helm-move-to-line-cycle-in-source     t
   ; move to end or beginning of source when
   ; reaching top or bottom of source.
 helm-ff-search-library-in-sexp        t
   ; search for library in `require' and `declare-function' sexp.
 helm-scroll-amount                    8
   ; scroll 8 lines other window using M-<next>/M-<prior>
 helm-ff-file-name-history-use-recentf t
 ;; Allow fuzzy matches in helm semantic
 helm-semantic-fuzzy-match t
 helm-imenu-fuzzy-match    t)
;; Have helm automaticaly resize the window
(helm-autoresize-mode 1)
(setq rtags-use-helm t)
(require 'helm-flycheck) ;; Not necessary if using ELPA package
(eval-after-load 'flycheck
  '(define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: yasnippet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'yasnippet)
;; To get a bunch of extra snippets that come in super handy see:
;; https://github.com/AndreaCrotti/yasnippet-snippets
;; or use:
;; git clone https://github.com/AndreaCrotti/yasnippet-snippets.git ~/.emacs.d/yassnippet-snippets/
(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets/")
(yas-global-mode 1)
(yas-reload-all)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up code completion with company and irony
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'company)
(require 'company-rtags)
(global-company-mode)

;; Enable semantics mode for auto-completion
(require 'cc-mode)
(require 'semantic)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)

;; Setup irony-mode to load in c-modes
(require 'irony)
(require 'company-irony-c-headers)
(require 'cl)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; irony-mode hook that is called when irony is triggered
(defun my-irony-mode-hook ()
  "Custom irony mode hook to remap keys."
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; company-irony setup, c-header completions
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
;; Remove company-semantic because it has higher precedance than company-clang
;; Using RTags completion is also faster than semantic, it seems. Semantic
;; also provides a bunch of technically irrelevant completions sometimes.
;; All in all, RTags just seems to do a better job.
(setq company-backends (delete 'company-semantic company-backends))
;; Enable company-irony and several other useful auto-completion modes
;; We don't use rtags since we've found that for large projects this can cause
;; async timeouts. company-semantic (after company-clang!) works quite well
;; but some knowledge some knowledge of when best to trigger is still necessary.
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers
                        company-irony company-yasnippet
                        company-clang company-rtags)
    )
  )

(defun my-disable-semantic ()
  "Disable the company-semantic backend."
  (interactive)
  (setq company-backends (delete '(company-irony-c-headers
                                   company-irony company-yasnippet
                                   company-clang company-rtags
                                   company-semantic) company-backends))
  (add-to-list
   'company-backends '(company-irony-c-headers
                       company-irony company-yasnippet
                       company-clang company-rtags))
  )
(defun my-enable-semantic ()
  "Enable the company-semantic backend."
  (interactive)
  (setq company-backends (delete '(company-irony-c-headers
                                   company-irony company-yasnippet
                                   company-clang) company-backends))
  (add-to-list
   'company-backends '(company-irony-c-headers
                       company-irony company-yasnippet company-clang))
  )

;; Zero delay when pressing tab
(setq company-idle-delay 0)
(define-key c-mode-map [(tab)] 'company-complete)
(define-key c++-mode-map [(tab)] 'company-complete)
;; Delay when idle because I want to be able to think
(setq company-idle-delay 0.2)

;; Prohibit semantic from searching through system headers. We want
;; company-clang to do that for us.
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(local project unloaded recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(local project unloaded recursive))

(semantic-remove-system-include "/usr/include/" 'c++-mode)
(semantic-remove-system-include "/usr/local/include/" 'c++-mode)
(add-hook 'semantic-init-hooks
          'semantic-reset-system-include)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flyspell Mode for Spelling Corrections
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flyspell)
;; The welcome message is useless and can cause problems
(setq flyspell-issue-welcome-flag nil)
;; Fly spell keyboard shortcuts so no mouse is needed
;; Use helm with flyspell
(define-key flyspell-mode-map (kbd "<f8>") 'helm-flyspell-correct)
;; (global-set-key (kbd "<f8>") 'ispell-word)
(global-set-key (kbd "C-S-<f8>") 'flyspell-mode)
(global-set-key (kbd "C-M-<f8>") 'flyspell-buffer)
(global-set-key (kbd "C-<f8>") 'flyspell-check-previous-highlighted-word)
(global-set-key (kbd "M-<f8>") 'flyspell-check-next-highlighted-word)
;; Set the way word highlighting is done
(defun flyspell-check-next-highlighted-word ()
  "Custom function to spell check next highlighted word."
  (interactive)
  (flyspell-goto-next-error)
  (ispell-word)
  )

;; Spell check comments in c++ and c common
(add-hook 'c++-mode-hook  'flyspell-prog-mode)
(add-hook 'c-mode-common-hook 'flyspell-prog-mode)

;; Enable flyspell in text mode
(if (fboundp 'prog-mode)
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  (dolist (hook '(lisp-mode-hook emacs-lisp-mode-hook scheme-mode-hook
                  clojure-mode-hook ruby-mode-hook yaml-mode
                  python-mode-hook shell-mode-hook php-mode-hook
                  css-mode-hook haskell-mode-hook caml-mode-hook
                  nxml-mode-hook crontab-mode-hook perl-mode-hook
                  tcl-mode-hook javascript-mode-hook))
    (add-hook hook 'flyspell-prog-mode)))

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))



(global-set-key (kbd "M-g M-s") 'magit-status)
(global-set-key (kbd "M-g M-c") 'magit-checkout)


(require 'cmake-mode)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("01e067188b0b53325fc0a1c6e06643d7e52bc16b6653de2926a480861ad5aa78" "3eb93cd9a0da0f3e86b5d932ac0e3b5f0f50de7a0b805d4eb1f67782e9eb67a4" "b747fb36e99bc7f497248eafd6e32b45613ee086da74d1d92a8da59d37b9a829" "44c566df0e1dfddc60621711155b1be4665dd3520b290cb354f8270ca57f8788" "ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Custom key bindings
(global-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
(global-set-key (kbd "M-,") 'rtags-location-stack-back)
(global-set-key (kbd "C--") 'shrink-window)
(global-set-key (kbd "C-=") 'enlarge-window)
(global-set-key (kbd "C-M-.") 'rtags-find-symbol)
;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)

(setq show-paren-style 'parenthesis) ; highlight brackets

(setq show-paren-style 'expression) ; highlight entire expression

(setq show-paren-style 'mixed) ; highlight brackets if visible, else entire expression


(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
(add-hook 'objc-mode-hook 'rtags-start-process-unless-running)


(require 'autopair)


;; my own config goes here

;; line number
;;(global-linum-mode t)
;;(when (version<= "26.0.50" emacs-version )
;;  (global-display-line-numbers-mode))

;; ! here ends my own config
