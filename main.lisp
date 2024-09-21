(in-package #:spacepilot)

(defclass main (trial-harmony:settings-main)
  ((scene :initform (make-instance 'world))))

(setf +app-system+ "spacepilot")

(defmethod setup-scene ((main main) (scene world))
  (enter (make-instance 'fps-counter) scene)
  (enter (make-instance 'display-controller) scene)
  (observe! (size scene) :title "Entities in game")
  (observe! (spawn-timer scene) :title "Spawn timer")
  (observe! +player-speed+ :title "Player speed")
  (let ((player (make-instance 'player :name :player)))
    (loop repeat 1000
          do (enter (make-instance 'star :location (v+ (vrand 0f0 1000.0)
                                                       (vec 0 0 40))) scene))
    (enter player scene)
    (enter (make-instance '3d-camera :location (vec 0 0 -30)) scene)
    (enter (make-instance 'render-pass) scene)
    (preload (make-instance 'enemy) scene)
    (preload (make-instance 'bullet :target :nobody) scene)
    (preload (// 'spacepilot-music 'background-music) scene)))

(define-handler (world scene-changed) ()
  (harmony:transition (// 'spacepilot-music 'background-music) :normal))

(defun launch (&rest args)
  (let ((*package* #.*package*))
    (load-keymap)
    (setf (active-p (action-set 'in-game)) T)
    (apply #'trial:launch 'main
           (append args
                   (list :context
                         (list :title "spacepilot"
                               :width 800
                               :height 600
                               :resizable nil))))))
