(in-package #:spacepilot)

(define-shader-entity star (vertex-entity transformed-entity colored-entity listener)
  ((vertex-array :initform (// 'trial 'unit-cube))
   (color :initform (vec 0.8 0.8 0.8 1))
   (velocity :initform +player-speed+ :initarg :velocity :accessor velocity)))

(define-handler (star tick) (dt)
  (nv+* (location star) (velocity star) dt))

(defclass starfield (bag listener)
  ((star-count :initform 100 :initarg :star-count :accessor star-count)))

(defmethod initialize-instance :after ((starfield starfield) &key)
  (loop repeat (star-count starfield)
        do (enter (make-instance 'star :location (v+ (vrand 0f0 1000.0)
                                                     (vec 0 0 -40)))
                  starfield)))

(define-handler (starfield tick) ()
  (map-scene-graph (lambda (node)
                     (when (typep node 'star)
                       (setf (velocity node)
                             (nv* (q* +player-speed+ +vy3+) -15))))
                   starfield))
