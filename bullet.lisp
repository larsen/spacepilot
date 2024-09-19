(in-package #:spacepilot)

(define-shader-entity bullet (vertex-entity
                              collision-body
                              colored-entity
                              transformed-entity
                              listener)
  ((vertex-array :initform (// 'trial 'unit-sphere))
   (color :initform (vec 0 1 1 1) :initarg :color)
   (velocity :initform (vec 0 0 0) :initarg :velocity :accessor velocity)))

(defmethod initialize-instance :after ((bullet bullet) &key)
  (setf (physics-primitive bullet) (make-sphere :radius 0.1)))

(define-handler (bullet tick) (dt)
  (nv+* (location bullet) (v+ (velocity bullet)
                              +player-speed+) dt))

(define-handler (bullet tick :after) ()
  (map-scene-graph (lambda (node)
                     (when (and (typep node 'enemy)
                                (intersects-p (aref (physics-primitives bullet) 0)
                                              (aref (physics-primitives node) 0)))
                       (leave node (container bullet))))
                   (container bullet)))

(defgeneric fire (spaceship &key))
(defmethod fire ((spaceship spaceship) &key (color (vec 0 1 1 1)))
  (enter (make-instance 'bullet
                        :color color
                        :location (location spaceship)
                        :scaling (vec 0.1 0.1 0.1)
                        :velocity (nv* (q* (orientation spaceship) +vy3+) 15))
         (container spaceship)))
