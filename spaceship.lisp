(in-package #:spacepilot)

(define-shader-entity spaceship (transformed-entity colored-entity listener)
  ((velocity :initform (vec 0 0 0) :initarg :velocity :accessor velocity)
   (color :initform (vec 0 1 1 1) :initarg :color :accessor color)))

(define-handler (spaceship tick) (dt)
  (nv+* (location spaceship) (velocity spaceship) dt))
