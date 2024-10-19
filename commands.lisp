(in-package #:spacepilot)

(define-handler (scene key-press :after) (key)
  (case key
    (:f1
     (change-scene +main+ (make-instance 'world))
     (discard-events scene))
    (:f2
     (die (node :player +spaceships+)))
    (:f3
     (let ((fbo (flow:node (flow:left (first (flow:connections
                                    (port (node 'blend-pass scene) 'a-pass))))))
           (path (make-pathname :name (format-timestring :as :filename)
                                :type "png"
                                :defaults (user-homedir-pathname))))
       (save-image fbo path T)
       (v:info :spacepilot "Saved screenshot to ~a" path)))
    (:f10
     (pause +main+))
    (:f11
     (setf (game-speed +main+) 0.1))
    (:f12
     (setf (game-speed +main+) 1))))
