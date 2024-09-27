(in-package #:spacepilot)

(defclass main (trial-harmony:settings-main)
  ((scene :initform (make-instance 'world))))

(setf +app-system+ "spacepilot")

(defparameter +spaceships+ (make-instance 'bag))
(defparameter +starfield+ (make-instance 'bag))

(defun init-starfield ()
  (setf +starfield+ (make-instance 'bag))
  (loop repeat 250
        do (enter (make-instance 'star :location (v+ (vrand 0f0 1000.0)
                                                     (vec 0 0 40)))
                  +starfield+)
        finally (return +starfield+)))

(defmethod setup-scene ((main main) (scene world))
  (setf +spaceships+ (make-instance 'bag))
  (enter (make-instance 'fps-counter) scene)
  (enter (make-instance 'display-controller) scene)
  (observe! (size scene) :title "Entities in game")
  (observe! (size +spaceships+) :title "Entities in spaceships bag")
  (observe! (spawn-timer scene) :title "Spawn timer")
  (observe! +player-speed+ :title "Player speed")
  (let ((player (make-instance 'player :name :player))
        (game (make-instance 'render-pass))
        (ui (make-instance 'ui))
        (combine (make-instance 'blend-pass)))
    (enter player +spaceships+)
    (enter (make-instance '3d-camera :location (vec 0 0 30)) scene)
    (enter +spaceships+ scene)
    (enter (init-starfield) scene)
    (connect (port game 'color) (port combine 'a-pass) scene)
    (connect (port ui 'color) (port combine 'b-pass) scene)
    (preload (make-instance 'enemy) scene)
    (preload (make-instance 'explosion) scene)
    (preload (make-instance 'bullet :target :nobody) scene)
    (preload (// 'spacepilot-music 'background-music) scene)))

(define-handler (world scene-changed) ()
  (trial-alloy:show-panel 'hud :player (node :player world))
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
