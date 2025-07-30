(in-package #:spacepilot)

(define-shader-entity engine-exhaust (cpu-particle-emitter)
  ((spaceship-emitter :initarg :emitted-by :accessor spaceship-emitter)))

(define-handler (engine-exhaust tick :after) (dt)
  (setf (orientation engine-exhaust) (orientation (spaceship-emitter engine-exhaust)))
  (setf (location engine-exhaust) (location (spaceship-emitter engine-exhaust))))
