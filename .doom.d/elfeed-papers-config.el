;;; elfeed-papers-config.el --- Elfeed functions for using Elfeed for literature research -*- lexical-binding: t; -*-

(defun concatenate-authors (authors-list)
  "Given AUTHORS-LIST, list of plists; return string of all authors concatenated."
  (if (> (length authors-list) 1)
      (format "%s et al." (plist-get (nth 0 authors-list) :name))
    (plist-get (nth 0 authors-list) :name)))

(defun literature-search-print-fn (entry)
  "Define how each elfeed ENTRY is presented in the final elfeed table."
  (let* ((date (elfeed-search-format-date (elfeed-entry-date entry)))
         (title (or (elfeed-meta entry :title)
                    (elfeed-entry-title entry) ""))
         (title-faces (elfeed-search--faces (elfeed-entry-tags entry)))
         (entry-authors (concatenate-authors
                         (elfeed-meta entry :authors)))
         (title-column (elfeed-format-column title 100 :left))
         (entry-score (elfeed-format-column
                       (number-to-string
                        (elfeed-score-scoring-get-score-from-entry entry))
                       10 :left))
         (authors-column (elfeed-format-column entry-authors 40 :left)))
    (insert (propertize date 'face 'elfeed-search-date-face) " ")
    (insert (propertize title-column
                        'face title-faces 'kbd-help title) " ")
    (insert (propertize authors-column 'kbd-help entry-authors) " ")
    (insert entry-score " ")))

(provide 'elfeed-papers-config)
