(in-package :cl-user)

#+NIL(setf (sb-ext:bytes-consed-between-gcs)
      999999999999999999)

#+NIL(pushnew :debug *features*)


(pushnew :foreign-managed-finalizations *features*)

(pushnew :unmanaged-finalizations *features*)

(pushnew :native-finalizations *features*)

