(in-package #:spacepilot)

(defclass menu (pipelined-scene)
  ())

(define-shader-pass menu-ui (trial-alloy:base-ui)
  ())

(defclass main-panel (trial-alloy:panel)
  ())

(defclass menu-button (alloy:button*)
  ())

(presentations:define-update (menu-ui menu-button)
  (:background
   :pattern (if alloy:focus colors:silver colors:black))
  (:border
   :line-width (if alloy:focus (alloy:un 10) (alloy:un 5))
   :pattern colors:black)
  (:label
   :text alloy:text
   :size (alloy:un 30)
   :pattern (if alloy:focus colors:black colors:white)))

(defmethod initialize-instance :after ((main-panel main-panel) &key)
  (let* ((layout (make-instance 'org.shirakumo.alloy.layouts.constraint:layout))
         (focus (make-instance 'alloy:focus-list))
         (menu (make-instance 'alloy:vertical-linear-layout
                              :cell-margins (alloy:margins 5)
							                :min-size (alloy:size 120 30))))
    (make-instance 'menu-button
                   :value "Start game"
                   :focus-parent focus
                   :layout-parent menu
                   :on-activate (lambda ()
                                  (change-scene +main+ (make-instance 'world))))
    (make-instance 'menu-button
                   :value "Quit game"
                   :focus-parent focus
                   :layout-parent menu
                   :on-activate (lambda ()
                                  (quit *context*)))
    (alloy:enter menu layout
                 :constraints `((:center :w) (:bottom 20) (:height 350) (:width 550)))
    (alloy:finish-structure main-panel layout focus)))

(defmethod setup-scene ((main main) (scene menu))
  (let ((output (make-instance 'render-pass))
        (ui (make-instance 'menu-ui))
        (combine (make-instance 'blend-pass)))
    (connect (port output 'color) (port combine 'a-pass) scene)
    (connect (port ui 'color) (port combine 'b-pass) scene)
    (trial-alloy:show-panel 'main-panel)))
