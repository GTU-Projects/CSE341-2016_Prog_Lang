; *********************************************
; *  341  Programming Languages               *
; *  Fall 2016                                *
; *  Author: Liu Liu                          *
; *          Ulrich Kremer                    *
; *          Furkan Tektas , clisp            *
; *********************************************

;; ENVIRONMENT
;; "c2i, "i2c",and "apply-list"
(load "include.cl")

;; test document
(load "document.cl")

;; test-dictionary
;; this is needed for spell checking
(load "test-dictionary.cl")

(load "dictionary.cl") ;;  real dictionary (45K words)

;; encode functions
;; includes encode ch,word and paragraph
;(load "encode.cl")

;; -----------------------------------------------------
;; DECODE FUNCTIONS

(defun Gen-Decoder-A (paragraph)
)

(defun Gen-Decoder-B (paragraph)
  )


(defun Code-Breaker (document decoder)
  (decoder document)
)




(defun count-letter (l)
  (let* ((arr (make-array 26 :initial-element 0)))
    (loop for item in l do
      (loop for ch in item do
        (setf (aref arr (c2i ch)) (1+ (aref arr (c2i ch))))
))arr ; return result array
    ))

;(format t "arr: ~a~%" (count-letter '((a a a)(b b b))))
(format t "arr: ~a~%" (count-letter *dictionary*))


;
