(in-package #:spacepilot)

(define-shader-entity star (vertex-entity transformed-entity colored-entity listener)
  ((vertex-array :initform (// 'trial 'unit-cube))
   (color :initform (vec 0.8 0.8 0.8 1))
   (velocity :initform +player-speed+ :initarg :velocity :accessor velocity)))

(define-handler (star tick) (dt)
  (nv+* (location star) (velocity star) dt))

(defparameter +starfield+ (make-instance 'bag))

(defun init-starfield ()
  (clear +starfield+)
  (setf (container +starfield+) NIL)
  (loop repeat 500
        do (enter (make-instance 'star :location (v+ (vrand 0f0 1000.0)
                                                     (vec 0 0 -40)))
                  +starfield+)
        finally (return +starfield+)))
