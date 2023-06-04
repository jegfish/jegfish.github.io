(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
;; (require 'use-package)

(use-package ox-hugo
  :ensure t)

(defconst base-dir
  (let* ((env-key "BASE_DIR")
         (env-value (getenv env-key)))
    (if (and env-value (file-directory-p env-value))
        env-value
      (error (format "%s is not set or is not an existing directory (%s)" env-key env-value)))))

(defun build/export-all ()
  "Export all org-files (including nested) under base-org-files."
  (let ((search-path (file-name-as-directory base-dir)))
    (message (format "[build] Looking for files at %s" search-path))
    (dolist (org-file (directory-files-recursively search-path "\.org$"))
      (with-current-buffer (find-file org-file)
        (message (format "[build] Exporting %s" org-file))
        (org-hugo-export-wim-to-md :all-subtrees nil nil nil)))
    (message "Done!")))

(provide 'build/export-all)
