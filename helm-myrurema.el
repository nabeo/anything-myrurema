;;; helm-myrurema.el --- Helm Interface for myrurema

;; Copyright (C) 2012 mori-dev, nabeo

;; Author: mori-dev <mori.dev.asdf@gmail.com>, nabeo <watanabe.michikazu@gmail.com>
;; Keywords: ruby

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Installation:

;; install requires libraries:
;; `myrurema'              https://rubygems.org/gems/myrurema
;; `helm.el'               https://github.com/emacs-helm/helm
;; `helm-config.el'        https://github.com/emacs-helm/helm
;; `helm-match-plugin.el'  https://github.com/emacs-helm/helm

;; `helm-myrurema.el'      https://github.com/nabeo/anything-myrurema (this file)

;;; Usage
;;
;; (require 'helm-myrurema)
;;
;; M-x helm-myrurema

;;; Code:

(require 'cl)
(require 'helm)
(require 'helm-config)

(defvar helm-myrurema-index-path "~/.emacs.d/myrurema.index")

(defvar helm-c-source-myrurema
      `((name . "myrurema")
        (candidates-file . ,helm-myrurema-index-path)
        (candidate-number-limit . 100000)
        (action . (("emacs でるりまを見る" . (lambda (c) (helm-myrurema-show-rurema c)))
                   ("ブラウザでるりまサーチ" . (lambda (c) (helm-myrurema-rurema-search c)))))))

(defun helm-myrurema-get-docstring (s)
  (cond
   ((executable-find "rurema")
    (shell-command-to-string (format "rurema --no-ask %s" (shell-quote-argument s))))
   (t
    "can't find \"rurema\" command")))

(defun helm-myrurema-show-rurema (candidate)
    (let ((docstring (helm-myrurema-get-docstring candidate))
           (buf (get-buffer-create "*rurema-result*")))
      (with-current-buffer buf
        (erase-buffer)
        (insert docstring)
        (goto-char (point-min))
        (delete-region (point) (save-excursion (end-of-line) (point)))
        (delete-blank-lines))
      (switch-to-buffer buf)))

(defun helm-myrurema-rurema-search (candidate)
    (browse-url (format "http://rurema.clear-code.com/query:%s/" (url-hexify-string candidate))))

(defun helm-myrurema ()
  "anything myrurema"
  (interactive)
  (helm-other-buffer 'helm-c-source-myrurema "*helm myrurema*"))

(provide 'helm-myrurema)
