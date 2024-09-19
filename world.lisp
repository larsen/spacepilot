(in-package #:spacepilot)

(defclass world (pipelined-scene)
  ((enemy-spawn-timer :initform 0f0 :initarg :spawn-timer :accessor spawn-timer)))

(define-handler (world tick :after) (dt)
  (incf (spawn-timer world) dt)
  (when (> (spawn-timer world) 2)
    (setf (spawn-timer world) 0)
    (enter (make-instance 'enemy) world)))
