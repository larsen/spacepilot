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


(defclass score-label (alloy:direct-value-component alloy:label)
  ())

(presentations:define-realization (ui score-label)
  ((label simple:text)
   (alloy:margins -10)
   alloy:text
   :size (alloy:un 25)
   :font "PromptFont"
   :pattern (chroma:color 1 1 1 1)
   :halign :center
   :valign :top))

(defmethod alloy:text ((label score-label))
  (princ-to-string (score-value (alloy:value label))))

(presentations:define-update (ui score-label)
  (label :text alloy:text))

(defmethod show ((label score-label) &key)
  (unless (alloy:layout-tree label)
    (alloy:enter label (alloy:popups (alloy:layout-tree (node 'trial-alloy:ui T)))))
  (alloy:with-unit-parent label
    (let* ((target (alloy:value label))
           (tloc (location target))
           (screen-location (world-screen-pos (vec (vx tloc)
                                                   (+ (vy tloc)
                                                      (vy (bsize target))
                                                      10))))
           (size (alloy:suggest-size (alloy:px-size 100 10) label)))
      (setf (alloy:bounds label)
            (alloy:px-extent (- (vx screen-location) (/ (alloy:pxw size) 2))
                             (+ (vy screen-location) (alloy:pxh size))
                             (max 1 (alloy:pxw size))
                             (max 1 (alloy:pxh size)))))))


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
                          layout :constraints `((:right (+ 30 (* ,i 90)))
                                                (:top 100)
                                                (:size 80 80))))
    (alloy:enter (alloy:represent (score player) 'score-display)
                 layout :constraints `((:right 30) (:top 30) (:size 100 50)))
    (alloy:finish-structure hud layout NIL)))
