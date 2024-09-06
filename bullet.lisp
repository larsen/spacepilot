(in-package #:spacepilot)

(define-shader-entity bullet (vertex-entity colored-entity transformed-entity listener)
  ((vertex-array :initform (// 'trial 'unit-sphere))
   (color :initform (vec 0 1 1 1))
   (velocity :initform (vec 0 0 0) :initarg :velocity :accessor velocity)))

(define-handler (bullet tick) (dt)
  (nv+* (location bullet) (velocity bullet) dt))
