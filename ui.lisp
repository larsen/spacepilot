(in-package #:spacepilot)

(define-shader-pass ui (org.shirakumo.fraf.trial.alloy:base-ui)
  ())

(defmethod org.shirakumo.alloy.renderers.opengl.msdf:fontcache-directory ((ui ui))
  (pool-path 'spacepilot "font-cache/"))

(defun format-score (score)
  (format NIL "SCORE ~6,'0d" score))

(defclass score-display (alloy:label)
  ())

(defmethod alloy:text ((display score-display))
  (format-score (alloy:value display)))

(presentations:define-realization (ui score-display)
  ((label simple:text)
   (alloy:margins -10)
   alloy:text
   :size (alloy:un 40)
   :font "PromptFont"
   :pattern colors:white
   :halign :right
   :valign :bottom))

(presentations:define-update (ui score-display)
  (label
   :text alloy:text))


(defclass icon (alloy:direct-value-component alloy:icon)
  ())

(presentations:define-update (ui icon)
  (:icon
   :image alloy:value
   :sizing :contain))


(defclass hud (trial-alloy:panel)
  ())

(defmethod initialize-instance :after ((hud hud) &key player)
  (let* ((layout (make-instance 'org.shirakumo.alloy.layouts.constraint:layout)))
    (loop repeat (lives player)
          for i from 0
          do (alloy:enter (make-instance 'icon :value (// 'spacepilot-images 'player-life))
                          layout :constraints `((:right (+ 350 (* ,i 50)))
                                                (:top 200)
                                                (:size 60 60))))
    (alloy:enter (alloy:represent (score player) 'score-display)
                 layout :constraints `((:right 30) (:top 30) (:size 100 50)))
    (alloy:finish-structure hud layout NIL)))
