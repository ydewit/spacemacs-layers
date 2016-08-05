;;; packages.el --- gtdone layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Yuri de Wit <lemao@terra.local>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `gtdone-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `gtdone/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `gtdone/pre-init-PACKAGE' and/or
;;   `gtdone/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst trac-packages
  '(
    ;;(trac-wiki :location local)
    tracwiki-mode
    ))

;; (defun trac/init-trac-wiki ()
;;   (use-package trac-wiki)
;; )

(defun trac/init-tracwiki-mode()
  (use-package tracwiki-mode
    :init
    ;; Code to execute before Helm is loaded
    :config
    ;; Code to execute after Helm is loaded
    (tracwiki-define-project "Gauss" "https://dev.frevvo.com/projects/Gauss" t)
    )
  )
 
;;; packages.el ends here
