(in-package #:spacepilot)

(defclass main (trial-harmony:settings-main)
  ((game-speed :initform 1 :accessor game-speed)
   (paused :initform nil :accessor paused)
   (scene :initform (make-instance 'menu))))

(setf +app-system+ "spacepilot")

(defparameter +debug+ T)
(defparameter +player+ nil)
(defparameter +spaceships+ (make-instance 'bag))

(defmethod pause ((main main))
  (setf (paused main) (if (paused main) nil T)))

(defmethod setup-scene ((main main) (scene world))
  (enter (make-instance 'fps-counter) scene)
  (enter (make-instance 'display-controller) scene)
  (observe! (size scene) :title "Entities in game")
  (observe! (size +spaceships+) :title "Entities in spaceships bag")
  (observe! (spawn-timer scene) :title "Spawn timer")
  (observe! +player-speed+ :title "Player speed")
  (let ((game (make-instance 'render-pass))
        (ui (make-instance 'ui))
        (combine (make-instance 'blend-pass :name 'blend-pass)))
    (setup-world scene)
    (enter (make-instance 'spacepilot-camera :location (vec 0 0 30)) scene)
    (connect (port game 'color) (port combine 'a-pass) scene)
    (connect (port ui 'color) (port combine 'b-pass) scene)))

(defmethod update ((main main) tt dt fc)
  (let ((scene (scene main))
        (dt (* (game-speed main) dt)))
    (cond ((paused main)
           (handle (make-event 'tick :tt tt :dt dt :fc fc) (camera (scene main))))
          (T
           (issue scene 'pre-tick :tt tt :dt dt :fc fc)
           (issue scene 'tick :tt tt :dt dt :fc fc)
           (issue scene 'post-tick :tt tt :dt dt :fc fc)))
    (process scene)))

(define-handler (world scene-changed) ()
  (trial-alloy:show-panel 'hud :player +player+)
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
