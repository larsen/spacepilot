(in-package #:spacepilot)

(define-shader-entity spaceship (collision-body transformed-entity colored-entity listener)
  ((velocity :initform (vec 0 0 0) :initarg :velocity :accessor velocity)
   (color :initform (vec 0 1 1 1) :initarg :color :accessor color)))

(defmethod initialize-instance :after ((spaceship spaceship) &key)
  (setf (physics-primitive spaceship) (make-sphere)))

(define-handler (spaceship tick) (dt)
  (nv+* (location spaceship) (velocity spaceship) dt))
