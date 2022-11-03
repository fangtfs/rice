;;; elpa-lang-plantuml.el --- PlantUML mode -*- lexical-binding: t -*-

;;; Commentary:
;; PlantUML major mode configuration.

;;; Code:

(use-package plantuml-mode
  :custom
  (plantuml-jar-path (locate-user-emacs-file ".cache/plantuml.jar"))
  (plantuml-default-exec-mode 'jar)
  :mode (("\\.puml\\'" . plantuml-mode)
         ("\\.plantuml\\'" . plantuml-mode))
  :config
  (use-package~ org
    :custom
    (org-plantuml-jar-path plantuml-jar-path)
    (org-plantuml-exec-mode plantuml-default-exec-mode)
    :config
    (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
    (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))))


(provide 'elpa-lang-plantuml)
;;; elpa-lang-plantuml.el ends here
