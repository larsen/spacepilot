(in-package #:spacepilot)

(define-action-set in-game)
(define-action move (directional-action in-game))
(define-action camera-move (directional-action in-game))
(define-action fire (in-game))
