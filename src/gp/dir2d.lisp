(in-package :gp)

(defun dir2d (&rest args &key (xv 0.0d0) (yv 0.0d0)
			   (v (vec2d 1.0d0 0.0d0))
			   (coord (xy 1.0d0 0.0d0))
			   &allow-other-keys)
  (let* ((pointer (foreign-alloc '(:struct gp-dir2d)))
	 (struct (make-dir2d :ptr pointer)))

    (cond ((null args)
	   (setf (gp-xy-x pointer) 1.0d0
		 (gp-xy-y pointer) 0.0d0))

	  ((and (rest args)
		(null (rest (rest args)))
		(realp (first args))
		(realp (second args))
		(let* ((df-xv (coerce (first args) 'double-float))
		       (df-yv (coerce (second args) 'double-float))
		       (d (sqrt (+ (* df-xv df-xv) (* df-yv df-yv)))))
		  (assert (> d +resolution+))
		  (setf (gp-xy-x pointer) (/ df-xv d)
			(gp-xy-y pointer) (/ df-yv d)))))

	  ((and (null v)
		(null coord)
		(realp xv)
		(realp yv))
	   (let* ((df-xv (coerce xv 'double-float))
		  (df-yv (coerce yv 'double-float))
		  (d (sqrt (+ (* df-xv df-xv) (* df-yv df-yv)))))
	     (assert (> d +resolution+))
	     (setf (gp-xy-x pointer) (/ df-xv d)
		   (gp-xy-y pointer) (/ df-yv d))))

	  ((and (null xv)
		(null yv)
		(null v)
		(xy-p coord))
	   (let* ((p-c (ptr coord))
		  (d (gp-xy-modulus p-c)))
	     (assert (> d +resolution+))
	     (setf (gp-xy-x pointer) (/ (gp-xy-x p-c) d)
		     (gp-xy-y pointer) (/ (gp-xy-y p-c) d))))

	  ((and (null xv)
		(null yv)
		(null coord)
		(vec2d-p v))
	   (let* ((p-v (ptr v))
		  (d (gp-xy-modulus p-v)))
	     (assert (> d +resolution+))
	     (setf (gp-xy-x pointer) (/ (gp-xy-x p-v) d)
		   (gp-xy-y pointer) (/ (gp-xy-y p-v) d))))

	  (t (error "Invalid arguments to constructor: ~S" args)))
    
    (finalize struct (lambda () (print 'freeing-dir2d) (foreign-free pointer)) :dont-save t)
    struct))

(defmethod print-object ((object dir2d) stream)
  (format stream "(~S ~S ~S)" (type-of object) (x object) (y object))
  object)

(defmethod x ((xy dir2d))
  (gp-xy-x (ptr xy)))

(defmethod y ((xy dir2d))
  (gp-xy-y (ptr xy)))
