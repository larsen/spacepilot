(in-package #:spacepilot)

(defclass main (trial-harmony:settings-main)
  ((game-speed :initform 1 :accessor game-speed)
   (paused :initform nil :accessor paused)
   (scene :initform (make-instance 'menu))))

(setf +app-vendor+ "larsen")
(setf +app-system+ "spacepilot")

(defparameter +debug+ nil)
(defparameter +player+ nil)
(defparameter +spaceships+ (make-instance 'bag))

(defmethod pause ((main main))
  (setf (paused main) (if (paused main) nil T)))

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

(defun launch (&rest args)
  (let ((*package* #.*package*))
    (setf +settings+
          (copy-tree '(:general (:debug-mode nil)
                       :audio (:latency 0.005
                               :backend :default
                               :device :default
                               :volume (:master 1.0
                                        :effect 1.0
                                        :music 1.0)))))
    (load-settings)
    (load-keymap)
    (setf (active-p (action-set 'in-game)) T)
    (apply #'trial:launch 'main
           (append args '(:context (:title "spacepilot"
                                    :width 800
                                    :height 600
                                    :resizable nil))))))
