(in-package :oc)

(defmethod initialize-instance :after ((instance cpnts-uniform-deflection) &rest initargs
				       &key C Deflection U1 U2 Resolution (WithControl nil WithControl-supplied-p) &allow-other-keys)
  (let ((ptr (cond ((null initargs) (_wrap_new_CPnts_UniformDeflection__SWIG_0))
		   ((and (typep C 'adaptor3d-curve) Deflection Resolution WithControl-supplied-p)
		    (_wrap_new_CPnts_UniformDeflection__SWIG_1 (ff-pointer C)
							       (coerce Deflection 'double-float)
							       (coerce Resolution 'double-float)
							       WithControl))
		   ((and (typep C 'adaptor2d-curve2d) Deflection Resolution WithControl-supplied-p)
		    (_wrap_new_CPnts_UniformDeflection__SWIG_2 (ff-pointer C)
							       (coerce Deflection 'double-float)
							       (coerce Resolution 'double-float)
							       WithControl))
		   ((and (typep C 'adaptor3d-curve) Deflection U1 U2 Resolution WithControl-supplied-p)
		    (_wrap_new_CPnts_UniformDeflection__SWIG_3 (ff-pointer C)
							       (coerce Deflection 'double-float)
							       (coerce U1 'double-float)
							       (coerce U2 'double-float)
							       (coerce Resolution 'double-float)
							       WithControl))
		   ((and (typep C 'adaptor2d-curve2d) Deflection U1 U2 Resolution WithControl-supplied-p)
		    (_wrap_new_CPnts_UniformDeflection__SWIG_4 (ff-pointer C)
							       (coerce Deflection 'double-float)
							       (coerce U1 'double-float)
							       (coerce U2 'double-float)
							       (coerce Resolution 'double-float)
							       WithControl)))))
    (setf (ff-pointer instance) ptr)
    (setf (slot-value instance 'curve) C)
    (oc:finalize instance)
    (values)))
		   
(defmethod next ((self cpnts-uniform-deflection))
  (_wrap_CPnts_UniformDeflection_Next (ff-pointer self)))

(defmethod more-p ((self cpnts-uniform-deflection))
  (_wrap_CPnts_UniformDeflection_More (ff-pointer self)))

(defmethod get-point ((self cpnts-uniform-deflection))
  (let ((pnt (gp::make-pnt :ptr (_wrap_CPnts_UniformDeflection_Point (ff-pointer self)))))
    (oc:finalize pnt)
    pnt))	

(defmethod value ((self cpnts-uniform-deflection))
  (_wrap_CPnts_UniformDeflection_Value (ff-pointer self)))

(defmethod done-p ((self cpnts-uniform-deflection))
  (_wrap_CPnts_UniformDeflection_IsAllDone (ff-pointer self)))
