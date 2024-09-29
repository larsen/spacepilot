(in-package #:spacepilot)

(define-pool spacepilot)

(define-asset (spacepilot player-spaceship) model-file
    #p"player-spaceship.glb")

(define-asset (spacepilot enemy-spaceship) model-file
    #p"enemy-spaceship.glb")

(define-pool spacepilot-images :base #p"images/")

(define-asset (spacepilot-images explosion) sprite-data
    #p"explosion.json")

(define-asset (spacepilot player-life-tile) mesh
    (make-rectangle-mesh 2 2))

(define-asset (spacepilot-images player-life) image
    #p"shuttle.png")

(define-pool spacepilot-sound :base #p"sound/")

(define-asset (spacepilot-sound laser) trial-harmony:sound
    #p"laser1.wav")

(define-asset (spacepilot-sound explosion) trial-harmony:sound
    #p"sfx_explosionNormal.ogg")

(define-pool spacepilot-music :base #p"music/")

(define-asset (spacepilot-music background-music) trial-harmony:environment
    '((:normal #p"ObservingTheStar.ogg")))
