(defpackage #:spacepilot
  (:use #:cl+trial)
  (:shadow #:main #:launch)
  (:local-nicknames
   (#:v #:org.shirakumo.verbose)
   (#:sequences #:org.shirakumo.trivial-extensible-sequences))
  (:export #:main #:launch))
