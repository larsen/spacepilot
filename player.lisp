(in-package #:spacepilot)

(defvar +player-speed+ (vec 5 5 0))

(define-shader-entity player (spaceship)
  ((location :initform (vec 0 0 0))
   (rotational-speed :initform 5.0 :accessor rotational-speed)
   (vertex-array :initform (// 'spacepilot 'player-spaceship '(:cube.002 . 0)))))

(define-handler (player tick) (dt)
  (let ((movement (directional 'move))
        (rot (orientation player)))
    (nq* rot (qfrom-angle +vz+ (+ (* dt (rotational-speed player) (vx movement)))))
    (setf +player-speed+ rot)
    (map-scene-graph (lambda (node)
                       (when (typep node 'star)
                         (setf (velocity node)
                               (nv* (q* rot +vy3+) -15))))
                     (container player))))

(defmethod stage :after ((player player) (area staging-area))
  (stage (// 'spacepilot-sound 'laser) area))

(define-handler (player fire) ()
  (harmony:play (// 'spacepilot-sound 'laser))
  (fire player 'enemy))
