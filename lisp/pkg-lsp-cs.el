;;; pkg-lsp-cs.el --- C# mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package csharp-mode
  :ensure t
  :hook (csharp-mode . lsp-deferred))

(provide 'pkg-lsp-cs)
;;; pkg-lsp-cs.el ends here
