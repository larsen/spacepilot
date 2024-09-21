(in-package #:spacepilot)

(defclass auto-fire ()
  ((fire-timer :initform 0f0 :initarg :spawn-timer :accessor fire-timer)
   (fire-period :initform 0.5 :initarg :fire-period)))

(define-handler (auto-fire tick :after) (dt)
  (incf (fire-timer auto-fire) dt)
  (when (> (fire-timer auto-fire) 0.5)
    (fire auto-fire 'player :color (vec 1 0 0 1))
    (setf (fire-timer auto-fire) 0)))

(define-shader-entity enemy (spaceship auto-fire)
  ((color :initform (vec 1 0 0 1))
   (vertex-array :initform (// 'spacepilot 'enemy-spaceship '(:cube.004 . 1)))))

(defmethod initialize-instance :after ((enemy enemy) &key)
  (let* ((angle (random 360))
         (orientation (qfrom-angle +vz+ (deg->rad angle)))
         (velocity (nv* (q* orientation +vy3+) 5))
         (location (vxy_ (nvrand (vec3) 50))))
    (setf (location enemy) location)
    (setf (velocity enemy) velocity)
    (setf (orientation enemy) orientation)))

(define-handler (enemy tick) (dt)
  (nv+* (location enemy) (v+ (velocity enemy)
                             +player-speed+) dt))

(define-handler (enemy tick :after) ()
  (let* ((scene (container enemy))
         (player (node :player scene)))
    (when (intersects-p (aref (physics-primitives enemy) 0)
                        (aref (physics-primitives player) 0))
      (v:info :spacepilot "Collision between enemy and player")
      (leave enemy scene)
      ;; TODO we should actually exit the game
      (v:info :spacepilot "BOOM! Player collision"))))

(defclass squadron ()
  ((scene :initform (error "You must provide a scene")
          :initarg :scene
          :accessor scene)))

(defmethod initialize-instance :after ((squadron squadron) &key)
  (let* ((first-ship (make-instance 'enemy))
         (first-ship-location (location first-ship))
         (first-ship-orientation (orientation first-ship))
         (direction (q* first-ship-orientation +vy3+))
         (perpendicular (nv* (vunit (vc direction (vec3 0 0 1))) 3))
         (second-ship (make-instance 'enemy))
         (third-ship (make-instance 'enemy)))
    (setf (location second-ship) (v+ first-ship-location perpendicular))
    (setf (orientation second-ship) first-ship-orientation)
    (setf (velocity second-ship) (velocity first-ship))

    (setf (location third-ship) (v- first-ship-location perpendicular))
    (setf (orientation third-ship) first-ship-orientation)
    (setf (velocity third-ship) (velocity first-ship))

    (enter first-ship (scene squadron))
    (enter second-ship (scene squadron))
    (enter third-ship (scene squadron))))
