((cl-lib status "installed" recipe
         (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :url "http://elpa.gnu.org/packages/cl-lib.html"))
 (ddskk status "installed" recipe
        (:name ddskk :website "http://openlab.ring.gr.jp/skk/ddskk.html" :description "A Japanese input method on Emacs." :type cvs :module "skk/main" :url ":pserver:guest@openlab.jp:/circus/cvsroot" :options "login" :autoloads nil :info "doc/skk.info" :features
               ("skk-setup")
               :build
               `((,el-get-emacs "-batch" "-q" "-no-site-file" "-l" "SKK-MK" "-f" "SKK-MK-compile")
                 (,el-get-emacs "-batch" "-q" "-no-site-file" "-l" "SKK-MK" "-f" "SKK-MK-compile-info")
                 ("mv" "skk-setup.el.in" "skk-setup.el"))))
 (el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :load "el-get.el"))
 (git-modes status "installed" recipe
            (:name git-modes :description "GNU Emacs modes for various Git-related files" :type github :pkgname "magit/git-modes"))
 (go-mode status "installed" recipe
          (:name go-mode :description "Major mode for the Go programming language" :type http :url "http://go.googlecode.com/hg/misc/emacs/go-mode.el?r=tip" :localname "go-mode.el"))
 (magit status "installed" recipe
        (:name magit :website "https://github.com/magit/magit#readme" :description "It's Magit! An Emacs mode for Git." :type github :pkgname "magit/magit" :depends
               (cl-lib git-modes)
               :info "." :build
               (if
                   (version<= "24.3" emacs-version)
                   `(("make" ,(format "EMACS=%s" el-get-emacs)
                      "all"))
                 `(("make" ,(format "EMACS=%s" el-get-emacs)
                    "docs")))
               :build/berkeley-unix
               (("touch" "`find . -name Makefile`")
                ("gmake")))))
