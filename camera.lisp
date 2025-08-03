(in-package #:spacepilot)

(defclass spacepilot-camera (3d-camera)
  ())

(defclass spacepilot-pivot-camera (pivot-camera)
  ()
  (:default-initargs :radius 20))

(defclass spacepilot-editor-camera (editor-camera)
  ())
