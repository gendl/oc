(in-package :oc)

(defmethod initialize-instance :after ((obj brep-mesh-incremental-mesh) &rest initargs
				       &key S D (Relative nil Relative-present-p) Ang &allow-other-keys)
  (declare (ignore initargs))
  (setf (ff-pointer obj)
	(cond ((null S) (_wrap_new_BRepMesh_IncrementalMesh__SWIG_0))
	      ((and (typep S 'topods-shape)
		    (typep D 'double-float)
		    (null Relative-present-p)
		    (null Ang))
	       (_wrap_new_BRepMesh_IncrementalMesh__SWIG_3 (ff-pointer S) D))
	      
	      ((and (typep S 'topods-shape)
		    (typep D 'double-float)
		    (null Ang)
		    Relative-present-p)
	       (_wrap_new_BRepMesh_IncrementalMesh__SWIG_2 (ff-pointer S) D Relative))
	      
	      ((and (typep S 'topods-shape)
		    (typep D 'double-float)
		    (typep Ang 'double-float)
		    relative-present-p)
	       (_wrap_new_BrepMesh_IncrementalMesh__SWIG_1 (ff-pointer S) D Relative Ang))
	      
	      (t (error "Invalid arguments to initialize-instance of BRepMesh_IncrementalMesh."))))
  (oc:finalize obj)
  (values))

(defmethod perform ((self brep-mesh-incremental-mesh))
  (_wrap_BRepMesh_IncrementalMesh_Perform (ff-pointer self)))
