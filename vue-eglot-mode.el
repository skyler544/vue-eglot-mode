;;; vue-eglot-mode.el -*- lexical-binding: t -*-

;; https://github.com/joaotavora/eglot/discussions/1184

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
