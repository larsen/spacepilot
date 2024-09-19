(in-package #:spacepilot)

(defclass world (pipelined-scene)
  ((enemy-spawn-timer :initform 0f0 :initarg :spawn-timer :accessor spawn-timer)))

(define-handler ((scene world) tick :after) (dt)
  (incf (spawn-timer scene) dt)
  (when (> (spawn-timer scene) 2)
    (setf (spawn-timer scene) 0)
    (enter (make-instance 'enemy) scene)))
