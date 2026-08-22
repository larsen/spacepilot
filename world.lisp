(in-package #:spacepilot)

(defclass world (pipelined-scene)
  ((enemy-spawn-timer :initform 0f0 :initarg :spawn-timer :accessor spawn-timer)))

(defun ensure-player ()
  (unless +player+
    (setf +player+ (make-instance 'player :name :player)))
  +player+)

(defun setup-world (world)
  (let ((player (ensure-player)))
    (clear +spaceships+)
    (when (container +spaceships+)
      (leave +spaceships+ (container +spaceships+)))
    (enter +spaceships+ world)
    (enter (make-instance 'starfield :star-count 500) world)
    (enter player +spaceships+)
    (preload (make-instance 'enemy) world)
    (preload (make-instance 'explosion) world)
    (preload (make-instance 'bullet :target :nobody) world)
    (preload (// 'spacepilot-music 'background-music) world))
  world)

(defmethod setup-scene ((main main) (scene world))
  (setf +map-key-events+ T)
  (enter (make-instance 'fps-counter) scene)
  ;; (enter (make-instance 'display-controller) scene)
  (observe! (size scene) :title "Entities in game")
  (observe! (size +spaceships+) :title "Entities in spaceships bag")
  (observe! (spawn-timer scene) :title "Spawn timer")
  (observe! +player-speed+ :title "Player speed")
  (let ((game (make-instance 'render-pass))
        (ui (make-instance 'ui))
        (combine (make-instance 'blend-pass :name 'blend-pass)))
    (setup-world scene)
    (enter (make-instance 'spacepilot-camera :location (vec 0 0 30)) scene)
    (connect (port game 'color) (port combine 'a-pass) scene)
    (connect (port ui 'color) (port combine 'b-pass) scene)))

(define-handler (world tick :before) ()
  (do-scene-graph (obj world)
    ;; We should use proper frustum culling, but at the moment these checks don't work
    ;; (not (in-view-p obj (camera world)))
    (when (and (or (typep obj 'enemy)
                   (typep obj 'bullet))
               (> (vlength (vxy_ (location obj))) 50))
      (leave obj (container obj)))))

(define-handler (world tick :after) (dt)
  (incf (spawn-timer world) dt)
  (when (> (spawn-timer world) 3)
    (setf (spawn-timer world) 0)
    ;; This will make each individual enemy to enter the scene
    (make-instance 'squadron :scene +spaceships+)))


(defun world-screen-pos (pos)
  ;; TODO: it should also work in 3d, if I want to implement an
  ;; alternative POV with a 3d camera
  (let ((camera (camera (scene +main+))))
    (let ((pos (v+ pos (v/ (vec2 (width *context*)
                                 (height *context*)) 2))))
      (v* (nv- pos (vxy (location camera))) 1.0 1))))
