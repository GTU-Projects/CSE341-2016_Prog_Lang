; *********************************************
; *  341  Programming Languages               *
; *  Fall 2016                                *
; *  Author: Hasan MEN                        *
; *********************************************

(load "document.cl")

(defun get-chiper-ch (ch)
	; takes a char, converts cipher char
	(case ch
		('a 'd)
		('b 'e)
		('c 'f)
		('d 'p)
		('e 'q)
		('f 'a)
		('g 'b)
		('h 'k)
		('i 'l)
		('j 'c)
		('k 'r)
		('l 's)
		('m 't)
		('n 'g)
		('o 'y)
		('p 'z)
		('q 'h)
		('r 'i)
		('s 'j)
		('t 'm)
		('u 'n)
		('v 'o)
		('w 'u)
		('x 'v)
		('y 'w)
		('z 'x)
	))

(defun encode-word (word)
	(if (null word) ()
		(append (list (get-chiper-ch (car word))) (encode-word (cdr word)))
	))

(defun encode-parag (paragraph)
	(if (null paragraph) ()
		(append (list (encode-word (car paragraph))) (encode-parag (cdr paragraph)))))

(defun encode-doc (doc)
	(if (null doc) ()
		(append (list (encode-parag (car doc)) (encode-doc (cdr doc))))))


(defvar *w1* '(h e l l o))
(defvar *p1* '((h e l l o)(t h i s)))

(defun test-encodes ()
	; tests encode functions
	(format t " *** TEST FOR ENCODE STARTED ~%")

	(format t "encode-ch c: ~a ~%" (get-chiper-ch 'c))
	(format t "encode-word ~a : ~a ~%" *w1* (encode-word *w1*))
	(format t "encode-paragraph ~a : ~a ~%" *p1* (encode-parag *p1*))
	(format t "encode-doc ~a : ~a ~%" *test-document* (encode-doc *test-document*))
)

;(test-encodes)
(format t "~a~%" (encode-parag (first *test-document*)))
;(format t "~a~%" (encode-parag '((t h i s)(c o u r s e)(c o v e r s)(t o p i c s)(i n)(p r o g r a m m i n g)(l a n g u a g e s)(a n d)(c o m p i l e r s))))
;(format t "~a~%" (encode-parag '((H e l l o)(f r o m)(t h e)(o t h e r)(s i d e))))
