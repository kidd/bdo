;;; refresh
(defvar bdo-project-dir "/home/kidd/public_html/")
;; (defvar bdo-formats '(css-mode-map js-mode-map html-mode-map ))

(add-to-list 'after-save-hook 'bdo-rf-update)
(defcustom bdo-rf-formats '((html-mode . 'bdo-update)
			    (javascript-generic-mode . 'bdo-update)
			    (erb-mode . 'bdo-update)
			    (css-mode . 'bdo-live-reload)
			    (scss-mode . (lambda () 2)))
  "Modes with the reaction to do. Must be one of the symbols
  'update 'live-reload, or a lambda that will return the
  filename")

(defun bdo-rf-update ()
  (let ((reload-method (member major-mode (mapcar 'car bdo-rf-formats))))
    (when (and reload-method
	       (bdo-desired-subdir)
	       (bdo-want-to-update))
      ((cdr reload-method)))))

(defun bdo-update ()
  (bdo-refresh "bdo-reload"))

(defun bdo-live-reload ()
  (bdo-refresh))

(defun bdo-desired-subdir ()
  (string-match bdo-project-dir (pwd))) ;difference with default-directory?

(defun bdo-want-to-update ()
  (if (boundp 'bdo-updateable)
      bdo-updateable
    (set (make-local-variable 'bdo-updateable)
	 (yes-or-no-p "want to use bdo on this buffer?"))))
