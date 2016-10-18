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
  (let* ((newMatches '(()))) ; create empty list, nil
    (loop for chipCh in chiperWord
      for plainCh in plainWord do
      (format t " chipCh : ~a, plainCh : ~a~%" chipCh plainCh)
      ; TODO: burası recursive olabilir
      (loop for matched in matchedWords do
        (loop for item in (rest matched) do
          (if (equal (first item) chipCh) ;sifreli eleman listede varmi
              (if (equal (second item) plainCh); listede aynisimi var. (X U) == (X U) ise devam
                  (format t "   same element in match list~%")
                  (progn (format t "   match with diff element~%") (return-from is-matched nil)) ; (X U) degilde (X Z ) varsa listede daha onceden eslesmis
                )
            (progn
             (format t "    ~a not matched with item~a~%" chipCh item)
             (setq newMatches (append (list (cons chipCh (cons plainCh nil))) newMatches  ))
             ))
          )
        )
      )
    newMatches
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
        (format t "~a. word: ~a, nth: ~a, matchRes : ~a~%" startIndex word (nth startIndex dictionary ) matchRes)
        (cond ((null matchRes) (setf startIndex (1+ startIndex)))
          (t (return-from getMatchedParts matchRes) )
          )
        )
      (when (equal startIndex listLength) (return-from getMatchedParts nil))
      )
    )
    )


(getMatchedParts '(a i y t) '0 '((2 (a t)(i h))) '((o k e y)(f r o m)(t h i s))  )


;(format t "Test :~a~%" (foo '((K Q S S Y) (A I Y T) (M K Q))) )







;
