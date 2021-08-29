;;; pack-typing.el --- Coding convenience -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;==============================================================================
;; Syntax checker
;;==============================================================================

(use-package flycheck
  :diminish flycheck-mode
  :init
  (global-flycheck-mode 1))

;;==============================================================================
;; Code completion
;;==============================================================================

(use-package company
  :diminish company-mode
  :bind (:map company-mode-map
         ("C-c i" . company-complete)
         ([remap completion-at-point] . company-complete)
         ([remap indent-for-tab-command] . company-indent-or-complete-common)
         :map company-active-map
         ("<tab>" . company-complete)
         ("C-SPC" . company-search-abort))
  :init
  (setq company-tooltip-align-annotations t
        company-tooltip-limit 10
        company-tooltip-idle-delay 0.5
        company-idle-delay 0.2
        company-show-numbers t
        company-minimum-prefix-length 1
        company-selection-wrap-around t
        company-auto-complete nil)
  (global-company-mode 1)
  :config
  (company-tng-mode -1))

(use-package company-box
  :hook (company-mode . company-box-mode))

;;==============================================================================
;; Snippets
;;==============================================================================

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(provide 'pack-typing)
;;; pack-typing.el ends here
