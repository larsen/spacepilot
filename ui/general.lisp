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
