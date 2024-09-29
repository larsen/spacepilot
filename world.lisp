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
    (enter (init-starfield) world)
    (enter (ensure-player) +spaceships+)
    (loop repeat (lives player)
          for i from 0
          ;; FIXME: how to place entities more scientifically?
          do (enter (make-instance 'player-life
                                   :location (vec3 (+ 20 (* i 3))
                                                   18 0))
                    world))
    (preload (make-instance 'enemy) world)
    (preload (make-instance 'explosion) world)
    (preload (make-instance 'bullet :target :nobody) world)
    (preload (// 'spacepilot-music 'background-music) world))
  world)

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
