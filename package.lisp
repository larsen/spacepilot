(defpackage #:spacepilot
  (:use #:cl+trial)
  (:shadow #:main #:launch)
  (:local-nicknames
   (#:v #:org.shirakumo.verbose)
   (#:harmony #:org.shirakumo.fraf.harmony.user)
   (#:trial-harmony #:org.shirakumo.fraf.trial.harmony)
   (#:sequences #:org.shirakumo.trivial-extensible-sequences))
  (:export #:main #:launch))
