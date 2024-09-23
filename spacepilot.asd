(asdf:defsystem #:spacepilot
  :description "Describe spacepilot here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :components ((:file "package")
               (:file "assets")
               (:file "actions")
               (:file "collision")
               (:file "camera")
               (:file "spaceship")
               (:file "explosion")
               (:file "player")
               (:file "enemy")
               (:file "bullet")
               (:file "star")
               (:file "world")
               (:file "main"))
  :depends-on (:trial-harmony
               :trial-glfw
               :trial-png
               :trial-gltf)
  :in-order-to ((test-op (test-op #:spacepilot/test))))

(asdf:defsystem #:spacepilot/test
  :depends-on (#:parachute
               #:spacepilot)
  :components ((:module "tests"
                :components ((:file "package")
                             (:file "main"))))
  :perform (test-op (op _) (symbol-call :parachute :test :spacepilot/test)))
