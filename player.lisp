(in-package #:spacepilot)

(defvar +player-speed+ (vec 5 5 0))
(defvar +player-lives+ 3)

(define-shader-entity player (spaceship alloy:observable-object)
  ((lives :initform +player-lives+ :accessor lives)
   (score :initform 0 :accessor score)
   (location :initform (vec 0 0 0))
   (rotational-speed :initform 5.0 :accessor rotational-speed)
   (vertex-array :initform (// 'spacepilot 'player-spaceship '(:cube.002 . 0)))))

(alloy:make-observable '(setf money) '(value alloy:observable))

(define-handler (player tick) (dt)
  (when +debug+
    (debug-draw (aref (physics-primitives player) 0)))
  (let ((movement (directional 'move))
        (rot (orientation player)))
    (nq* rot (qfrom-angle +vz+ (- (* dt (rotational-speed player) (vx movement)))))
    (setf +player-speed+ rot)))

(defmethod stage :after ((player player) (area staging-area))
  (stage (// 'spacepilot-sound 'laser) area))

(define-handler (player fire) ()
  (harmony:play (// 'spacepilot-sound 'laser))
  (fire player 'enemy))

(defmethod die ((player player))
  (unless +debug+
    (decf (lives player)))
  (if (zerop (lives player))
      (change-scene +main+ (make-instance 'menu))
      (progn
        (v:info :spacepilot "Player lives: ~a" (lives player))
        (discard-events (scene +main+))
        (change-scene +main+ (make-instance 'world)))))
