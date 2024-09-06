(in-package #:spacepilot)

(defvar +player-speed+ (vec 10 10 0))

(define-shader-entity player (vertex-entity spaceship)
  ((location :initform (vec 0 0 0))
   (vertex-array :initform (// 'trial 'unit-cone))))

(define-handler (player tick) (dt)
  (let ((movement (directional 'move))
        (rot (orientation player))
        (rotational-speed 5.0))
    (map-scene-graph (lambda (node)
                       (when (typep node 'star)
                         (setf (velocity node)
                               (nv* (q* (orientation player) +vy3+) -15))))
                     (container player))
    (nq* rot (qfrom-angle +vz+ (+ (* dt rotational-speed (vx movement)))))))

(define-handler (player fire) ()
                (enter (make-instance 'bullet
                                      :location (location player)
                                      :scaling (vec 0.1 0.1 0.1)
                                      :velocity (nv* (q* (orientation player) +vy3+)
                                                     15))
                       (container player)))
