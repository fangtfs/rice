;;; elpa-lang-python.el --- Python mode -*- lexical-binding: t -*-

;;; Commentary:
;; Python major mode configuration.

;;; Code:

(use-package lsp-python-ms
  :init
  (defun pew/python-mode/setup ()
    "Python LSP mode setup."
    (setq-local indent-tabs-mode nil)
    (setq-local tab-width 4)
    (lsp-deferred))

  :hook (python-mode . pew/python-mode/setup)
  :custom
  (lsp-python-ms-auto-install-server t)
  (lsp-python-ms-python-executable (executable-find "python3"))
  (lsp-python-ms-python-executable-cmd "python3"))

(provide 'elpa-lang-python)
;;; elpa-lang-python.el ends here
