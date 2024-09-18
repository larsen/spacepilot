(in-package #:spacepilot)

(define-shader-entity spaceship (vertex-entity collision-body transformed-entity colored-entity listener)
  ((velocity :initform (vec 0 0 0) :initarg :velocity :accessor velocity)
   (vertex-array :initform (// 'trial 'unit-sphere))
   (color :initform (vec 0 1 1 1) :initarg :color :accessor color)))

(defmethod initialize-instance :after ((spaceship spaceship) &key)
  (setf (physics-primitive spaceship) (make-sphere :radius 1.5)))

(define-handler (spaceship tick) (dt)
  (nv+* (location spaceship) (velocity spaceship) dt))

;; stolen from the collision.lisp example in Trial
(define-class-shader (spaceship :fragment-shader)
  "in vec3 v_view_position;
in vec3 v_world_position;
uniform vec4 objectcolor;
out vec4 color;

void main(){
  vec3 normal = cross(dFdx(v_view_position), dFdy(v_view_position));
  normal = normalize(normal * sign(normal.z));

  // Shitty phong diffuse lighting
  vec3 light_dir = normalize(vec3(10, 5, 10) - v_world_position);
  vec3 reflect_dir = reflect(-light_dir, normal);
  vec3 radiance = vec3(0.75) * (objectcolor.xyz * max(dot(normal, light_dir), 0));
  radiance += vec3(0.2) * objectcolor.xyz;
  color = vec4(radiance, objectcolor.w);
}")
