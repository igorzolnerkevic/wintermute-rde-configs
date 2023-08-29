(use-modules (guix ci)
             (guix channels))

(list
(channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (branch "master")
        (introduction
          (make-channel-introduction
            "9edb3f66fd807b096b48283debdcddccfea34bad"
            (openpgp-fingerprint
              "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
 (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (introduction
         (make-channel-introduction
          "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
          (openpgp-fingerprint
           "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))

 ;; (channel
 ;;    (name 'confetti)
 ;;    (url "https://git.sr.ht/~whereiseveryone/confetti")
 ;;    (branch "s")
 ;;    (introduction
 ;;     (make-channel-introduction
 ;;      "72ddf93a6c9444b812a731acf785047d066936bd"
 ;;      (openpgp-fingerprint
 ;;       "3B1D 7F19 E36B B60C 0F5B  2CA9 A52A A2B4 77B6 DD35"))))
(channel
  (name 'rde)
  (url "https://git.sr.ht/~abcdw/rde")
  (introduction
   (make-channel-introduction
    "257cebd587b66e4d865b3537a9a88cccd7107c95"
    (openpgp-fingerprint
     "2841 9AC6 5038 7440 C7E9  2FFA 2208 D209 58C1 DEB0"))))

 ;; (channel
 ;;  (name 'my-guix-pkgs)
 ;;  (url "https://github.com/igorzolnerkevic/my-guix-pkgs.git")
 ;;   (branch "main")
 ;;  (introduction
 ;;   (make-channel-introduction
 ;;    "ac987597ecae538141e059cbd20c4c0a58c2f138"
 ;;    (openpgp-fingerprint
 ;;     "B899 0BEC BE60 898F 7FE6 6AC9 5F00 102A 0414 81E1"))))

;; Criar CANAL LOCAL?
 ;; (channel
 ;; (name 'igorz-channel)
 ;;  (url "file:///home/igorz/projects/wintermute-rde-configs/igorz-channel"))
 )
