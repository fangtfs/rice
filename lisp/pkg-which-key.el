;;; pkg-which-key.el --- Keybinding hints -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :custom
  (which-key-popup-type 'side-window)
  (which-key-show-early-on-C-h nil)
  (which-key-idle-delay 1.0)
  :config
  (which-key-mode 1)
  ;(which-key-setup-minibuffer)
  (which-key-setup-side-window-bottom))

(provide 'pkg-which-key)
;;; pkg-which-key.el ends here
