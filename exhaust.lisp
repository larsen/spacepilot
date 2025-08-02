(in-package #:spacepilot)

(define-shader-entity engine-exhaust (cpu-particle-emitter)
  ((spaceship-emitter :initarg :emitted-by :accessor spaceship-emitter))
  (:default-initargs :max-particles 100
                     :particle-rate 60
                     :texture (// 'spacepilot-images 'exhaust-emitter)
                     :particle-force-fields `((:type :direction :strength 5.0)
                                              (:type :vortex :strength 10.0))
                     :particle-options `(:velocity 5.0 :randomness 0.5 :size 1.0 :scaling 2.0
                                         :color ,(vec3 0.75 0.75 0.90)
                                         :lifespan 0.25 :lifespan-randomness 0.5)))

(define-handler (engine-exhaust tick :after) ()
  (setf (orientation engine-exhaust) (orientation (spaceship-emitter engine-exhaust)))
  (setf (location engine-exhaust) (location (spaceship-emitter engine-exhaust))))
