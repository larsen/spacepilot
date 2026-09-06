(in-package #:spacepilot)

(defclass auto-fire ()
  ((fire-timer :initform 0f0 :initarg :spawn-timer :accessor fire-timer)
   (fire-period :initform 0.5
                :initarg :fire-period
                :accessor fire-period)))

(defmethod initialize-instance :after ((auto-fire auto-fire) &key)
  (setf (fire-period auto-fire)
        (+ 0.5 (/ (random 10) 10))))

(define-handler (auto-fire tick :after) (dt)
  (incf (fire-timer auto-fire) dt)
  (when (> (fire-timer auto-fire)
           (fire-period auto-fire))
    (fire auto-fire 'player :color (vec 1 0 0 1))
    (setf (fire-timer auto-fire) 0)))

(define-shader-entity enemy (spaceship auto-fire)
  ((color :initform (vec 1 0 0 1))
   (name :initform (string (gensym)))
   (squadron :initarg :squadron :accessor squadron)
   (score-value :initform 10 :accessor score-value)
   (score-label :initform nil :accessor score-label)
   (vertex-array :initform (// 'spacepilot 'enemy-spaceship '(0 . 1)))))

(defmethod initialize-instance :after ((enemy enemy) &key)
  (let* ((angle (random 360))
         (orientation (qfrom-angle +vz+ (deg->rad angle)))
         (velocity (nv* (q* orientation +vy3+) 5))
         (location (vxy_ (nvrand (vec3) 50))))
    (setf (location enemy) location)
    (setf (velocity enemy) velocity)
    (setf (orientation enemy) orientation)
    (setf (score-label enemy)
          (make-instance 'score-label :value enemy))))

(define-handler (enemy tick) (dt)
  (when (setting :general :debug-mode)
    (debug-draw (aref (physics-primitives enemy) 0))
    (debug-text (v* (location enemy) 10.0)
                (name enemy)
                :scale 0.1))
  (nv+* (location enemy)
        ;; FIXME: HACK!
        (vxy_ (v+ (velocity enemy)
                  +player-speed+)) dt))

(define-handler (enemy tick :after) ()
  (let ((scene (container enemy)))
    ;; FIXME: The scene could be NIL when we're changing scene (after
    ;; the death of the player). Why?
    (when scene
      (let ((player (node :player scene)))
        (when (and (not (null player))
                   (intersects-p (aref (physics-primitives enemy) 0)
                                 (aref (physics-primitives player) 0)))
          (v:info :spacepilot "Collision between enemy and player")
          (leave enemy scene)
          (die player))))))

(defclass squadron (located-entity sized-entity)
  ((score-value :initform 50 :accessor score-value)
   (score-label :initform nil :accessor score-label)
   (scene :initform (error "You must provide a scene")
          :initarg :scene
          :accessor scene)))

(defmethod initialize-instance :after ((squadron squadron) &key)
  (let* ((lead (make-instance 'enemy :squadron squadron))
         (lead-location (location lead))
         (lead-orientation (orientation lead))
         (lead-direction (q* lead-orientation +vy3+))
         (perpendicular (nv* (vunit (vc lead-direction (vec3 0 0 1))) 3)))
    (enter lead (scene squadron))
    ;; FIXME: it doesn't work when there are more than 3 ships (total)
    (setf (location squadron) (location lead))
    (setf (bsize squadron) (bsize lead))
    (setf (score-label squadron)
          (make-instance 'score-label
                         :value squadron
                         :format "COMBO! +~A"))
    (loop repeat 2
          for ship = (make-instance 'enemy :squadron squadron)
          for offset from 1
          do (setf (location ship)
                   (v+ lead-location (nv* perpendicular offset)))
             (setf (orientation ship) lead-orientation)
             (setf (velocity ship) (velocity lead))
             (enter ship (scene squadron)))))

(defun combo-bonus (enemy spaceships)
  "When an enemy is killed, check if it was the last one in the squadron.
If that's the case, give bonus score to the player"
  (let* ((squadron (squadron enemy))
         (scene (scene squadron))
         (squadron-survivor-count 0))
    (do-scene-graph (s spaceships)
      (when (and (typep s 'enemy)
                 (eql squadron (squadron s)))
        (incf squadron-survivor-count)))
    (when (zerop squadron-survivor-count)
      (incf (score (node :player scene))
            (score-value squadron))
      (v:info :spapilot "BONUS!")
      (show (score-label squadron)))))
