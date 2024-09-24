;;; SPDX-FileCopyrightText: © 2023 Foundation Devices, Inc. <hello@foundationdevices.com>
;;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (foundation packages messaging)
  #:use-module (gnu packages gnome)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (nonguix build-system chromium-binary)
  #:use-module (nonguix licenses))

(define-public roam
  (package
    (name "roam")
    (version "127.1.0-beta001")
    (source (origin
              (method url-fetch)
              ;; Taken from the Arch Linux's PKGBUILD for Roam.
              ;;
              ;; https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=roam
              (uri (string-append "https://download.ro.am/Roam"
                                  "/8a86d88cfc9da3551063102e9a4e2a83"
                                  "/linux/debian/binary/"
                                  version "-roam_" version "_amd64.deb"))
              (sha256
               (base32
                "021p6gxl891slcbq332b8lpg39cl352jjf1fxh4k2l8q7wqz009v"))))
    (build-system chromium-binary-build-system)
    (arguments
     (list #:validate-runpath? #f

           #:wrapper-plan
           #~'("usr/lib/roam/Roam"
               "usr/lib/roam/chrome_crashpad_handler"
               "usr/lib/roam/libffmpeg.so"
               "usr/lib/roam/libvulkan.so.1"
               "usr/lib/roam/libEGL.so"
               "usr/lib/roam/libGLESv2.so"
               "usr/lib/roam/libvk_swiftshader.so"
               #$(string-append "usr/lib/roam/resources/app.asar.unpacked"
                                "/.webpack/main/Keytar.node")
               #$(string-append "usr/lib/roam/resources/app.asar.unpacked"
                                "/.webpack/main/OtherApplicationMonitor.node")
               #$(string-append "usr/lib/roam/resources/app.asar.unpacked"
                                "/.webpack/main/ScreenShareHighlight.node")
               #$(string-append "usr/lib/roam/resources/app.asar.unpacked"
                                "/.webpack/main/SystemPermissionTutorial.node"))

           #:install-plan
           #~'(("usr/lib/roam" "lib/roam")
               ("usr/share" "share"
                #:exclude ("doc/roam/copyright"
                           "lintian/overrides/roam"))
               ("usr/share/doc/roam/copyright"
                #$(string-append "share/doc/roam-" version "/"))
               ("usr/lib/roam/LICENSES.chromium.html"
                #$(string-append "share/doc/roam-" version "/")))

           #:phases
           #~(modify-phases %standard-phases
               (add-before 'install-wrapper 'wrap-where-patchelf-does-not-work
                 (lambda _
                   (let ((bin (string-append #$output "/lib/roam/Roam"))
                         (wrapper (string-append #$output "/bin/roam")))
                     (mkdir-p (dirname wrapper))
                     (make-wrapper wrapper bin
                                   `("LD_LIBRARY_PATH" ":"
                                     prefix
                                     (,(string-join
                                        (list
                                         (string-append #$output "/lib/roam"))
                                        ":"))))))))))
    (inputs (list libsecret))
    (supported-systems '("x86_64-linux"))
    (home-page "https://ro.am")
    (synopsis "Cloud based offices")
    (description "Roam is an application that provides cloud based offices.")
    (license (nonfree "https://ro.am/terms/2023-10-09"))))

