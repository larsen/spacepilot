(in-package #:spacepilot)

(define-shader-entity bullet (vertex-entity
                              collision-body
                              colored-entity
                              transformed-entity
                              listener)
  ((vertex-array :initform (// 'trial 'unit-sphere))
   (color :initform (vec 0 1 1 1) :initarg :color)
   (velocity :initform (vec 0 0 0) :initarg :velocity :accessor velocity)
   (target :initform (error "You must declare the target")
             :initarg :target
             :accessor target)))

(defmethod initialize-instance :after ((bullet bullet) &key)
  (setf (physics-primitive bullet) (make-sphere :radius 0.1)))

(define-handler (bullet tick) (dt)
  (nv+* (location bullet) (v+ (velocity bullet)
                              +player-speed+) dt))

(define-handler (bullet tick :after) ()
  (let ((scene (container bullet)))
    (map-scene-graph (lambda (node)
                       (when (and (typep node (target bullet))
                                  (intersects-p (aref (physics-primitives bullet) 0)
                                                (aref (physics-primitives node) 0)))
                         (let ((explosion
                                 (make-instance 'explosion
                                                :scaling (vec 0.1 0.1 0.1)
                                                :location
                                                (nv* (location node) 10.0))))
                           (leave node scene)
                           (enter explosion scene)
                           (leave bullet scene))))
                     (container bullet))))

(defgeneric fire (spaceship target &key))
(defmethod fire ((spaceship spaceship) target &key (color (vec 0 1 1 1)))
  (enter (make-instance 'bullet
                        :target target
                        :color color
                        :location (location spaceship)
                        :scaling (vec 0.1 0.1 0.1)
                        :velocity (nv* (q* (orientation spaceship) +vy3+) 15))
         (container spaceship)))
