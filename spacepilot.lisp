(in-package #:spacepilot)

(defclass main (trial:main)
  ())

(defvar +player-speed+ (vec 10 10 0))

(define-shader-entity bullet (vertex-entity colored-entity transformed-entity listener)
  ((vertex-array :initform (// 'trial 'unit-sphere))
   (color :initform (vec 0 1 1 1))
   (velocity :initform (vec 0 0 0) :initarg :velocity :accessor velocity)))

(define-handler (target-camera tick) (dt)
  (let ((movement (directional 'camera-move)))
    (v+ (vec4 (location target-camera) 0f0) movement)))

(define-handler (star tick) (dt)
  (nv+* (location star) (velocity star) dt))

(define-handler (bullet tick) (dt)
  (nv+* (location bullet) (velocity bullet) dt))

;; (define-handler (my-cube hide) ()
;;   (setf (vw (color my-cube)) (if (= (vw (color my-cube)) 1.0) 0.1 1.0)))

(setf +app-system+ "spacepilot")

(defmethod setup-scene ((main main) scene)
  (let ((player (make-instance 'player)))
    (loop repeat 1000
          do (enter (make-instance 'star :location (v+ (vrand 0f0 1000.0)
                                                       (vec 0 0 40))) scene))
    (enter player scene)
    (enter (make-instance 'enemy) scene)
    (enter (make-instance '3d-camera :location (vec 0 0 -30)) scene)
    (enter (make-instance 'render-pass) scene)
    (preload (make-instance 'bullet) scene)))

(defun launch (&rest args)
  (let ((*package* #.*package*))
    (load-keymap)
    (setf (active-p (action-set 'in-game)) T)
    (apply #'trial:launch 'main args)))
