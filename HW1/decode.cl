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
(load "encode.cl")

;; -----------------------------------------------------
;; HELPERS

;; -----------------------------------------------------
;; DECODE FUNCTIONS

(defun Gen-Decoder-A (paragraph)
  ; find decoded paragraph with brute force
)

(defun Gen-Decoder-B-0 (paragraph)
  ;you should implement this function
)

(defun Gen-Decoder-B-1 (paragraph)
  ;you should implement this function
)

(defun Code-Breaker (document decoder)
  (decoder document)
)

;(format t "~a" (spell-checker-1 '(h e l l o)))


;(defparameter *alphabet* '(a b c d e f g h i j k l m n o p q r s t u v w x y z))
;(defparameter *alphabet1* '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0))
;(format t "~a ~%" (apply-list 'c2i *alphabet*))

;(format t "test: ~a ~%" (rec-test '((h o t)(h e r x)(a s)(h o t)) *my-d1*))



(format t "~a~%" (encode-parag '((H e l l o)(f r o m)(t h e))))

(defun is-matched (chiperWord plainWord matchedWords)
  (loop for chipCh in chiperWord
    for plainCh in plainWord do
    (format t " chipCh : ~a, plainCh : ~a~%" chipCh plainCh)
    (loop for matched in matchedWords do
      (loop for item in (rest matched) do
        (cond ((equal (first item) chipCh) (format t "    matched with item~a~%" item))
              (t (format t "   not matched with item~a~%" item)))
        )
      )
    )
  )

; belirtilen indexten itibaren esletirmeye calis. Eslesince (2 (x y)(z y))
; seklinde return et, eslesme yoksa nil return et
(defun getMatchedParts (word startIndex matchedWords dictionary)
  (format t "word: ~a, matchedWords: ~a , " word matchedWords)
  (let* ((listLength (length dictionary)))
    (format t "Dictionary length: ~a~%" listLength)
    (loop ; sozluk boyutu kadar donecek
      (let* ((matchRes (is-matched word (nth startIndex dictionary) matchedWords)))
        (format t "~a.matchRes : ~a , word: ~a, nth: ~a ~%" startIndex matchRes word (nth startIndex dictionary))
        (cond ((null matchRes) (setf startIndex (1+ startIndex)))
          (t (return-from getMatchedParts matchRes) )
          )
        )
      (when (equal startIndex listLength) (return-from getMatchedParts nil))
      )
    )
    )


(getMatchedParts '(a i y t) '1 '((2 (a x)(i k))) '((t h i s)(o k e y)(f r o m))  )

;(format t "Test :~a~%" (foo '((K Q S S Y) (A I Y T) (M K Q))) )







;
