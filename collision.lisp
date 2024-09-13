(in-package #:spacepilot)

(defclass collision-body (rigidbody) ())

(defmethod shared-initialize :after ((body collision-body) slots &key primitive)
  (when primitive (setf (physics-primitive body) primitive)))

(defmethod physics-primitive ((body collision-body))
  (aref (physics-primitives body) 0))

(defmethod (setf physics-primitive) ((primitive primitive) (body collision-body))
  (setf (physics-primitives body) (vector primitive)))

(define-handler (collision-body pre-tick) ()
  (start-frame collision-body))
