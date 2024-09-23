(in-package #:spacepilot)

(defclass spacepilot-camera (pivot-camera listener)
  ((up :initform +vz3+)
   (radius :initform 20.0)))

;; (define-handler (spacepilot-camera tick) (dt)
;;   (when (retained :q) (decf (location spacepilot-camera)
;;                             (q* (location spacepilot-camera) dt)))
;;   (when (retained :q) (decf (location spacepilot-camera)
;;                             (q* (location spacepilot-camera) dt))))
