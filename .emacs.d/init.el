(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

;; env
(setenv "GOROOT" "/usr/local/Cellar/go/1.2.1/libexec")
(setenv "GOPATH" (expand-file-name "~/go"))

(require 'package)
(add-to-list 'package-archives 
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

;; auto install packages.
(el-get 'sync '(go-mode magit))
(el-get 'sync)

(require 'cl)
(defvar installing-package-list
  '(
    exec-path-from-shell
    migemo
    ))

(let ((not-installed (loop for x in installing-package-list
                           when (not (package-installed-p x))
                           collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))

;;path
(exec-path-from-shell-initialize)

;; misc
(line-number-mode 1)
(column-number-mode 1)
(tool-bar-mode 0) 
(blink-cursor-mode 0) 
(display-time)
(recentf-mode)
(iswitchb-mode 1)
(setq visible-bell t)
;;(global-whitespace-mode 1)
;;(mac-input-method-mode 1)

(setq inhibit-startup-message t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default transient-mark-mode t)

;; global key settiongs.
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))
;;(define-key global-map "\C-h" 'delete-backward-char)
(define-key global-map "\M-g" 'goto-line)
(keyboard-translate ?\C-h ?\C-?)
(global-set-key "\C-h" nil)
(global-set-key "\M-h" 'help-command)

;; skk
(require 'skk-autoloads)
(setq default-input-method "japanese-skk")
(setq skk-preload t)
(setq skk-server-host "localhost")
(setq skk-server-portnum 1178)
(setq skk-egg-like-newline t)
(setq mac-pass-control-to-system nil)

;;(setq mac-pass-control-to-system t)

;; font
;; http://d.hatena.ne.jp/setoryohei/20110117/1295336454
;; フォントセットを作る
(let* ((fontset-name "myfonts") ; フォントセットの名前
       (size 12) ; ASCIIフォントのサイズ [9/10/12/14/15/17/19/20/...]
       (asciifont "Menlo") ; ASCIIフォント
       (jpfont "Hiragino Maru Gothic ProN") ; 日本語フォント
       (font (format "%s-%d:weight=normal:slant=normal" asciifont size))
       (fontspec (font-spec :family asciifont))
       (jp-fontspec (font-spec :family jpfont)) 
       (fsn (create-fontset-from-ascii-font font nil fontset-name)))
  (set-fontset-font fsn 'japanese-jisx0213.2004-1 jp-fontspec)
  (set-fontset-font fsn 'japanese-jisx0213-2 jp-fontspec)
  (set-fontset-font fsn '(#x0080 . #x024F) fontspec) ; 分音符付きラテン
  (set-fontset-font fsn '(#x0370 . #x03FF) fontspec) ; ギリシャ文字
  )

;; デフォルトのフレームパラメータでフォントセットを指定
(add-to-list 'default-frame-alist '(font . "fontset-myfonts"))

;; フォントサイズの比を設定
(setq face-font-rescale-alist
      '(("^-apple-hiragino.*" . 1.2)
        (".*osaka-bold.*" . 1.2)
        (".*osaka-medium.*" . 1.2)
        (".*courier-bold-.*-mac-roman" . 1.0)
        (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
        (".*monaco-bold-.*-mac-roman" . 0.9)
        ("-cdac$" . 1.3)))

;; デフォルトフェイスにフォントセットを設定
;; # これは起動時に default-frame-alist に従ったフレームが
;; # 作成されない現象への対処
(set-face-font 'default "fontset-myfonts")


;; color
(global-font-lock-mode t)
(setq default-frame-alist
      (append (list
               '(background-color . "ivory")
               '(foreground-color . "black")
               '(cursor-color . "gray")
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
      (append '(("\\.psgi$" . cperl-mode))  auto-mode-alist ))
(setq auto-mode-alist
      (append '(("\\.t$" . cperl-mode))  auto-mode-alist ))
(setq interpreter-mode-alist
      (append '(("perl" . cperl-mode))
              interpreter-mode-alist ))

;; migemo
(load-library "migemo")
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs" "-i" "\a"))
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)

;; psvn
;;(autoload 'svn-status "psvn" "a emacs mode for subversion" t)

;; magit
(autoload 'magit-status "magit" "An emacs mode for git" t)
(defalias 'git-status 'magit-status)

;; yasnippet
;; http://yasnippet.googlecode.com/
;; (require 'yasnippet)
;; (yas/initialize)
;; (yas/load-directory "~/.emacs.d/snippets")
;; (yas/define-snippets 'nxhtml-mode nil 'html-mode)

;; nxhtml
;;(load-library "nxhtml/autostart")
;; (load-library "nxhtml/autostart")
;; (setq auto-mode-alist
;;        (append '(("\\.tt$" . nxhtml-mode))  auto-mode-alist ))


;; (add-hook 'go-mode-hook
;;           '(lambda()
;;             (setq tab-width 4)
;;             (setq indent-tabs-mode t)
;;             ))
