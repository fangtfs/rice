;;; pkg-edwina.el --- DWM like window management -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package edwina
  ;; Enabled on demand
  :commands (edwina-mode edwin-mode)
  :config
  (edwina-setup-dwm-keys)
  (edwina-mode 1))

(provide 'pkg-edwina)
;;; pkg-edwina.el ends here
