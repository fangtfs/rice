;;; init.el --- Configuration entry -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into a number of
;; other files. Templates was from purcell/emacs.d.

;;; Code:

;;==============================================================================
;; Minimal version required
;;==============================================================================

(when (version< emacs-version "26.1")
  (error "Emacs' version is too old. Please use 26.1 and above."))

;;==============================================================================
;; Paths
;;==============================================================================

;; Cache directory for local files
(let ((local-cache-dir (expand-file-name "cache" user-emacs-directory)))
  (unless (file-directory-p local-cache-dir)
      (make-directory local-cache-dir t)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq custom-file (expand-file-name "local.el" user-emacs-directory))

;;==============================================================================
;; Bootstrap
;;==============================================================================

;; Core settings
(require 'init-vanilla)
(require 'init-elpa)
(require 'init-utils)

;; Other packages
(require 'pack-style)
(require 'pack-navigation)
(require 'pack-git)
(require 'pack-typing)
(require 'pack-lsp)
(require 'pack-org)

;;==============================================================================
;; Wrapups
;;==============================================================================

;; Variables configured via the interactive 'customize' interfaces
;; Load this at the last to prevent local configurations from being overridden
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)

;;; Local Variables:
;;; mode: Lisp
;;; coding: utf-8
;;; no-byte-compile: t
;;; End:
;;; init.el ends here
