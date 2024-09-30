(in-package #:spacepilot)

(defclass main (trial-harmony:settings-main)
  ((scene :initform (make-instance 'menu))))

(setf +app-system+ "spacepilot")

(defparameter +player+ nil)
(defparameter +spaceships+ (make-instance 'bag))
(defparameter +starfield+ (make-instance 'bag))

(defun init-starfield ()
  (clear +starfield+)
  (setf (container +starfield+) NIL)
  (loop repeat 250
        do (enter (make-instance 'star :location (v+ (vrand 0f0 1000.0)
                                                     (vec 0 0 40)))
                  +starfield+)
        finally (return +starfield+)))

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

(define-handler (main scene-changed) ()
  ;; FIXME: the score hud disappears after the first
  ;; player death
  (trial-alloy:show-panel 'hud :player (node :player (scene main)))
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
