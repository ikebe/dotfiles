(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

(setq load-path (append '("~/.emacs.d/lib") load-path))
(setq exec-path (append 
                 '("~/perl5/perlbrew/bin" "/usr/local/bin") exec-path))
(setenv "PATH"
        (concat '"~/perl5/perlbrew/bin:/usr/local/bin:" (getenv "PATH")))

;; misc
(line-number-mode 1)
(column-number-mode 1)
(tool-bar-mode 0) 
(blink-cursor-mode 0) 
(display-time)
(recentf-mode)
(setq visible-bell t)

(setq inhibit-startup-message t)
(setq-default indent-tabs-mode nil)
(setq-default transient-mark-mode t)

;; global key settiongs.
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))
;;(define-key global-map "\C-h" 'delete-backward-char)
(define-key global-map "\M-g" 'goto-line)
(keyboard-translate ?\C-h ?\C-?)
(keyboard-translate ?\C-? ?\C-h)

;; skk
;; 自動設定に頼る
;;(require 'skk-autoloads)a
;;(setq default-input-method "japanese-skk")
(setq skk-server-host "localhost")
(setq skk-server-portnum 1178)
(setq skk-egg-like-newline t)

;; font
;; http://sakito.jp/emacs/emacs23.html#id15
(create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
(set-fontset-font "fontset-menlokakugo"
                  'unicode
                  (font-spec :family "Hiragino Kaku Gothic ProN" :size 16)
                  nil
                  'append)
(add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))

;; color
(global-font-lock-mode t)
(setq default-frame-alist
      (append (list
       '(background-color . "ivory")
       '(foreground-color . "black")
       '(cursor-color . "navy")
       '(width . 80)
       '(height . 40)
       )
      default-frame-alist))

;; chmod +x
(add-hook 'after-save-hook
          '(lambda ()
             (save-restriction
               (widen)
               (if (string= "#!" (buffer-substring 1 (min 3 (point-max))))
                   (let ((name (buffer-file-name)))
                     (or (char-equal ?. (string-to-char (file-name-nondirectory name)))
                         (let ((mode (file-modes name)))
                           (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                           (message (concat "Wrote " name " (+x)"))))
                     ))))) 

;; cperl-mode
(autoload 'cperl-mode "cperl-mode" "alternate mode for editing Perl programs" t)
(add-hook 'cperl-mode-hook
          '(lambda ()
             (setq fill-column 78)
             (setq auto-fill-mode t)))
(setq cperl-close-paren-offset -4)
(setq cperl-continued-statement-offset 4)
(setq cperl-indent-level 4)
(setq cperl-indent-parens-as-block t)
(setq cperl-tab-always-indent t)

(setq cperl-hairy t)
(setq cperl-highlight-variables-indiscriminately t)
;;(setq cperl-electric-parens t)
;;(setq cperl-electric-linefeed t)
;;(setq cperl-label-offset -4)
;;(setq cperl-auto-newline t)

(setq auto-mode-alist
       (append '(("\\.pm$" . cperl-mode))  auto-mode-alist ))
(setq auto-mode-alist
       (append '(("\\.pl$" . cperl-mode))  auto-mode-alist ))
(setq auto-mode-alist
       (append '(("\\.PL$" . cperl-mode))  auto-mode-alist ))
(setq auto-mode-alist
       (append '(("\\.cgi$" . cperl-mode))  auto-mode-alist ))
(setq auto-mode-alist
       (append '(("\\.t$" . cperl-mode))  auto-mode-alist ))
(setq interpreter-mode-alist
      (append '(("perl" . cperl-mode))
              interpreter-mode-alist ))

(defalias 'perldoc 'cperl-perldoc)

;; migemo
(load-library "migemo")
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs" "-i" "\a"))
(setq migemo-dictionary "/usr/local/share/migemo/euc-jp/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)

;; psvn
(autoload 'svn-status "psvn" "a emacs mode for subversion" t)

;; magit
(autoload 'magit-status "magit" "An emacs mode for git" t)
(defalias 'git-status 'magit-status)
