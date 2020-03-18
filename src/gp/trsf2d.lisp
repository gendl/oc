(in-package :gp)

(defun trsf2d (&optional trsf)
  (declare (ignorable trsf))
  (let* ((p-trsf2d (foreign-alloc '(:struct gp-trsf2d)))
	 (p-shape (foreign-slot-pointer p-trsf2d '(:struct gp-trsf2d) 'shape))
	 (p-scale p-trsf2d)
	 (p-mat2d (foreign-slot-pointer p-trsf2d '(:struct gp-trsf2d) 'matrix))
	 (p-loc (foreign-slot-pointer p-trsf2d '(:struct gp-trsf2d) 'loc)))
    (setf (mem-aref p-shape :int) +trsf-identity+
	  (mem-aref p-scale :double) 1.0d0)
    (gp-mat2d-identity! p-mat2d)
    (setf (mem-aref p-loc :double 0) 0.0d0
	  (mem-aref p-loc :double 1) 0.0d0)
    (let ((new (make-trsf2d :ptr p-trsf2d)))
      (oc:finalize new :native)
      new)))

(defmethod print-object ((object trsf2d) stream)
  (format stream "#<~S ~S scale: ~S matrix: ~S loc: ~S>" (type-of object)
	  (oc:trsf-form object) (oc:scale-factor object) (oc:homogeneous-vectorial-part object)
	  (make-pnt2d :ptr (foreign-slot-pointer (ptr object) '(:struct gp-trsf2d) 'loc)
		      :own object)))

(defmethod (setf gp:mirror) ((p pnt2d) (trsf trsf2d))
  ;; maybe this shout be set-mirror
  (let* ((p-trsf (ptr trsf))
	 (p-shape (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'shape))
	 (p-scale p-trsf)
	 (p-mat (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'matrix))
	 (p-loc (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'loc))
	 (p-pnt (ptr p)))
    (setf (mem-aref p-shape :int) +trsf-pnt-mirror+
	  (mem-aref p-scale :double) -1.0d0)
    (gp-mat2d-identity! p-mat)
    (setf (mem-aref p-loc :double 0) (* 2.0d0 (gp-xy-x p-pnt))
	  (mem-aref p-loc :double 1) (* 2.0d0 (gp-xy-y p-pnt))))
  p)

(defmethod (setf oc:mirror) ((p pnt2d) (trsf trsf2d))
  (oc::_wrap_gp_Trsf2d_SetMirror__SWIG_0 (ptr trsf) (ptr p))
  p)

(defmethod (setf gp:rotation2) ((p pnt2d) (ang real) (trsf trsf2d))
  (let* ((p-trsf (ptr trsf))
	 (p-shape (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'shape))
	 (p-scale p-trsf)
	 (p-mat (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'matrix))
	 (p-loc (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'loc))
	 (p-pnt (ptr p))
	 (angle (coerce ang 'double-float)))
    (setf (mem-aref p-shape :int) +trsf-rotation+
	  (mem-aref p-scale :double) 1.0d0)
    (gp-mat2d-rotate! p-mat angle)
    (setf (gp-xy-x p-loc) (gp-xy-x p-pnt)
	  (gp-xy-y p-loc) (gp-xy-y p-pnt))
    (gp-xy-mat2d-multiply! p-loc p-mat)
    (gp-xy-add! p-loc p-pnt)
    (values p angle)))

(defmethod (setf oc:rotation2) ((p pnt2d) (ang real) (trsf trsf2d))
  (let ((angle (coerce ang 'double-float)))
    (oc::_wrap_gp_Trsf2d_SetRotation (ptr trsf) (ptr p) angle)
    (values p angle)))

(defmethod (setf gp:scale2) ((p pnt2d) (s real) (trsf trsf2d))
  (let* ((p-trsf (ptr trsf))
	 (p-shape (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'shape))
	 (p-scale p-trsf)
	 (p-mat (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'matrix))
	 (p-loc (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'loc))
	 (p-pnt (ptr p))
	 (scale (coerce s 'double-float)))
    (setf (mem-aref p-shape :int) +trsf-scale+
	  (mem-aref p-scale :double) scale)
    (gp-mat2d-identity! p-mat)
    (setf (gp-xy-x p-loc) (gp-xy-x p-pnt)
	  (gp-xy-y p-loc) (gp-xy-y p-pnt))
    (gp-xy-multiply!-with-scalar p-loc (- 1.0d0 scale))
    (values p scale)))

(defmethod (setf oc:scale2) ((p pnt2d) (s real) (trsf trsf2d))
  (let ((scale (coerce s 'double-float)))
    (oc::_wrap_gp_Trsf2d_SetRotation (ptr trsf) (ptr p) scale)
    (values p scale)))

(defmethod (setf gp:translation) ((v vec2d) (trsf trsf2d))
  (let* ((p-trsf (ptr trsf))
	 (p-shape (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'shape))
	 (p-scale p-trsf)
	 (p-mat (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'matrix))
	 (p-loc (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'loc))
	 (p-vec (ptr v)))
    (setf (mem-aref p-shape :int) +trsf-translation+
	  (mem-aref p-scale :double) 1.0d0)
    (gp-mat2d-identity! p-mat)
    (setf (gp-xy-x p-loc) (gp-xy-x p-vec)
	  (gp-xy-y p-loc) (gp-xy-y p-vec))
    (values)))

(defmethod (setf oc:translation) ((v vec2d) (trsf trsf2d))
  (oc::_wrap_gp_Trsf2d_SetTranslation__SWIG_0 (ptr trsf) (ptr v))
  v)

(defmethod (setf gp:translation2) ((p1 pnt2d) (p2 pnt2d) (trsf trsf2d))
  (let* ((p-trsf (ptr trsf))
	 (p-shape (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'shape))
	 (p-scale p-trsf)
	 (p-mat (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'matrix))
	 (p-loc (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'loc))
	 (p-pnt1 (ptr p1))
	 (p-pnt2 (ptr p2)))
    (setf (mem-aref p-shape :int) +trsf-translation+
	  (mem-aref p-scale :double) 1.0d0)
    (gp-mat2d-identity! p-mat)
    (setf (gp-xy-x p-loc) (- (gp-xy-x p-pnt2) (gp-xy-x p-pnt1))
	  (gp-xy-y p-loc) (- (gp-xy-y p-pnt2) (gp-xy-y p-pnt1)))
    (values (gp:subtracted (gp:coord p1) p2))))

(defmethod (setf oc:translation2) ((p1 pnt2d) (p2 pnt2d) (trsf trsf2d))
  (oc::_wrap_gp_Trsf2d_SetTranslation__SWIG_1 (ptr trsf) (ptr p1) (ptr p2))
  (values))

(defmethod gp:negative? ((trsf trsf2d))
  (let* ((p-trsf (ptr trsf))
	 (p-mat (foreign-slot-pointer p-trsf '(:struct gp-trsf2d) 'matrix)))
    (minusp (gp-mat2d-determinant p-mat))))

(defmethod oc:negative? ((trsf trsf2d))
  (oc::_wrap_gp_Trsf2d_IsNegative (ptr trsf)))
	
(defmethod gp:translation-part ((trsf trsf2d))
  (make-xy :ptr (foreign-slot-pointer (ptr trsf) '(:struct gp-trsf2d) 'loc)
	   :own trsf))

(defmethod oc:translation-part ((trsf trsf2d))
  (let* ((p-result (oc::_wrap_gp_Trsf2d_TranslationPart (ptr trsf)))
	 (result (make-xy :ptr p-result)))
    (oc:finalize result)
    result))

(defmethod (setf gp:translation-part) ((loc vec2d) (trsf trsf2d))
  (let ((p-dst (foreign-slot-pointer (ptr trsf) '(:struct gp-trsf2d) 'loc))
	(p-src (ptr loc))) 
    (setf (mem-aref p-dst :double 0) (mem-aref p-src :double 0)
	  (mem-aref p-dst :double 1) (mem-aref p-src :double 1))
    (values)))

(defmethod (setf oc:translation-part) ((loc vec2d) (trsf trsf2d))
  (oc::_wrap_gp_Trsf2d_SetTranslationPart (ptr trsf) (ptr loc))
  loc)

(defmethod gp:homogeneous-vectorial-part ((trsf trsf2d))
  (make-mat2d :ptr (foreign-slot-pointer (ptr trsf) '(:struct gp-trsf2d) 'matrix)
	      :own trsf))

(defmethod oc:homogeneous-vectorial-part ((trsf trsf2d))
  (let* ((p-result (oc::_wrap_gp_Trsf2d_HVectorialPart (ptr trsf)))
	 (result (make-mat2d :ptr p-result)))
    (oc:finalize result)
    result))

(defmethod (setf gp:homogeneous-vectorial-part) ((mat mat2d) (trsf trsf2d))
  (let ((p-mat-dst (foreign-slot-pointer (ptr trsf) '(:struct gp-trsf2d) 'matrix))
	(p-mat-src (ptr mat)))
    (setf (mem-aref p-mat-dst :double 0) (mem-aref p-mat-src :double 0)
	  (mem-aref p-mat-dst :double 1) (mem-aref p-mat-src :double 1)
	  (mem-aref p-mat-dst :double 2) (mem-aref p-mat-src :double 2)
	  (mem-aref p-mat-dst :double 3) (mem-aref p-mat-src :double 3))
    (values)))

(defmethod gp:get-value2 ((trsf trsf2d) (row integer) (col integer))
  (assert (<= 1 row 2))
  (assert (<= 1 row 3))
  (let ((p-mat (foreign-slot-pointer (ptr trsf) '(:struct gp-trsf2d) 'matrix)))
    (gp-mat2d-get-value2 p-mat row col)))

(defmethod oc:get-value2 ((trsf trsf2d) (row integer) (col integer))
  (oc::_wrap_gp_Trsf2d_Value (ptr trsf) row col))

(defmethod gp:trsf-form ((trsf trsf2d))
  (foreign-slot-value (ptr trsf) '(:struct gp-trsf2d) 'shape))

(defmethod oc:trsf-form ((trsf trsf2d))
  (oc::_wrap_gp_Trsf2d_Form (ptr trsf)))

(defmethod (setf gp:trsf-form) ((form symbol) (trsf trsf2d))
  (foreign-slot-value (ptr trsf) '(:struct gp-trsf2d) 'shape))

(defmethod gp:scale-factor ((trsf trsf2d))
  (mem-aref (ptr trsf) :double))

(defmethod oc:scale-factor ((trsf trsf2d))
  (oc::_wrap_gp_Trsf2d_ScaleFactor (ptr trsf)))

(defmethod (setf gp:scale-factor) ((sf real) (trsf trsf2d))
  (setf (mem-aref (ptr trsf) :double) (coerce sf 'double-float)))

(defmethod (setf oc:scale-factor) ((sf real) (trsf trsf2d))
  (let ((dval (coerce sf 'double-float)))
    (oc::_wrap_gp_Trsf2d_SetScaleFactor (ptr trsf) dval)
    dval))

(defmethod oc:multiplied ((trsf1 trsf2d) (trsf2 trsf2d))
  (let* ((p-result (oc::_wrap_gp_Trsf2d_Multiplied (ptr trsf1) (ptr trsf2)))
	 (result (make-trsf2d :ptr p-result)))
    (oc:finalize result)
    result))
  
(defmethod gp::orthogonalize! ((trsf trsf2d))
  (let* ((mat (oc:copy (oc:homogeneous-vectorial-part trsf)))
	 (v1 (oc:column mat 1))
	 (v2 (oc:column mat 2)))
    
    (oc:normalize! v1)
    (let ((product (oc:dot v2 v1)))
      (setf (gp-xy-x (ptr v2)) (* (gp-xy-x (ptr v1)) product)
	    (gp-xy-y (ptr v2)) (* (gp-xy-y (ptr v1)) product)))

    (setf (oc:column mat 1) v1
	  (oc:column mat 2) v2)

    (setq v1 (oc:row mat 1)
	  v2 (oc:row mat 2))

    (oc:normalize! v1)
    (let ((product (oc:dot v2 v1)))
      (setf (gp-xy-x (ptr v2)) (- (* (gp-xy-x (ptr v1)) product))
	    (gp-xy-y (ptr v2)) (- (* (gp-xy-y (ptr v1)) product))))
    (oc:normalize! v2)

    (setf (oc:row mat 1) v1
	  (oc:row mat 2) v2)

    (let ((p (ptr (oc:homogeneous-vectorial-part trsf))))
      (setf (mem-aref p :double 0) (mem-aref (ptr mat) :double 0)
	    (mem-aref p :double 1) (mem-aref (ptr mat) :double 1)
	    (mem-aref p :double 2) (mem-aref (ptr mat) :double 2)
	    (mem-aref p :double 3) (mem-aref (ptr mat) :double 3)))
    
    (values)))

(defmethod gp:multiply! ((trsf1 trsf2d) (trsf2 trsf2d))
  (let ((shape1 (gp:trsf-form trsf1))
	(shape2 (gp:trsf-form trsf2)))
    (block multiply!
      (cond ((eq shape2 :identity) (return-from multiply!))
	    ((eq shape1 :identity)
	     (setf (gp:trsf-form trsf1) (gp:trsf-form trsf2)
		   (gp:scale-factor trsf1) (gp:scale-factor trsf2)
		   (gp:translation-part trsf1) (gp:translation-part trsf2)
		   (gp:homogeneous-vectorial-part trsf1) (gp:homogeneous-vectorial-part trsf2)))
	    
	    ((and (eq shape1 :rotation) (eq shape1 :rotation))
	     (when (or (not (zerop (x (gp:translation-part trsf1))))
		       (not (zerop (y (gp:translation-part trsf1)))))
	       (gp:add! (gp:translation-part trsf1) (gp:multiplied 
						       (gp:translation-part trsf2)
						       (gp:homogeneous-vectorial-part trsf1))))
	     (gp:multiply! (gp:homogeneous-vectorial-part trsf1) (gp:homogeneous-vectorial-part trsf2)))
	    ((and (eq shape1 :translation) (eq shape2 :translation))
	     (gp:add! (gp:translation-part trsf1) (gp:translation-part trsf2)))

	    ((and (eq shape1 :scale) (eq shape2 :scale))
	     (gp:add! (gp:translation-part trsf1)
		       (gp:multiplied (gp:translation-part trsf2)
				       (gp:scale-factor trsf1)))
	     (setf (gp:scale-factor trsf1) (* (gp:scale-factor trsf1)
					       (gp:scale-factor trsf2))))

	    ((and (eq shape1 :pnt-mirror) (eq shape2 :pnt-mirror))
	     (setf (gp:scale-factor trsf1) 1.0f0)
	     (setf (gp:trsf-form trsf1) :translation)
	     (gp:add! (gp:translation-part trsf1)
		       (gp:reversed (gp:translation-part trsf2))))

	    ((and (eq shape1 :ax1-mirror) (eq shape2 :ax1-mirror))
	     (setf (gp:trsf-form trsf1) :rotation)
	     (let ((tloc (gp:copy (gp:translation-part trsf2))))
	       (gp:multiply! tloc (gp:homogeneous-vectorial-part trsf1))
	       (gp:multiply! tloc (gp:scale-factor trsf1))
	       (setf (gp:scale-factor trsf1) (* (gp:scale-factor trsf1)
						 (gp:scale-factor trsf2)))
	       (gp:add! (gp:translation-part trsf1) tloc)
	       (gp:multiply! (gp:homogeneous-vectorial-part trsf1) (gp:homogeneous-vectorial-part trsf2))))

	    ((and (or (eq shape1 :compound-trsf)
		      (eq shape1 :rotation)
		      (eq shape1 :ax1-mirror))
		  (eq shape2 :translation))
	     (let ((tloc (gp:copy (gp:translation-part trsf2))))
	       (gp:multiply! tloc (gp:homogeneous-vectorial-part trsf1))
	       (unless (= (gp:scale-factor trsf1) 1.0d0)
		 (gp:multiply! tloc (gp:scale-factor trsf1)))
	       (gp:add! (gp:translation-part trsf1) tloc)))

	    ((and (or (eq shape1 :scale)
		      (eq shape1 :pnt-mirror))
		  (eq shape2 :translation))
	     (let ((tloc (gp:copy (gp:translation-part trsf2))))
	       (gp:multiply! tloc (gp:scale-factor trsf1))
	       (gp:add! (gp:translation-part trsf1) tloc)))

	    ((and (or (eq shape2 :compound-trsf)
		      (eq shape2 :rotation)
		      (eq shape2 :ax1-mirror))
		  (eq shape1 :translation))
	     (setf (gp:trsf-form trsf1) :compound-trsf)
	     (setf (gp:scale-factor trsf1) (gp:scale-factor trsf2))
	     (gp:add! (gp:translation-part trsf1) (gp:translation-part trsf2))
	     (setf (gp:homogeneous-vectorial-part trsf1) (gp:homogeneous-vectorial-part trsf2)))

	    ((and (or (eq shape2 :scale)
		      (eq shape2 :pnt-mirror))
		  (eq shape1 :translation))
	     (setf (gp:trsf-form trsf1) (gp:trsf-form trsf2) )
	     (gp:add! (gp:translation-part trsf1) (gp:translation-part trsf2))
	     (setf (gp:scale-factor trsf1) (* (gp:scale-factor trsf1)
					       (gp:scale-factor trsf2))))

	    ((and (or (eq shape1 :pnt-mirror) (eq shape1 :scale))
		  (or (eq shape2 :pnt-mirror) (eq shape2 :scale)))
	     (setf (gp:trsf-form trsf1) :compound-trsf)
	     (let ((tloc (gp:copy (gp:translation-part trsf2))))
	       (gp:multiply! tloc (gp:scale-factor trsf1))
	       (gp:add! (gp:translation-part trsf1) tloc)
	       (setf (gp:scale-factor trsf1) (* (gp:scale-factor trsf1)
						 (gp:scale-factor trsf2)))))

	    ((and (or (eq shape1 :compound-trsf) (eq shape1 :rotation) (eq shape1 :ax1-mirror))
		  (or (eq shape2 :scale) (eq shape2 :pnt-mirror)))
	     (setf (gp:trsf-form trsf1) :compound-trsf)
	     (let ((tloc (gp:copy (gp:translation-part trsf2))))
	       (gp:multiply! tloc (gp:homogeneous-vectorial-part trsf1))
	       (if (not (= (gp:scale-factor trsf1) 1.0d0))
		   (setf (gp:scale-factor trsf1) (gp:scale-factor trsf2))
		   (progn
		     (gp:multiply! tloc (gp:scale-factor trsf1))
		     (setf (gp:scale-factor trsf1) (* (gp:scale-factor trsf1)
						       (gp:scale-factor trsf2)))))
	       (gp:add! (gp:translation-part trsf1) tloc)))

	    ((and (or (eq shape2 :compound-trsf) (eq shape2 :rotation) (eq shape2 :ax1-mirror))
		  (or (eq shape1 :scale) (eq shape1 :pnt-mirror)))
	     (setf (gp:trsf-form trsf1) :compound-trsf)
	     (let ((tloc (gp:copy (gp:translation-part trsf2))))
	       (gp:multiply! tloc (gp:scale-factor trsf1))
	       (setf (gp:scale-factor trsf1) (* (gp:scale-factor trsf1)
						 (gp:scale-factor trsf2)))
	       (gp:add! (gp:translation-part trsf1) tloc)
	       (setf (gp:homogeneous-vectorial-part trsf1) (gp:homogeneous-vectorial-part trsf2))))

	    (t (setf (gp:trsf-form trsf1) :compound-trsf)
	       (let ((tloc (gp:copy (gp:translation-part trsf2))))
		 (gp:multiply! tloc (gp:homogeneous-vectorial-part trsf1))
		 (if (not (= (gp:scale-factor trsf1) 1.0d0))
		     (progn
		       (gp:multiply! tloc (gp:scale-factor trsf1))
		       (setf (gp:scale-factor trsf1) (* (gp:scale-factor trsf1)
							 (gp:scale-factor trsf2))))
		     (setf (gp:scale-factor trsf1) (gp:scale-factor trsf2)))
		 (gp:add! (gp:translation-part trsf1) tloc)
		 (gp:multiply! (gp:homogeneous-vectorial-part trsf1) (gp:homogeneous-vectorial-part trsf2))))))))

(defmethod gp:multiply! ((trsf1 trsf2d) (trsf2 trsf2d))
  (oc::_wrap_gp_Trsf2d_Multiply (ptr trsf1) (ptr trsf2)))

