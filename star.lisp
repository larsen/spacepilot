(in-package #:spacepilot)

(define-shader-entity star (vertex-entity transformed-entity colored-entity listener)
  ((vertex-array :initform (// 'trial 'unit-sphere))
   (color :initform (vec 0.8 0.8 0.8 1))
   (velocity :initform +player-speed+ :initarg :velocity :accessor velocity)))

(define-handler (star tick) (dt)
  (nv+* (location star) (velocity star) dt))
