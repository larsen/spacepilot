(in-package #:spacepilot)

(define-shader-pass ui (org.shirakumo.fraf.trial.alloy:base-ui)
  ())

(defun format-score (score)
  (format NIL "~d" score))

(defclass score-display (alloy:label)
  ())

(defmethod alloy:text ((display score-display))
  (format-score (alloy:value display)))

(presentations:define-realization (ui score-display)
  ((label simple:text)
   (alloy:margins -10)
   alloy:text
   :size (alloy:un 40)
   :font "Arial"
   :pattern colors:white
   :halign :left
   :valign :bottom))

(presentations:define-update (ui score-display)
  (label
   :text alloy:text))

(defclass hud (trial-alloy:panel)
  ())

(defmethod initialize-instance :after ((hud hud) &key player)
  (let* ((layout (make-instance 'org.shirakumo.alloy.layouts.constraint:layout)))
    (alloy:enter (alloy:represent (score player) 'score-display)
                 layout :constraints `((:left 30) (:bottom 30) (:size 1000 50)))
    (alloy:finish-structure hud layout NIL)))
