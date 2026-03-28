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
               (:module "entities"
                :components ((:file "spaceship")
                             (:file "player")
                             (:file "enemy")
                             (:file "bullet")
                             (:file "star")))
               (:file "explosion")
               (:file "world")
               (:file "ui")
               (:file "commands")
               (:file "main")
               (:file "menu")
               (:file "settings"))
  :depends-on (:trial-harmony
               :trial-alloy
               :alloy-constraint
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
