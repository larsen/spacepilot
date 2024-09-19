(in-package #:spacepilot)

(define-shader-entity enemy (spaceship)
  ((color :initform (vec 1 0 0 1))
   (vertex-array :initform (// 'spacepilot 'enemy-spaceship '(:cube.004 . 1)))))

(defmethod initialize-instance :after ((enemy enemy) &key)
  (let* ((angle (random 360))
         (orientation (qfrom-angle +vz+ (deg->rad angle)))
         (velocity (nv* (q* orientation +vy3+) 5))
         (location (vxy_ (nvrand (vec3) 50))))
    (setf (location enemy) location)
    (setf (velocity enemy) velocity)
    (setf (orientation enemy) orientation)
    (setf (physics-primitive enemy)
          (make-sphere :radius 1.5 :location location))))

(define-handler ((enemy enemy) tick) (dt)
  (nv+* (location enemy) (v+ (velocity enemy)
                             +player-speed+) dt))

(define-handler ((enemy enemy) tick :after) ()
  (let* ((scene (container enemy))
         (player (node :player scene)))
    (when (and (not (null player))
               (intersects-p (aref (physics-primitives enemy) 0)
                             (aref (physics-primitives player) 0)))
      (v:info :spacepilot "Found collision. loc enemy ~a, loc player ~a"
              (location (aref (physics-primitives enemy) 0))
              (location (aref (physics-primitives player) 0)))
      (leave enemy scene)
      ;; TODO we should actually exit the game
      (leave player scene))))
