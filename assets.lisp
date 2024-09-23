(in-package #:spacepilot)

(define-pool spacepilot)

(define-asset (spacepilot player-spaceship) model-file
    #p"player-spaceship.glb")

(define-asset (spacepilot enemy-spaceship) model-file
    #p"enemy-spaceship.glb")

(define-pool spacepilot-images :base #p"images/")

(define-asset (spacepilot-images explosion) sprite-data
    #p"explosion.json")

(define-pool spacepilot-sound :base #p"sound/")

(define-asset (spacepilot-sound laser) trial-harmony:sound
    #p"laser1.wav")

(define-pool spacepilot-music :base #p"music/")

(define-asset (spacepilot-music background-music) trial-harmony:environment
    '((:normal #p"ObservingTheStar.ogg")))
