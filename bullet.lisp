(in-package #:spacepilot)

(define-shader-entity bullet (vertex-entity
                              collision-body
                              colored-entity
                              transformed-entity
                              listener)
  ((vertex-array :initform (// 'trial 'unit-sphere))
   (color :initform (vec 0 1 1 1))
   (velocity :initform (vec 0 0 0) :initarg :velocity :accessor velocity)))

(defmethod initialize-instance :after ((bullet bullet) &key)
  (setf (physics-primitive bullet) (make-sphere :radius 0.1)))

(define-handler (bullet tick) (dt)
  (nv+* (location bullet) (velocity bullet) dt))

(define-handler (bullet tick :after) (dt)
  (map-scene-graph (lambda (node)
                     (when (and (typep node 'enemy)
                                (intersects-p (aref (physics-primitives bullet) 0)
                                              (aref (physics-primitives node) 0)))
                       (leave node (container bullet))))
                   (container bullet)))
