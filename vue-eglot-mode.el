;;; vue-eglot-mode.el --- Get eglot and volar to play nice with each other -*- lexical-binding: t; -*-

;; Author: Skyler Mayfield <skyler544@gmail.com>
;; URL: https://github.com/skyler544/vue-eglot-mode
;; Version: 0.1
;; Package-Requires: ((emacs "30.1") eglot web-mode)
;; Keywords: convenience, languages
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; This package provides a minimal working example for how to get volar and
;; eglot to work with each other.
;;
;; See this discussion for more:
;; https://github.com/joaotavora/eglot/discussions/1184
;;
;; Usage:
;;
;; (use-package vue-eglot-mode
;;   :ensure t
;;   :vc (:url "https://github.com/skyler544/vue-eglot-mode")
;;   :mode "\\.vue$")
;;
;; License:
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.
;;
;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;;; Code:


(require 'eglot)
(require 'web-mode)

;;;###autoload
(define-derived-mode vue-eglot-mode web-mode "Vue")

(defun vue-eglot-init-options ()
  (let ((tsdk-path (expand-file-name
                    "lib"
                    (string-trim-right
                     (shell-command-to-string
                      (concat
                       "NODE_NO_WARNINGS=1 "
                       "npm list --parseable typescript "
                       "| head -n1"))))))
    `(:typescript (:tsdk ,tsdk-path)
                  :vue (:hybridMode :json-false))))

(put 'vue-eglot-mode 'eglot-language-id "vue")

(add-to-list 'eglot-server-programs
             `(vue-eglot-mode . ("vue-language-server"
                                 "--stdio"
                                 :initializationOptions
                                 ,(vue-eglot-init-options))))


(provide 'vue-eglot-mode)
