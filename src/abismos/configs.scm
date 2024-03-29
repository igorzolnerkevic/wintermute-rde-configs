(define-module (abismos configs)
  #:use-module (abismos feature-lists)
  #:use-module (abismos hosts wintermute)
;;  #:use-module (abismos hosts live)
  #:use-module (rde features)
  #:use-module (rde features base)
  #:use-module (rde features linux)
  #:use-module (rde features gnupg)
 ;; #:use-module (rde features irc)
  #:use-module (rde features keyboard)
  #:use-module (rde features system)
  #:use-module (rde features xdg)
  #:use-module (rde features password-utils)
  #:use-module (rde features emacs-xyz)
  #:use-module (rde features mail)
  #:use-module (rde features networking)
  #:use-module (rde features clojure)
  #:use-module (rde features python)
  #:use-module (contrib features javascript)

  #:use-module (rnrs lists)
  #:use-module (gnu services)
  #:use-module (gnu services cups)
  #:use-module (gnu services nix)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services xdg)
  #:use-module (rde home services emacs)
  #:use-module (rde home services wm)
;;  #:use-module (rde home services i2p)

  #:use-module (rde system services admin)     ;;sudoers extra
  #:use-module (rde features video)
  #:use-module (rde home services video)
  #:use-module (gnu home-services ssh)

  #:use-module (gnu packages)
  #:use-module (gnu packages gnome-xyz)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages web)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages package-management)
  #:use-module (rde packages)
  #:use-module (rde packages aspell) ; needed for strings->packages

  #:use-module (guix gexp)
  #:use-module (guix inferior)
  #:use-module (guix channels)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (ice-9 match))


;;; Helpers
(define* (mail-acc id user #:optional (type 'gmail))
  "Make a simple mail-account with gmail type by default."
  (mail-account
   (id   id)
   (fqda user)
   (type type)))

(define* (mail-lst id fqda urls)
  "Make a simple mailing-list."
  (mailing-list
   (id   id)
   (fqda fqda)
   (config (l2md-repo
            (name (symbol->string id))
            (urls urls)))))


;;; Service extensions

(define emacs-extra-packages-service
  (simple-service
   'emacs-extra-packages
   home-emacs-service-type
   (home-emacs-extension
    (init-el
     `((with-eval-after-load 'piem
         (setq piem-inboxes
               '(("guix-devel"
                  :url "https://yhetil.org/guile-devel/"
                  :address "guile-devel@gnu.org"
                  :coderepo "~/public-inboxes/guile")
                 ("guix-patches"
                  :url "https://yhetil.org/guix-patches/"
                  :address "guix-patches@gnu.org"
                  :coderepo "~/public-inboxes/guix/")
                 ("rde-devel"
                  :url "https://lists.sr.ht/~abcdw/rde-devel"
                  :address "~abcdw/rde-devel@lists.sr.ht"
                  :coderepo "~/public-inboxes/rde/"))))
      (with-eval-after-load 'org
         (setq org-use-speed-commands t)
         (define-key org-mode-map (kbd "M-o")
           (lambda ()
             (interactive)
             (org-end-of-meta-data t))))
       (with-eval-after-load 'simple
         (setq-default display-fill-column-indicator-column 80)
         (add-hook 'prog-mode-hook 'display-fill-column-indicator-mode))

       (with-eval-after-load 'geiser-mode
         (defun abcdw-geiser-connect ()
           (interactive)
           (geiser-connect 'guile "localhost" "37146"))

         (define-key geiser-mode-map (kbd "C-c M-j") 'abcdw-geiser-connect))
       (with-eval-after-load 'simple
         (setq-default display-fill-column-indicator-column 80)
         (add-hook 'prog-mode-hook 'display-fill-column-indicator-mode))
       (setq copyright-names-regexp
             (format "%s <%s>" user-full-name user-mail-address))
       (add-hook 'after-save-hook (lambda () (copyright-update nil nil)))))
    (elisp-packages
     (append
      (list
       (@ (rde packages emacs-xyz) emacs-clojure-ts-mode)
       (@ (rde packages emacs-xyz) emacs-combobulate))
      (strings->packages
       "emacs-piem"
       "emacs-writegood-mode"
       "emacs-org-super-agenda"
       "emacs-org-edna"
       "emacs-org-contacts"
       "emacs-fountain-mode"
       "emacs-openwith"
       "emacs-nix-mode"
       "emacs-ox-haunt"
       "emacs-ox-pandoc"
       "emacs-org-pandoc-import"
       "emacs-haskell-mode"
       "emacs-meow"
       "emacs-use-package"
       ;; "emacs-telephone-line"
       "emacs-doom-modeline"
       "emacs-pinentry"
        ;;"emacs-dirvish"
       "emacs-doom-themes"
       "emacs-rainbow-mode"
       "emacs-hl-todo"
       "emacs-yasnippet"
        "emacs-company"
       "emacs-consult-dir"
       "emacs-all-the-icons-completion" "emacs-all-the-icons-dired"
       "emacs-kind-icon"
       "emacs-nginx-mode" "emacs-yaml-mode"
       "emacs-ytdl"
       "emacs-multitran"
       ;;"emacs-transmission"
       "emacs-minimap"
       ;; "emacs-ement"
       "emacs-restart-emacs"
       "emacs-org-present"
       "emacs-rainbow-delimiters"))))))

(define home-extra-packages-service
  (simple-service
   'home-profile-extra-packages
   home-profile-service-type
   (append
    (list
     (@ (gnu packages tree-sitter) tree-sitter-clojure)
     (@ (gnu packages tree-sitter) tree-sitter-html))
    (strings->packages
     "figlet" ;; TODO: Move to emacs-artist-mode
     "gnome-disk-utility"
     "docker-compose"
     "pandoc"
     "calibre"
     "mcomix"
     "sameboy"
     "picard"
     "blender"
     "inkscape"
     "gimp"
     "shotwell"
     "ardour"
     "audacity"
     "wireplumber"
     "mpd"
     "ncmpcpp"
     "docker-compose"
     "nyxt"
     "light"
     "transmission"
   "transmission-remote-gtk"
    "alsa-utils" "yt-dlp" "cozy"
     "pavucontrol" "wev"
     "imagemagick"
     "obs" "obs-wlrobs"
     "recutils" "binutils" "make"
     "hicolor-icon-theme"
    "adwaita-icon-theme"
    "gnome-themes-extra"
    "gnome-tweaks"
    "hackneyed-x11-cursors"
     "arc-theme"
     "arc-icon-theme"
     "gvfs"
     "sshfs"
     "mosh"
     "thunar"
     "nautilus"
     "fd"
     "vim"
     "fuzzel"
    "font-termsyn"
     "font-scientifica"
     "font-hack"
     "font-fira-code"
     "font-adobe-source-han-sans"
     "font-google-roboto"
     "font-gnu-freefont"
     "font-ghostscript"
     "font-dejavu"
     "font-microsoft-web-core-fonts"
     "font-terminus"
     "font-jetbrains-mono"
     "font-google-noto"
     "font-google-noto-emoji"
     "btrbk"
     "vorta"
     "firefox" ;; nonguix channel
     "icecat"
     ;;"ungoogled-chromium-wayland"
         ;; "nix"
        "gammastep"
     "mbpfan"
     ;;"htop"
     ;;"atop"
     "evince"
     ;;"sane-backends"
     ;;"print-manager"
     ;;"hplip"
     ;;"archivebox" ;;doesn´t compile
     "gnome-system-monitor"
     "unzip"
     "kdeconnect"
     "wine"
     "winetricks"
     "libreoffice"
     "ffmpeg"
     "haunt"
     "ripgrep" "curl"))))

;; (define (wallpaper url hash)
;;   (origin
;;     (method url-fetch)
;;     (uri url)
;;     (file-name "wallpaper.png")
;;     (sha256 (base32 hash))))

;; (define wallpaper-ai-art
;;   (wallpaper "https://w.wallhaven.cc/full/j3/wallhaven-j3m8y5.png"
;;              "0qqx6cfx0krlp0pxrrw0kvwg6x40qq9jic90ln8k4yvwk8fl1nyw"))

;; (define wallpaper-dark-rider
;;   (wallpaper "https://w.wallhaven.cc/full/lm/wallhaven-lmlzwl.jpg"
;;              "01j5z3al8zvzqpig8ygvf7pxihsj2grsazg9yjiqyjgsmp00hpaf"))



(define sway-extra-config-service
  (simple-service
   'sway-extra-config
   home-sway-service-type
   `((output DP-2 scale 1) ;;mudei pra 1, mas precisa ser 2?
     ;; (output * bg ,wallpaper-ai-art center)
     ;; (output eDP-1 disable)
      ;;    ,@(map (lambda (x) `(workspace ,x output DP-2)) (iota 8 1) ;;o que é isso???
     (exec gammastep-indicator -l -23.53:-46.63 -m wayland -t 8500:2500 &)
    ;; (exec sudo mbpfan)
     ;; (exec emacs)
    ;; (exec vorta)


     ;; (workspace 9 output DP-2)
     ;; (workspace 10 output DP-2)

     ;; (bindswitch --reload --locked lid:on exec /run/setuid-programs/swaylock)

     (bindsym
      --locked $mod+Shift+t exec
      ,(file-append (@ (gnu packages music) playerctl) "/bin/playerctl")
      play-pause)

     (bindsym
      --locked $mod+Shift+n exec
      ,(file-append (@ (gnu packages music) playerctl) "/bin/playerctl")
      next)

     (bindsym $mod+Shift+o move workspace to output left)
     (bindsym $mod+Ctrl+o focus output left)
     (input type:touchpad
            ;; TODO: Move it to feature-sway or feature-mouse?
            ( (natural_scroll enabled)
              (dwt enabled)
              (tap enabled)
              (middle_emulation enabled)))
;;(bindsym $mod+Control+Shift+d split v, exec $menu)
     ;; (xwayland disable)
     (bindsym $mod+a exec alacritty)
     (bindsym $mod+Alt+f exec firefox)
     (bindsym $mod+Alt+Space exec fuzzel)
    (bindsym XF86KbdBrightnessDown exec sudo light -Us "sysfs/leds/smc::kbd_backlight" 10)
     (bindsym XF86KbdBrightnessUp exec sudo light -As "sysfs/leds/smc::kbd_backlight" 10)
     (bindsym $mod+Shift+Return exec emacs))))

 (define sudoers-extra-service
   (simple-service
    'sudoers-extra
    sudoers-service-type
    (list "%wheel ALL=(ALL) NOPASSWD: ALL")))

;; printing and scanners

;; (define add-sane-service-type
;;  (service sane-service-type))

;; (define add-sane-backends
;;   (simple-service
;;    'add-sane-extra-settings
;;    sane-service-type
;;    (modify-services sane-service-type
;;                     (sane-service-type _ => sane-backends))))
;;
;;;; still figuring it out... Don´t work

(define add-cups-service
  (service cups-service-type
			  (cups-configuration
			   (web-interface? #t)
			   (extensions
                            (list cups-filters epson-inkjet-printer-escpr hplip)))))

(define add-nix-service
  (service nix-service-type))

(define mpv-add-user-settings-service
  (simple-service
   'add-mpv-extra-settings ;;-irc
   home-mpv-service-type
   (home-mpv-extension
    (mpv-conf
     `((global
        ((keep-open . yes)
         (ytdl-format . "bestvideo[height<=?1080][fps<=?30][vcodec!=?vp9]+bestaudio/best")
         (save-position-on-quit . yes)
         (speed . 1.00))))))))

;; (define i2pd-add-ilita-irc-service
;;   (simple-service
;;    'i2pd-add-ilita-irc
;;    home-i2pd-service-type
;;    (home-i2pd-extension
;;     (tunnels-conf
;;      `((IRC-ILITA ((type . client)
;;                    (address . 127.0.0.1)
;;                    (port . 6669)
;;                    (destination . irc.ilita.i2p)
;;                    (destinationport . 6667)
;;                    (keys . ilita-keys.dat))))))))




(define ssh-extra-config-service
  (simple-service
   'ssh-extra-config
   home-ssh-service-type
   (home-ssh-extension
    (extra-config
     (append
      ;; TODO: Move it feature-qemu?
      (map (lambda (id)
             (ssh-host
              (host (format #f "qemu~a" id))
              (options
               `((host-name . "localhost")
                 (port . ,(+ 10020 id))))))
           (iota 4))
      (list
       ;; (ssh-host
       ;;  (host "pinky-ygg")
       ;;  (options
       ;;   '((host-name . "200:554d:3eb1:5bc5:6d7b:42f4:8792:efb8")
       ;;     (port . 50621)
       ;;     (control-master . "auto")
       ;;     (control-path . "~/.ssh/master-%r@%h:%p")
       ;;     (compression . #t))))
        ;; (ssh-host
        ;; (host "neuromancer")
        ;; (options
        ;;  '((host-name . "192.168.15.20")
        ;;    (port . 22)
        ;;    (compression . #f))))
       ;; (ssh-host
       ;;  (host "pinky")
       ;;  (options
       ;;   '((host-name . "23.137.249.202")
       ;;     (port . 50621)
       ;;     (compression . #t))))
       )))
    (toplevel-options
     '((host-key-algorithms . "+ssh-rsa")
       (pubkey-accepted-key-types . "+ssh-rsa"))))))

(define extra-shepherd-services-service
  (simple-service
   'run-syncthing-on-userspace
   home-shepherd-service-type
   (list
    (shepherd-service
     (provision '(syncthing))
     (documentation "Run syncthing.")
     (start #~(make-forkexec-constructor
               (list #$(file-append (@ (gnu packages syncthing) syncthing)
                                    "/bin/syncthing")
                     "-no-browser" "-no-restart")))
     (respawn? #f)
     (stop #~(make-kill-destructor))))))


;;; User-specific features with personal preferences

;; Initial user's password hash will be available in store, so use this
;; feature with care (display (crypt "hi" "$6$abc"))

(define %abismos-features
  (list
   (feature-user-info
    #:user-name "igorz"
    #:full-name "Igor Zolnerkevic"
    #:email "igorz@abismos.net"
   ;;  #:user-initial-password-hash "$6$abc$3SAZZQGdvQgAscM2gupP1tC.SqnsaLSPoAnEOb2k6jXMhzQqS1kCSplAJ/vUy2rrnpHtt6frW2Ap5l/tIvDsz."
     ;; (crypt "bob" "$6$abc")

    ;; WARNING: This option can reduce the explorability by hiding
    ;; some helpful messages and parts of the interface for the sake
    ;; of minimalistic, less distractive and clean look.  Generally
    ;; it's not recommended to use it.
    #:emacs-advanced-user? #t)
    (feature-gnupg
     #:gpg-primary-key "FBB1DA5503E99B63" ;;from my subkey dedicated to authentication only
     #:ssh-keys '(("3211C53919F2A6531BAB58F37AC33F6A61B7D25E"))  ;;gpg -K --with-keygrip
    ;; see https://daltonmatos.com/2018/08a/usando-seu-keyring-gpg-para-guardar-sua-chave-ssh/

     )
    ;; (feature-security-token)
    (feature-password-store
;; #:remote-password-store-url ;;"ssh://github.com/igorzolnerkevic/password-store.git"
   ) ;;atualizar pro Gitlab!!!

    (feature-mail-settings
     #:mail-accounts (list   (mail-acc 'work     "igorz@abismos.net" 'gmail)
                     ;; (mail-acc 'personal "igor.z.mail@gmail.com" 'gmail)
                      )
#:mailing-lists (list (mail-lst 'guix-devel "guix-devel@gnu.org"
                                     '("https://yhetil.org/guix-devel/0"))
                           (mail-lst 'guix-bugs "guix-bugs@gnu.org"
                                     '("https://yhetil.org/guix-bugs/0"))
                           (mail-lst 'guix-patches "guix-patches@gnu.org"
                                      '("https://yhetil.org/guix-patches/1")))
                                     )


   (feature-custom-services
    #:feature-name-prefix 'abismos
    #:system-services (list
                       sudoers-extra-service
                       ;;add-sane-backends
                       add-cups-service
                       add-nix-service)
    #:home-services
    (list
     emacs-extra-packages-service
     home-extra-packages-service
     sway-extra-config-service
     mpv-add-user-settings-service
     ssh-extra-config-service
     ;; i2pd-add-ilita-irc-service
     extra-shepherd-services-service
     ))


   (feature-xdg
     #:xdg-user-directories-configuration
     (home-xdg-user-directories-configuration
      (music "$HOME/music")
      (videos "$HOME/videos")
      (pictures "$HOME/images")
      (documents "$HOME/reference")
    (download "$HOME/downloads")
      (desktop "$HOME")
      (publicshare "$HOME")
      (templates "$HOME")))

    (feature-emacs-keycast #:turn-on? #t)
    (feature-emacs-tempel
    #:default-templates? #t
    #:templates
    `(fundamental-mode
      ,#~""
      (t (format-time-string "%Y-%m-%d"))
      ;; TODO: Move to feature-guix
      ;; ,((@ (rde gexp) slurp-file-like)
      ;;   (file-append ((@ (guix packages) package-source)
      ;;                 (@ (gnu packages package-management) guix))
      ;;                "/etc/snippets/tempel/text-mode"))
           )
     )
    (feature-emacs-time)
       (feature-emacs-calendar
       #:diary-file "~/org/diary")
    (feature-emacs-spelling
    #:spelling-program (@ (gnu packages hunspell) hunspell)
    #:spelling-dictionaries
    (list
     (@ (gnu packages hunspell) hunspell-dict-en)
     (@ (abismos hunspell) hunspell-dict-pt-br))
    #:flyspell-hooks '( ;;org-mode-hook
                        message-mode-hook)
     #:ispell-standard-dictionary "pt_BR"
     #:ispell-personal-dictionary "en_US")
    (feature-emacs-git
     #:project-directory "~/projects")
    (feature-emacs-org
    #:org-directory "~/org"
    #:org-indent? #t
    #:org-capture-templates
    ;; https://libreddit.tiekoetter.com/r/orgmode/comments/gc76l3/org_capture_inside_notmuch/
    `(("r" "Reply" entry (file+headline "" "Tasks")
       "* TODO Reply %:subject %?\nSCHEDULED: %t\n%U\n%a\n"
       :immediate-finish t)
      ("i" "Inbox" entry (file "~/org/inbox.org" )
           "* %?\n /Entered on/ %U\n %i\n  ")
      ("t" "Todo" entry (file+headline "" "Tasks") ;; org-default-notes-file
           "* TODO %?\nSCHEDULED: %t\n%a\n" :clock-in t :clock-resume t))
      #:org-priority-faces
    '((?A . (:foreground "#FF665C" :weight bold))
      (?B . (:foreground "#51AFEF"))
      (?C . (:foreground "#4CA171")))
    #:org-todo-keywords
    '((sequence "PROJ(p)" "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d!)" "CNCL(c)"))
    #:org-todo-keyword-faces
    '(("TODO" . "#ff665c")
      ("PROJ" . "#ff665c")
      ("NEXT" . "#FCCE7B")
      ("HOLD" . "#a991f1")
      ("DONE" . "#7bc275"))
    #:org-tag-alist
    '((:startgrouptag)
                      ("areas")
                      (:grouptags)
                      ("trabalho")
                      ("estudos")
		      ("saúde")
		      ("organizar")
		      ("relacionamentos")
		      ("lazer")
                      (:endgrouptag)
                      (:startgrouptag)
                      ("trabalho")
                      (:grouptags)
                    ;;  ("sbf")
		      ("freelancer")
                      (:endgrouptag)
		      (:startgrouptag)
		      ("estudos")
		      (:grouptags)
		      ("desenho")
		      ("ficção")
		      ("ciências")
		      ("matemática")
		      ("modelismo")
                      ("computação")
                      ("música")
		      (:endgrouptag)
		      (:startgrouptag)
		      ("saúde")
		      (:grouptags)
		      ("higiene_mental")
		      ("condicionamento_físico")
		      ("cuidados_pessoais")
		      (:endgrouptag)
     		      (:startgrouptag)
		      ("organizar")
		      (:grouptags)
		      ("gtd")
		      ("limpar")
		      ("finanças")
		      (:endgrouptag)
		      (:startgrouptag)
		      ("finanças")
		      (:grouptags)
		      ("pagar")
		      ("comprar")
		      ("contabilidade")
		      ("doação")
		      (:endgrouptag)
		      (:startgrouptag)
		      ("relacionamentos")
		      (:grouptags)
		      ("família")
		      ("amigos")
		      ("encontros")
		      (:endgrouptag)
		      (:startgrouptag)
		      ("lazer")
		      (:grouptags)
		      ("descansar")
		      ("passear")
		      ("relaxar")
		      ("brincar")
		      ("jogar")
		      (:endgrouptag)
		     		      ;; locais e situações
		      ("@email")
		      ("@phone")
		      ("@online")
		      ("@offline")
		      ("@rua")
		      ("@macmini")
		      ("@macbookair")
		      ("@twitter")
		      ("@facebook")
		      ("@instagram")
		      ("@youtube")
		      ;; tipos de ações
		      ("desenhar")
		      ("colecionar")
		      ("ler")
                      ("escutar")
		      (:startgrouptag)
		      ("ler")
		      (:grouptags)
		      ("romance")
		      ("contos")
		      ("poesia")
		      ("divulgação científica")
		      (:endgrouptag)
		      (:startgrouptag)
		      ("escutar")
		      (:grouptags)
		      ("música")
		      ("podcast")
		      ("audiobook")
		      (:endgrouptag)
		      (:grouptags)
 		      ("assistir")
		      (:startgrouptag)
		      ("assistir")
		      (:grouptags)
		      ("séries")
		      ("desenhos")
		      ("filmes")
		      ("documentários")
		      ("shows")
		      ("aulas")
		      ("palestras")
		      ("teatro")
		      (:endgrouptag)
		      ;;eventos
		      ("rotina_diária")
		      ("reunião")
		      ("entrevista")
	  	      ("consulta")
		      ;;posses ou bens
		      ("computadores")
		      ("apartamento") ) )

     (feature-emacs-org-recur) ;;better repeated tasks syntax
    (feature-emacs-org-roam
     ;; TODO: Rewrite to states
         #:org-roam-directory "~/org/notes"
         #:org-roam-dailies-directory "~/org/journal"
         #:org-roam-todo? #f
    #:org-roam-capture-templates
    `(("d" "default" plain "%?"
       :if-new (file+head
                "%<%Y%m%d%H%M%S>-${slug}.org"
                "#+title: ${title}\n#+filetags: :${Topic}:\n")
       :unnarrowed t)
      ("r" "reference" plain "%?"
       :if-new (file+head
                "%<%Y%m%d%H%M%S>-${slug}.org"
                ,(string-append
                  ":PROPERTIES:\n:ROAM_REFS: ${ref}\n:END:\n"
                  "#+title: ${title}\n#+filetags: :${Topic}:"))
       :unnarrowed t)
      ;; ("m" "recipe" plain "* Ingredients\n- %?\n* Directions"
      ;;  :if-new (file+head
      ;;           "%<%Y%m%d%H%M%S>-${title}.org"
      ;;           "#+title: ${title}\n#+filetags: :cooking:\n")
      ;;  :unnarrowed t)
      ("b" "book" plain
       "* Chapters\n%?"
       :if-new (file+head
                "%<%Y%M%d%H%M%S>-${slug}.org"
                ,(string-append
                  ":PROPERTIES:\n:AUTHOR: ${Author}\n:DATE: ${Date}\n"
                  ":PUBLISHER: ${Publisher}\n:EDITION: ${Edition}\n:END:\n"
                  "#+title: ${title}\n#+filetags: :${Topic}:"))
       :unnarrowed t))
    #:org-roam-dailies-capture-templates
    '(("d" "default" entry
       "* %?"
       :if-new (file+head "%<%Y-%m-%d>.org"
                          "#+title: %<%Y-%m-d>\n"))))

    (feature-emacs-org-agenda
     #:org-agenda-files '(
                          "~/org/todo.org"))
    (feature-emacs-elfeed
     #:elfeed-org-files '("~/org/rss.org"))

    (feature-javascript)

    ;; To access nix apps via emacs app launcher too, execute only first time:
    ;;sudo ln -s "/nix/var/nix/profiles/per-user/$USER/profile" ~/.nix-profile
    ;;sudo ln -s ~/.nix-profile/share/applications/* ~/.local/share/applications/

    (feature-python
     #:black? #t)

;;    ;; TODO: move feature to general, move extra configuration to service.



 ;; TODO: move feature to general, move extra configuration to service.
    (feature-notmuch
     #:extra-tag-updates-post
     '("notmuch tag +guix-home +inbox -- 'thread:\"\
{((subject:guix and subject:home) or (subject:service and subject:home) or \
subject:/home:/) and tag:new}\"'")
     #:notmuch-saved-searches
     (append
      ;; TODO: Add tag:unread to all inboxes.  Revisit archive workflow.
      '((:name "To Process" :query "tag:todo or (tag:inbox and not tag:unread)"
         :key "t")
        (:name "Drafts" :query "tag:draft" :key "d")
        (:name "Watching" :query "thread:{tag:watch} and tag:unread" :key "w")
        (:name "Work Inbox" :query "tag:work and tag:inbox and tag:unread"
         :key "W")
        (:name "Personal Inbox" :query "tag:personal and tag:inbox" :key "P")
        (:name "Guix Home Inbox" :key "H" :query "tag:guix-home and tag:unread"))
      ;; %rde-notmuch-saved-searches
      '()))



   ;;  (feature-notmuch
     ;; TODO: Add integration with mail-lists
     ;; `notmuch-show-stash-mlarchive-link-alist'
    ;;  #:extra-tag-updates-post
 ;;     '("notmuch tag +guix-home -- 'thread:\"\
 ;; {((subject:guix and subject:home) or (subject:service and subject:home) or \
 ;; subject:/home:/) and tag:new}\"'")
 ;;     #:notmuch-saved-searches
 ;;     (cons*
 ;;      ;; TODO: Add tag:unread to all inboxes.  Revisit archive workflow.
 ;;      '(:name "Work Inbox" :query "tag:work and tag:inbox and tag:unread" :key "W")
 ;;     '(:name "Personal Inbox" :query "tag:personal and tag:inbox" :key "P")
 ;;     '(:name "Guix Home Inbox" :key "H" :query "tag:guix-home and tag:unread")
 ;;     '(:name "RDE Inbox"       :key "R"
 ;;       :query "(to:/rde/ or cc:/rde/) and tag:unread")
 ;;     '(:name "New TODO" :query "tag:todo or (tag:inbox and not tag:unread)" :key "T")
 ;;      '(:name "Watching" :query "thread:{tag:watch} and tag:unread" :key "tw")
 ;;      %rde-notmuch-saved-searches)
 ;;  )

   (feature-keyboard
    ;; To get all available options, layouts and variants run:
    ;; cat `guix build xkeyboard-config`/share/X11/xkb/rules/evdev.lstq
    #:keyboard-layout
    (keyboard-layout
     "us" "alt-intl"
     #:options '(
                 "caps:ctrl_modifier"
                 )))))


;;; Some TODOs

;; TODO: Add an app for saving and reading articles and web pages
;; https://github.com/wallabag/wallabag
;; https://github.com/chenyanming/wallabag.el

;; TODO: feature-wallpapers https://wallhaven.cc/
;; TODO: feature-icecat
;; TODO: Revisit <https://en.wikipedia.org/wiki/Git-annex>
;; TODO: <https://www.labri.fr/perso/nrougier/GTD/index.html#table-of-contents>


;;; wintermute



(define-public wintermute-config
  (rde-config
   (features
    (append
     %all-features
     %wintermute-features
     %abismos-features))))

(define-public wintermute-os
  (rde-config-operating-system wintermute-config))

(define-public wintermute-he
  (rde-config-home-environment wintermute-config))








;;; Dispatcher, which helps to return various values based on environment
;;; variable value.

(define (dispatcher)
  (let ((rde-target (getenv "RDE_TARGET")))
    (match rde-target
      ("wintermute-home" wintermute-he)
      ("wintermute-system" wintermute-os)
       ;;("live-system" live-os)
      (_ wintermute-he))))

(dispatcher)
