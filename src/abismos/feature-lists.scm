(define-module (abismos feature-lists)
  #:use-module (rde features base)
  #:use-module (rde features linux)
  #:use-module (rde features networking)
  #:use-module (rde features fontutils)
  #:use-module (rde features docker)
 #:use-module (rde features virtualization)
  #:use-module (rde features finance)
  #:use-module (rde features image-viewers)
  #:use-module (rde features markup)
  #:use-module (rde features video)
  #:use-module (rde features bittorrent)
 #:use-module (rde features mail)
 ;; #:use-module (rde features irc)
  #:use-module (rde features wm)
  #:use-module (rde features web-browsers)
  #:use-module (rde features bluetooth)
  #:use-module (rde features emacs)
  #:use-module (rde features emacs-xyz)

  #:use-module (rde features gtk)
  #:use-module (gnu services desktop)
  #:use-module (gnu packages scanner)
  #:use-module (gnu packages emacs) ;; emacs com xwidgets
  #:use-module (gnu packages gnome-xyz)
  #:use-module (gnu packages xorg)
  #:use-module (rde features terminals)
  #:use-module (rde features shells)
  #:use-module (rde features shellutils)
  #:use-module (rde features version-control)
 ;; #:use-module (rde features tmux)
  #:use-module (rde features ssh)
  #:use-module (rde packages) ;; pros pacotes base
  #:use-module (guix gexp))


 ;; (define %my-rde-desktop-system-services
 ;;       (modify-services %rde-desktop-system-services
 ;;         (sane-service-type _ => sane-backends)))

(define-public %base-features
  (list
   ;; TODO: merge them into feature-base

    (feature-base-services
    #:guix-substitute-urls
    (list "https://substitutes.nonguix.org")
    #:guix-authorized-keys
    (list (local-file "./nonguix-signing-key.pub"))
    )


   (feature-base-packages
     #:system-packages
     (strings->packages
      "emacs-no-x" "git" "curl" "make" "cryptsetup" "btrfs-progs" "dosfstools" "ripgrep"))

   (feature-desktop-services
    ;; #:default-desktop-system-services %my-rde-desktop-system-services ;;LEARN what's wrong???
    )

   (feature-pipewire)
   (feature-backlight #:step 10)
   (feature-networking)

   (feature-bluetooth)

  ;; (feature-transmission #:auto-start? #f)
   (feature-nyxt)
   (feature-ledger)
   (feature-imv)
   (feature-emacs-emms)
     (feature-mpv)))

(define-public %mail-features
  (list
   (feature-isync #:isync-verbose #t)
   (feature-l2md)
   (feature-msmtp)
   (feature-goimapnotify
    #:notify? #t)
    (feature-emacs-org-mime
    #:html-element-styles
    '(("pre" . "color: #E6E1Dc; background-color: #232323; padding: 0.5em;")
      ("blockquote" . "border-left: 2px solid gray; padding-left: 4px;")))
  ;;(feature-emacs-debbugs)
   ;; (feature-emacs-ebdb
   ;;   #:ebdb-sources (list "~/org/contacts")
   ;;   #:ebdb-popup-size 0.2
    ;;   )
    ))

(define-public %dev-features
  (list
   (feature-markdown
    #:headings-scaling? #t)
   (feature-tex
    #:listings-options
    '(("basicstyle" "\\ttfamily")
      ("stringstyle" "\\color{blue}\\ttfamily")
      ("numbers" "left")
      ("numberstyle" "\\tiny")
      ("breaklines" "true")
      ("showstringspaces" "false")
      ("showtabs" "false")
      ("keywordstyle" "\\color{violet}")
      ("commentstyle" "\\color{gray}")
      ("label" "{Figure}"))
    #:extra-tex-packages
    (strings->packages
     "texlive-wrapfig" "texlive-capt-of"
     "texlive-hyperref" "texlive-ec"
     "texlive-geometry" "texlive-xcolor"
     "texlive-ulem" "texlive-preview"
     "texlive-amsfonts" "texlive-grfext" "texlive-natbib"
     "texlive-titling" "texlive-titlesec" "texlive-enumitem"))))

(define-public %virtualization-features
  (list
   (feature-docker)
     (feature-qemu)
   ))

(define-public %cli-features
  (list
   (feature-alacritty
    ;; TODO: Rename to alacritty-yml
    #:config-file (local-file "./config/alacritty/alacritty.yml")
    #:default-terminal? #f
    #:backup-terminal? #t
    #:software-rendering? #f)
   (feature-vterm)
 ;;  (feature-tmux
 ;;   #:tmux-conf (local-file "./config/tmux/tmux.conf"))
   (feature-zsh
    #:enable-zsh-autosuggestions? #t)
   (feature-bash)
   (feature-direnv)
   (feature-git #:sign-commits? #f)
   (feature-ssh)))

(define-public %ui-features
  (list
   (feature-gtk3
    #:gtk-dark-theme? #t
    #:gtk-theme (make-theme "Arc" arc-theme)
    #:icon-theme (make-theme "Arc" arc-icon-theme)
    #:cursor-theme (make-theme "Hackneyed" hackneyed-x11-cursors)
    ;;#:extra-gtk-css #t não funciona!
    #:extra-gtk-settings '((gtk-cursor-blink . #f))
   )
   (feature-fonts
    #:use-serif-for-variable-pitch? #t
    #:font-serif
    (font
     (name "Iosevka Etoile")
     (size 13)
     (package (@ (gnu packages fonts) font-iosevka-etoile)))
    #:font-monospace
    (font
     (name "Iosevka")
     (package (@ (gnu packages fonts) font-iosevka))
     (size 11)
     (weight 'regular))
    ;; #:font-monospace (font "Fira Mono" #:size 14 #:weight 'semi-light)
    ;; #:font-packages (list font-fira-mono)
    #:default-font-size 11)

   ;; https://sr.ht/~tsdh/swayr/
   ;; https://github.com/ErikReider/SwayNotificationCenter
   ;; https://github.com/swaywm/sway/wiki/i3-Migration-Guide

   ;; https://github.com/natpen/awesome-wayland
   (feature-sway)
   (feature-sway-run-on-tty
    #:sway-tty-number 2)
   (feature-sway-screenshot)
   ;; (feature-sway-statusbar
   ;;  #:use-global-fonts? #f)
   (feature-waybar
    #:waybar-modules (list
                      (waybar-sway-workspaces
                       #:format-icons '(("1" . ) ;
                                        ("2" . ) ; 
                                        ("3" . ) ; 
                                        ("4" . )
                                        ("5" . )
                                        ("6" . )  ; 

                                        ("7" . )  ; 
                                        ("8" . )
                                        ("9" . ) ;  
                                        ("10" . )

                                        ("urgent" . )
                                        ("focused" . )
                                        ("default" . )))
                      (waybar-sway-window)
                       (waybar-tray)
                      (waybar-idle-inhibitor)
                      (waybar-sway-language)
                      (waybar-microphone)
                      (waybar-volume)
                      (waybar-temperature)
                      (waybar-memory)
                      (waybar-cpu)
                      (waybar-disk)
                      (waybar-battery #:intense? #f)
                      (waybar-clock)
                     ))
   (feature-swayidle)
   (feature-swaylock
    ;; #:swaylock (@ (gnu packages wm) swaylock-effects)
    ;; ;; The blur on lock screen is not privacy-friendly.
    ;; #:extra-config '((screenshots)
    ;;                  ;;(effect-blur . 7x5)
    ;;                  (clock))
    )))

(define-public %emacs-features
  (list
   (feature-emacs
    #:emacs emacs-next-pgtk-xwidgets
    #:default-application-launcher? #t
    #:extra-init-el '(
                      (add-to-list 'load-path "/home/igorz/projects/wintermute-rde-configs/src/abismos/config/emacs/lisp/")
                      (guix-emacs-autoload-packages)
                      ;;...and become available for `require`.
                      (setq org-refile-targets '(("~/org/todo.org" :maxlevel . 9)
   			      ("~/org/someday.org" :maxlevel . 9)
			      ("~/org/inbox.org" :maxlevel . 9)))
                      (setq org-refile-allow-creating-parent-nodes 'confirm)
                      ;;https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html
                       (global-visual-line-mode t)
                       (global-hl-line-mode t)
                       (load-theme 'modus-vivendi-tinted)
                       (defun meow-setup ()
                         (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
                         (meow-motion-overwrite-define-key
                          '("j" . meow-next)
                          '("k" . meow-prev)
                          '("<escape>" . ignore))
                         (meow-leader-define-key
                          ;; SPC j/k will run the original command in MOTION state.
                          '("j" . "H-j")
                          '("k" . "H-k")
                          ;; Use SPC (0-9) for digit arguments.
                          '("1" . meow-digit-argument)
                          '("2" . meow-digit-argument)
                          '("3" . meow-digit-argument)
                          '("4" . meow-digit-argument)
                          '("5" . meow-digit-argument)
                          '("6" . meow-digit-argument)
                          '("7" . meow-digit-argument)
                          '("8" . meow-digit-argument)
                          '("9" . meow-digit-argument)
                          '("0" . meow-digit-argument)
                          '("/" . meow-keypad-describe-key)
                          '("?" . meow-cheatsheet))
                         (meow-normal-define-key
                          '("0" . meow-expand-0)
                          '("9" . meow-expand-9)
                          '("8" . meow-expand-8)
                          '("7" . meow-expand-7)
                          '("6" . meow-expand-6)
                          '("5" . meow-expand-5)
                          '("4" . meow-expand-4)
                          '("3" . meow-expand-3)
                          '("2" . meow-expand-2)
                          '("1" . meow-expand-1)
                          '("-" . negative-argument)
                          '(";" . meow-reverse)
                          '("," . meow-inner-of-thing)
                          '("." . meow-bounds-of-thing)
                          '("[" . meow-beginning-of-thing)
                          '("]" . meow-end-of-thing)
                          '("a" . meow-append)
                          '("A" . meow-open-below)
                          '("b" . meow-back-word)
                          '("B" . meow-back-symbol)
                          '("c" . meow-change)
                          '("d" . meow-delete)
                          '("D" . meow-backward-delete)
                          '("e" . meow-next-word)
                          '("E" . meow-next-symbol)
                          '("f" . meow-find)
                          '("g" . meow-cancel-selection)
                          '("G" . meow-grab)
                          '("h" . meow-left)
                          '("H" . meow-left-expand)
                          '("i" . meow-insert)
                          '("I" . meow-open-above)
                          '("j" . meow-next)
                          '("J" . meow-next-expand)
                          '("k" . meow-prev)
                          '("K" . meow-prev-expand)
                          '("l" . meow-right)
                          '("L" . meow-right-expand)
                          '("m" . meow-join)
                          '("n" . meow-search)
                          '("o" . meow-block)
                          '("O" . meow-to-block)
                          '("p" . meow-yank)
                          '("q" . meow-quit)
                          '("Q" . meow-goto-line)
                          '("r" . meow-replace)
                          '("R" . meow-swap-grab)
                          '("s" . meow-kill)
                          '("t" . meow-till)
                          '("u" . meow-undo)
                          '("U" . meow-undo-in-selection)
                          '("v" . meow-visit)
                          '("w" . meow-mark-word)
                          '("W" . meow-mark-symbol)
                          '("x" . meow-line)
                          '("X" . meow-goto-line)
                          '("y" . meow-save)
                          '("Y" . meow-sync-grab)
                          '("z" . meow-pop-selection)
                          '("'" . repeat)
                          '("<escape>" . ignore)))
                       (require 'meow)
                       (meow-setup)
                       (meow-global-mode 1)

                      ;; OBS: The functions below call copyrighted fonts I bought many years ago and still like to use when writing/reading prose.
                      ;; I keep the backup font files in my ~/reference/fonts directory. "To install the local font file, drop the font or folder with the font in (/home/.local/share/fonts). If the fonts folder does not exist, create it!" (Ref:https://unix.stackexchange.com/questions/628932/install-fonts-in-guix-system and https://guix.gnu.org/en/manual/en/guix.html#X11-Fonts)
                      (defun set-font-olivetti-mode-skolar ()
                        (interactive)
                        (setq buffer-face-mode-face '(:family "Skolar Basic" :height 120))
                        (buffer-face-mode))
                       (defun set-font-olivetti-mode-nitti ()
                        (interactive)
                        (setq buffer-face-mode-face '(:family "Nitti Light" :height 120))
                        (buffer-face-mode))
                       (fset 'yes-or-no-p 'y-or-n-p)
                       ;; telephone-line? see: https://esrh.me/posts/2021-11-27-emacs-config.html#frame
                       (doom-modeline-mode 1)
                       (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
                       (setq ispell-choices-win-default-height 4)

;;;; Old GTD config
                       ;;org-agenda
                       (require 'org-super-agenda)
                       (org-super-agenda-mode 1)
                       (load "org-agenda-property.el")
                       (require 'org-agenda-property)
                       ;; dependência do org-gtd
                       (require 'org-edna) ;; dependência do org-gtd
                       (setq org-edna-use-inheritance t)
                       (org-edna-mode 1)
                       ;; (setq org-agenda-start-with-log-mode t)
                       ;; (setq org-log-done 'time)
                       ;;(setq org-log-into-drawer t)
                       ;;;; org-agenda aparece como janela
                       ;;(setq org-agenda-window-setup 'other-window)
                       ;;(setq org-agenda-follow-mode t)
                       ;;
                       ;; ;;; https://github.com/rougier/emacs-gtd função para marcar data de ativação NEXT :
                       (defun log-todo-next-creation-date (&rest IGNORE)
                         "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
                         (when (and (string= (org-get-todo-state) "NEXT")
                                    (not (org-entry-get nil "ACTIVATED")))
                           (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
                       (add-hook 'org-after-todo-state-change-hook 'log-todo-next-creation-date)
                       ;;
                       ;;
                       ;;;;;;; AGENDA CUSTOM COMANDS ;;;;;;;;;;;;
                       ;;;;;;;https://github.com/james-stoup/emacs-org-mode-tutorial#orgc157736
                       ;;;;;;;;; https://doc.endlessparentheses.com/Var/org-agenda-prefix-format.html
                       ;;;;;;;;; https://www.labri.fr/perso/nrougier/GTD/index.html#org2d62325
                       (setq org-super-agenda-header-map (make-sparse-keymap))
                       (setq org-agenda-include-diary t)
                       (setq org-agenda-hide-tags-regexp ".")
                       (setq org-agenda-prefix-format
                             '((agenda . " %i %-12:c%?-12t% s")
                               (todo   . " %i %-12:c")
                               (tags   . " %i %-12:c")
                               (search . " %i %-12:c")))

                       (setq org-agenda-custom-commands '(

                                                          ("g" "Get Things Done (GTD)"
                                                           (
                                                            (agenda ""
                                                                    (
                                                                     (org-agenda-remove-tags t)
                                                                     (org-agenda-span 7)
		                                                     (org-agenda-start-with-log-mode t)
		                                                     (org-agenda-show-log 'all)
                                                                     (org-agenda-log-mode-items '(clock state))
                                                                     ))
	                                                    (todo "NEXT"
                                                                  (
                                                                   ;; Remove tags to make the view cleaner
                                                                   (org-agenda-remove-tags t)
                                                                   (org-agenda-prefix-format "  %t  %s ")
                                                                   (org-agenda-overriding-header "Próximas Ações")

                                                                   ;; Define the super agenda groups (sorts by order)
                                                                   (org-super-agenda-groups
                                                                    '(
                                                                      ;; Filters
                                                                      (:name "Trabalho"
		                                                       :and (:tag "trabalho")
		                                                       :order 0)


		                                                      ;;exemplos de filtros possíveis
		                                                      ;; (:name "SBF - Demandas em Geral"
		                                                      ;; 	      :and (:tag "sbf" :not (:tag "redes_sociais" :tag "boletim" :tag "antessala_ensino"))

		                                                      ;; 	      :order 4)
                                                                      (:name "Organização e Finanças"
		                                                       :tag "organizar"
                                                                       :order 1
                                                                       )
		                                                      (:name "Estudos e Hobbies"
                                                                       :tag "estudos"
                                                                       :order 3
                                                                       )
		                                                      (:name "Saúde"
                                                                       :tag "saúde"
                                                                       :order 2
                                                                       )

	                                                              (:name "Relacionamentos"
                                                                       :tag "relacionamentos"
                                                                       :order 4
                                                                       )
		                                                      (:name "Lazer"
                                                                       :tag "lazer"
                                                                       :order 5
                                                                       )
		                                                      ))
		                                                   ))

	                                                    (todo "PROJ"
		                                                  ( (org-agenda-overriding-header "Projetos Ativos")
		                                                    (org-agenda-prefix-format "  %t  %s ")

		                                                    ;; Define the super agenda groups (sorts by order)
                                                                    (org-super-agenda-groups
                                                                     '(
                                                                       ;; Filters
                                                                       (:name "Trabalho"
		                                                        :and (:tag "trabalho")
		                                                        :order 0)

                        	                                       ;;exemplos de filtros
		                                                       ;; (:name "SBF - Demandas em Geral"
		                                                       ;; :and (:tag "sbf" :not (:tag "redes_sociais" :tag "boletim" :tag "antessala_ensino"))

		                                                       ;; :order 4)
                                                                       (:name "Organização e Finanças"
		                                                        :tag "organizar"
                                                                        :order 5
                                                                        )
		                                                       (:name "Estudos e Hobbies"
                                                                        :tag "estudos"
                                                                        :order 6
                                                                        )
		                                                       (:name "Saúde"
                                                                        :tag "saúde"
                                                                        :order 7
                                                                        )

	                                                               (:name "Relacionamentos"
                                                                        :tag "relacionamentos"
                                                                        :order 8
                                                                        )
		                                                       (:name "Lazer"
                                                                        :tag "lazer"
                                                                        :order 9
                                                                        )
		                                                       ))

		                                                    ))
	                                                    (tags "CLOSED>=\"<today>\""
                                                                  ((org-agenda-overriding-header "\nCompleted today\n")))

	                                                    (tags "inbox"
                                                                  ((org-agenda-prefix-format "  %?-12t% s")
                                                                   (org-agenda-overriding-header "\nInbox\n")))
	                                                    ))))
                       (require 'openwith)
                       (setq openwith-associations
                             (list
                              ;; (list (openwith-make-extension-regexp
                              ;;        '("xbm" "pbm" "pgm" "ppm" "pnm"
                              ;;          "png" "gif" "bmp" "tif" "jpeg" "jpg"))
                              ;;       "feh"
                              ;;       '(file))
                              (list (openwith-make-extension-regexp
                                     '("doc" "docx" "rtf" "xls" "odt"))
                                    "libreoffice"
                                    '(file))
                               (list (openwith-make-extension-regexp
                                      '("mp4"))
                                     "mpv"
                                     '(file))
                              (list (openwith-make-extension-regexp
                                     '("cbr" "cbz"))
                                    "YACReader"
                                    '(file))
	                      ))
                       (openwith-mode t)
                       (setq org-agenda-include-diary t)
                       (load "brazilian-holidays.el")
                       (require 'brazilian-holidays)
                       (setq brazilian-sp-holidays t)
                       (org-add-link-type "mpv" (lambda (path) (browse-url-xdg-open path)))))



   ;; UI
   (feature-emacs-appearance
    #:header-line-as-mode-line? #f)
   (feature-emacs-all-the-icons)
    (feature-emacs-graphviz)
   (feature-emacs-modus-themes
    #:dark? #f
    #:deuteranopia? #f
    #:headings-scaling? #f
    #:extra-modus-themes-overrides '((cursor bg-graph-blue-0))
    )

   (feature-emacs-completion
    #:mini-frame? #f
    #:marginalia-align 'right)
   (feature-emacs-corfu
    #:corfu-doc-auto #f)
   (feature-emacs-vertico)

   (feature-emacs-tramp)
   (feature-emacs-project)
   (feature-compile)
   (feature-emacs-perspective)
   ;; (feature-emacs-input-methods) ;;este interfere na cor do cursor
   (feature-emacs-which-key)
    (feature-emacs-help)
    (feature-emacs-dired)
    (feature-emacs-shell)
   (feature-emacs-eshell)
   (feature-emacs-monocle)

    (feature-emacs-message)
   ;;(feature-emacs-erc
   ;; #:erc-log? #t
   ;; #:erc-autojoin-channels-alist '((Libera.Chat "#rde")))
   ;;(feature-emacs-telega)
   ;; (feature-emacs-elpher)

       (feature-emacs-info)
   (feature-emacs-pdf-tools)
   (feature-emacs-nov-el)
   (feature-emacs-org-protocol)



   ;; TODO: Remove auctex dependency, which interjects in texinfo-mode.




   (feature-emacs-citar
    #:citar-library-paths (list "~/reference/calibre-library/"
                                "~/projects/")
    #:citar-notes-paths (list "~/org/notes")
    #:global-bibliography (list "~/org/references.bib"))
 ;; (feature-emacs-ednc
 ;;    #:notifications-icon "")
   (feature-emacs-smartparens
    #:show-smartparens? #t)
   (feature-emacs-geiser)
   (feature-emacs-guix
    #:guix-directory "~/src/guile/guix")
  (feature-emacs-flymake)
(feature-emacs-eglot)
 (feature-emacs-xref)
   (feature-emacs-calc)
   (feature-emacs-re-builder)
   (feature-emacs-ace-window)
    (feature-emacs-browse-url)
   (feature-emacs-webpaste)))

(define-public %general-features
  (append
   %base-features
   %dev-features
   %cli-features
   %ui-features
   %emacs-features))

(define-public %all-features
  (append
   %base-features
   %dev-features
   %virtualization-features
   %mail-features
   %cli-features
   %ui-features
   %emacs-features))
