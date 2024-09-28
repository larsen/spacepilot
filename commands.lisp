(in-package #:spacepilot)

(define-handler (scene key-press :after) (key)
  (case key
    (:f1
     (change-scene +main+ (make-instance 'world))
     (discard-events scene))))
