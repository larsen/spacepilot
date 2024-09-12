(in-package #:spacepilot)

(define-pool spacepilot)

;; https://opengameart.org/content/3d-spaceships-pack
(define-asset (spacepilot spaceship-mesh) model-file
    #p"ship.glb")

(define-pool spacepilot-sound :base #p"sound/")

(define-asset (spacepilot-sound laser) trial-harmony:sound
    #p"laser1.wav")

(define-pool spacepilot-music :base #p"music/")

(define-asset (spacepilot-music background-music) trial-harmony:environment
    '((:normal #p"ObservingTheStar.ogg")))
