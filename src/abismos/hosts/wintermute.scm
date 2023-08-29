(define-module (abismos hosts wintermute)
  #:use-module (rde features base)
  #:use-module (rde features system)
  #:use-module (rde features wm)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system) ;; define %base-firmware
  #:use-module (gnu packages linux) ;; loopback module
  #:use-module (nongnu packages linux) ;; o kernel
  #:use-module (nongnu system linux-initrd) ;; o microcode
  #:use-module (ice-9 match))

;;; Hardware/host specifis features

;; TODO: Switch from UUIDs to partition labels For better
;; reproducibilty and easier setup.  Grub doesn't support luks2 yet.

(define wintermute-mapped-devices
  (list (mapped-device
         (source (uuid "763b1d0b-440d-444e-bdb4-742648cc088d"))
         (target "enc")
         (type luks-device-mapping))))

(define wintermute-file-systems
  (append
   (map (match-lambda
          ((subvol . mount-point)
           (file-system
             (type "btrfs")
             (device "/dev/mapper/enc")
             (mount-point mount-point)
             (options (format #f "compress=zstd,subvol=~a" subvol))
             (dependencies wintermute-mapped-devices))))
        '((root . "/")
          (boot . "/boot")
         (swap . "/swap")
          (gnu  . "/gnu")
          (data . "/data")
          (log  . "/var/log")
          (home . "/home")))
   (list
    (file-system
      (mount-point "/boot/efi")
      (type "vfat")
      (device (uuid "66CA-75EC" 'fat32))))))

(define wintermute-swapfile
  (list (swap-space
         (target "/swap/swapfile")
         (dependencies (filter (file-system-mount-point-predicate "/swap")
                               wintermute-file-systems)))))

(define-public %wintermute-features
  (list
    (feature-kernel
    #:kernel linux
    #:kernel-loadable-modules (list v4l2loopback-linux-module)
    #:kernel-arguments '("modprobe.blacklist=b43,b43legacy,ssb,bcm43xx,brcm80211,brcmfmac,brcmsmac,bcma,usbmouse")
    #:initrd microcode-initrd
    #:firmware (cons* broadcom-bt-firmware
                      %base-firmware))
   (feature-host-info
    #:host-name "wintermute"
    ;; ls `guix build tzdata`/share/zoneinfo
    #:timezone  "America/Sao_Paulo")
   ;;; Allows to declare specific bootloader configuration,
   ;;; grub-efi-bootloader used by default
   ;; (feature-bootloader)
   (feature-file-systems
    #:mapped-devices wintermute-mapped-devices
    #:swap-devices wintermute-swapfile
    #:file-systems wintermute-file-systems)
   (feature-kanshi
    #:extra-config
    `((profile laptop ((output eDP-1 enable)))
      (profile docked ((output eDP-1 enable)
                       (output DP-2 scale 2)))))
   (feature-hidpi)))
