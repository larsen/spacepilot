(in-package #:spacepilot)

(define-shader-pass spacepilot-ui (trial-alloy:base-ui)
  ())

(defmethod org.shirakumo.alloy.renderers.opengl.msdf:fontcache-directory ((ui spacepilot-ui))
  (pool-path 'spacepilot "font-cache/"))

(defclass title (alloy:direct-value-component alloy:label)
  ())

(presentations:define-realization (spacepilot-ui title)
  ((label simple:text)
   (alloy:margins -10)
   alloy:text
   :size (alloy:un 80)
   :font "PromptFont"
   :pattern colors:white
   :halign :center
   :valign :top))

(presentations:define-update (spacepilot-ui title)
  (label :text alloy:value))

(defclass setting-label (alloy:label)
  ())

(presentations:define-realization (spacepilot-ui setting-label)
  ((label simple:text)
   (alloy:margins -10)
   alloy:text
   :size (alloy:un 30)
   :font "PromptFont"
   :pattern colors:white
   :halign :center
   :valign :top))

(presentations:define-update (spacepilot-ui setting-label)
  (label :text alloy:value))

(defclass score-label (alloy:direct-value-component alloy:label)
  ())

(presentations:define-realization (spacepilot-ui score-label)
  ((label simple:text)
   (alloy:margins -10)
   alloy:text
   :size (alloy:un 50)
   :font "PromptFont"
   :pattern colors:white
   :halign :center
   :valign :top))

(presentations:define-update (spacepilot-ui score-label)
  (label :text (score-value alloy:value)))

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

(defclass menu-button (alloy:button*)
  ())

(presentations:define-realization (spacepilot-ui menu-button)
  ((:background simple:rectangle)
   (alloy:extent 0 0 550 (alloy:ph 1)))
  ((:label simple:text)
   (alloy:margins 10 0 10 0) alloy:text
   :font "PromptFont"
   :halign :middle
   :size (alloy:un 30)))

(presentations:define-update (spacepilot-ui menu-button)
  (:background
   :pattern (if alloy:focus colors:silver colors:black))
  (:label
   :text alloy:text
   :pattern (if alloy:focus colors:black colors:white)))
