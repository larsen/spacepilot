(in-package #:spacepilot)

(defun read-credits-message ()
  (uiop:read-file-string
   (asdf:system-relative-pathname :spacepilot "data/credits.txt")))

(defclass credits (pipelined-scene)
  ())

(define-shader-pass credits-ui (spacepilot-ui)
  ())

(defclass credits-panel (trial-alloy:panel)
  ())

(defmethod initialize-instance :after ((credits-panel credits-panel) &key)
  (let* ((layout (make-instance 'org.shirakumo.alloy.layouts.constraint:layout))
         (focus (make-instance 'alloy:focus-list))
         (title (make-instance 'title :value "Credits"))
         (credits (make-instance 'general-label
                                 :value (read-credits-message)))
         (menu (make-instance 'alloy:vertical-linear-layout
                              :cell-margins (alloy:margins 5)
							                :min-size (alloy:size 120 30))))
    (make-instance 'menu-button
                   :value "Back"
                   :focus-parent focus
                   :layout-parent menu
                   :on-activate (lambda ()
                                  (setf +player+ NIL)
                                  (change-scene +main+ (make-instance 'menu))))
    (alloy:enter title layout :constraints `((:center :w) (:top 100)))
    (alloy:enter credits layout :constraints `((:center :w) (:top 400)))
    (alloy:enter menu layout
                 :constraints `((:center :w) (:bottom 20) (:height 350) (:width 550)))
    (alloy:finish-structure credits-panel layout focus)))

(defmethod setup-scene ((main main) (scene credits))
  (enter (make-instance 'fps-counter) scene)
  ;; (enter (make-instance 'display-controller) scene)
  (let ((game (make-instance 'render-pass))
        (ui (make-instance 'credits-ui))
        (combine (make-instance 'blend-pass :name 'blend-pass)))
    ;; Setup scene
    (setf +map-key-events+ nil)
    (enter (make-instance 'starfield-menu :star-count 750) scene)
    (enter (make-instance 'player-spaceship-for-menu) scene)
    (enter (make-instance 'spacepilot-camera :location (vec 0 0 30)) scene)
    (connect (port game 'color) (port combine 'a-pass) scene)
    (connect (port ui 'color) (port combine 'b-pass) scene)
    (trial-alloy:show-panel 'credits-panel)
    (preload (// 'spacepilot-music 'background-music) scene)))
