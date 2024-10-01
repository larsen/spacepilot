(in-package #:spacepilot)

(define-shader-entity player-spaceship-for-menu (spaceship)
  ((vertex-array :initform (// 'spacepilot 'player-spaceship '(:cube.002 . 0)))
   (color :initform (vec 0 1 1 1) :initarg :color :accessor color)))

(define-handler (player-spaceship-for-menu tick) (tt dt)
  (setf (orientation player-spaceship-for-menu)
        (q* (qfrom-angle +vx+ (deg->rad -90))
            (qfrom-angle +vy+ tt)))
  (let ((movement (directional 'move))
        (speed 10.0))
    (incf (vx (location player-spaceship-for-menu)) (* dt speed (- (vx movement))))
    (incf (vz (location player-spaceship-for-menu)) (* dt speed (vy movement)))))

(defclass menu (pipelined-scene)
  ())

(define-shader-pass menu-ui (trial-alloy:base-ui)
  ())

(defmethod org.shirakumo.alloy.renderers.opengl.msdf:fontcache-directory ((ui menu-ui))
  (pool-path 'spacepilot "font-cache/"))

(defclass main-panel (trial-alloy:panel)
  ())

(defclass menu-button (alloy:button*)
  ())

(presentations:define-realization (menu-ui menu-button)
  ((:background simple:rectangle)
   (alloy:extent 0 0 550 (alloy:ph 1)))
  ((:label simple:text)
   (alloy:margins 10 0 10 0) alloy:text
   :font "PromptFont"
   :halign :middle
   :size (alloy:un 30)))

(presentations:define-update (menu-ui menu-button)
  (:background
   :pattern (if alloy:focus colors:silver colors:black))
  (:label
   :text alloy:text
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
                                  (setf +player+ NIL)
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
    (enter (make-instance 'player-spaceship-for-menu) scene)
    (enter (make-instance 'target-camera :fov 35.0 :location (vec3 0 5 15)) scene)
    (trial-alloy:show-panel 'main-panel)))
