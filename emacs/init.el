(require 'package)
(setq package-archives '(("gnu"   . "http://1.15.88.122/gnu/")
                         ("melpa" . "http://1.15.88.122/melpa/")))
(package-initialize)

;;; make sure use-package installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;; set-mark-command
(global-set-key (kbd "C-c s") 'set-mark-command)
(global-set-key (kbd "C-o") (lambda ()
                                (interactive)
                                (end-of-line)
                                (newline)))
(global-set-key (kbd "C-O") (lambda ()
                                (interactive)
                                (beginning-of-line)
                                (newline)
                                (previous-line)))

;;; set window move
(global-set-key (kbd "C-<left>")  'windmove-left)
(global-set-key (kbd "C-<right>") 'windmove-right)
(global-set-key (kbd "C-<up>")    'windmove-up)
(global-set-key (kbd "C-<down>")  'windmove-down)

;;; set indent configs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
(defun my-generate-tab-stops (&optional width max)
  "Return a sequence suitable for `tab-stop-list'."
  (let* ((max-column (or max 200))
         (tab-width (or width tab-width))
         (count (/ max-column tab-width)))
    (number-sequence tab-width (* tab-width count) tab-width)))
(setq-default tab-stop-list (my-generate-tab-stops))

;;; line-number mode setting
(setq display-line-numbers-type 'visual)
(setq display-line-numbers-width 4)
(setq display-line-numbers-widen t)
(setq display-line-numbers-format "%4d")
(global-display-line-numbers-mode)

;;; auto-save settings
(auto-save-visited-mode 1)
(add-hook 'c++-mode-hook 'auto-save-visited-mode)

;;; backup file relocate
(setq backup-directory-alist '(("." . "~/.emacs-backups")))

;;; some util functions
(defun check-and-install-program (program &optional install_cmd)
  "Check if PROGRAM is installed, if not, install it."
  (unless (executable-find program)
    (message "Program %s is not installed. Installing..." program)
    (if (boundp install_cmd)
        (shell-command (format "echo jiang186212 | sudo -S %s" install_cmd))
      (shell-command (format "echo jiang186212 | sudo -S apt-get install -y %s" program)))
    (message "Program %s has been installed." program)))

(defun create-compile-commands-json (dir-name)
  "Create compile-commands.json file in build dir"
  (interactive "DDirectory: ")
  (check-and-install-program "bear")
  (let ((default-directory (directory-file-name dir-name)))
    (shell-command "bear -- make -j$(nproc)")))
 
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (let ((default-directory (directory-file-name dir-name)))
    (shell-command
     (format "ctags -f TAGS -e -R %s" (directory-file-name dir-name)))))

;;; neotree settings
(use-package neotree
  :ensure t
  :config
  (global-set-key [f8] 'neotree-toggle))

;;; zenburn
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

;;; pyim settings
;;; 是否应验了我说的那句话，情到深处人孤独
(use-package pyim-basedict
  :ensure t)
(use-package pyim
  :ensure t
  :config
  (pyim-basedict-enable)
  (setq pyim-page-length 5)
  (pyim-default-scheme 'shuangpin))

;;; setup slime for common lisp hacking
(use-package slime
  :ensure t
  :config
  (check-and-install-program "sbcl")
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (require 'slime-autoloads)
  (setq slime-contribs '(slime-fancy)))

;;; completion and code auto-company
(use-package company
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (company-mode 1)
            (setq-local company-backends '(company-elisp))
            (setq-local company-idle-delay 0.2)
            (setq-local company-minimum-prefix-length 2)
            ))
  (add-hook 'c++-mode-hook
          (lambda ()
            (company-mode 1)
            (setq-local company-backends '(company-clang))
            (setq-local company-idle-delay 0.2)
            (setq-local company-minimum-prefix-length 2))))

;;; language server settings'
(defvar my-clangd-exe (executable-find "clangd"))

(use-package eglot
  :ensure t
  :config
  (check-and-install-program "ccls")
  (check-and-install-program "bear")
  (add-hook 'c++-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'global-company-mode)
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'global-company-mode)
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 2)
  (add-to-list 'eglot-server-programs '(c++-mode . ("ccls")))
  (add-to-list 'eglot-server-programs '(c-mode . ("ccls")))
  (add-to-list 'eglot-server-programs '(objc-mode . ("ccls")))
  (add-to-list 'eglot-server-programs '(python-mode . ("pyls"))))

;;; use helm
(use-package helm
  :ensure t
  :bind (("M-x" . 'helm-M-x)
         ("C-x C-f" . 'helm-find-files)
         ("C-x C-b" . 'helm-buffers-list)
         ("C-c c" . 'helm-lisp-completion-at-point)))

;;; use projectile
(use-package projectile
  :ensure t
  :config
  (unless (package-installed-p 'ag)
    (package-install 'ag))
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;;; use magit for git hacking
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;;; org-bullets settings
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package yasnippet-snippets
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

;;; setting for common lisp hacking
(add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode))
(setq-default lisp-indent-offset 4)

;;; perspective mode for window and buffer management
(use-package perspective
  :bind
  ("C-x C-p" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))  ; pick your own prefix key here
  :init
  (persp-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-line-numbers-type 'visual)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
      '(perspective yasnippet-snippets org-bullets lsp-mode ag eglot zenburn-theme neotree pyim-cregexp-utils pyim-basedict pyim magit use-package slime projectile origami company helm cmake-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Monaco" :foundry "APPL" :slant normal :weight normal :height 143 :width normal)))))
