(in-package #:spacepilot)

(define-shader-entity enemy (vertex-entity spaceship)
  ((color :initform (vec 1 0 0 1))
   (vertex-array :initform
                 (nth 1 (generate-resources
                         'model-file
                         (asdf:system-relative-pathname 'spacepilot #p"data/enemy-spaceship.glb"))))))

(defmethod initialize-instance :after ((enemy enemy) &key)
  (let* ((angle (random 360))
         (orientation (qfrom-angle +vz+ (deg->rad angle)))
         (velocity (nv* (q* orientation +vy3+) 0.1))
         (location (v- (vec 0 0 1) (nv* velocity 20))))
    (print velocity)
    (setf (location enemy) location)
    (setf (velocity enemy) velocity)
    (setf (orientation enemy) orientation)))
