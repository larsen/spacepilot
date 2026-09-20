(in-package #:spacepilot)

(define-shader-entity explosion (animated-sprite located-entity transformed-entity)
  ((sprite-data :initform (asset 'spacepilot-images 'explosion))))

(defun make-explosion (location)
  (make-instance 'explosion
                 :scaling (vec 0.1 0.1 0.1)
                 :location location))

(define-handler (explosion tick :after) ()
  (let* ((animation (animation explosion))
         (idx (frame-idx explosion))
         (end (end animation)))
    (when (= idx (- end 1))
      (leave explosion (container explosion)))))
