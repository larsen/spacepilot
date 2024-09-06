(directional move
             (stick :one-of ((:l-h :l-v)))
             (keys :one-of ((:w :a :s :d))))

(directional camera-move
             (stick :one-of ((:r-h :r-v))))

(trigger fire
         (button :one-of (:a))
         (key :one-of (:space)))
