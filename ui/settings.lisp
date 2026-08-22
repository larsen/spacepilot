(in-package #:spacepilot)

(defclass settings (pipelined-scene)
  ())

(define-shader-pass settings-ui (spacepilot-ui)
  ())

(defclass settings-panel (trial-alloy:panel)
  ())

(defmethod initialize-instance :after ((settings-panel settings-panel) &key)
  (let* ((layout (make-instance 'org.shirakumo.alloy.layouts.constraint:layout))
         (focus (make-instance 'alloy:focus-list))
         (title (make-instance 'title :value "Settings"))
         (menu (make-instance 'alloy:vertical-linear-layout
                              :cell-margins (alloy:margins 5)
							                :min-size (alloy:size 120 30))))
    (alloy:represent "Music Volume" 'setting-label :focus-parent focus :layout-parent menu)
    (alloy:represent (setting :audio :volume :master)
     'alloy:ranged-slider :range '(0.0 . 1.0) :step 0.1
                          :focus-parent focus :layout-parent menu)
    (make-instance 'menu-button
                   :value "Back"
                   :focus-parent focus
                   :layout-parent menu
                   :on-activate (lambda ()
                                  (setf +player+ NIL)
                                  (change-scene +main+ (make-instance 'menu))))
    (make-instance 'menu-button
                   :value "Quit game"
                   :focus-parent focus
                   :layout-parent menu
                   :on-activate (lambda ()
                                  (quit *context*)))
    (alloy:enter title layout :constraints `((:center :w) (:top 100)))
    (alloy:enter menu layout
                 :constraints `((:center :w) (:bottom 20) (:height 350) (:width 550)))
    (alloy:finish-structure settings-panel layout focus)))

(defmethod setup-scene ((main main) (scene settings))
  (enter (make-instance 'fps-counter) scene)
  ;; (enter (make-instance 'display-controller) scene)
  (let ((game (make-instance 'render-pass))
        (ui (make-instance 'settings-ui))
        (combine (make-instance 'blend-pass :name 'blend-pass)))
    ;; Setup scene
    (setf +map-key-events+ nil)
    (enter (make-instance 'starfield-menu :star-count 750) scene)
    (enter (make-instance 'player-spaceship-for-menu) scene)
    (enter (make-instance 'spacepilot-camera :location (vec 0 0 30)) scene)
    (connect (port game 'color) (port combine 'a-pass) scene)
    (connect (port ui 'color) (port combine 'b-pass) scene)
    (trial-alloy:show-panel 'settings-panel)
    (preload (// 'spacepilot-music 'background-music) scene)))

(define-handler (settings scene-changed) ()
  (harmony:transition (// 'spacepilot-music 'background-music) :normal))
