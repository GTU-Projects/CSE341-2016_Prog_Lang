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

(defun match-word (word startIndex)
  (if (member word *my-d1*)
  ;(if (equal word '(a i y t)) ; from yerine sozlukte devam edilecek index gel
    t nil
    ))


(defun foo (l)

  (let* ((cIndex 0)(lLength (length l))) ; sifreli eleman indexi
    (loop
      (let* ((cWord (nth cIndex l))(mapList (match-word cWord cIndex)))
        (format t "Index: ~a ChipperWord : ~a~%" cIndex cWord)
        (cond
          ((numberp mapList) (setq cIndex (1+ cIndex)));map okey
          (t (setq cIndex (1- cIndex)))) ; map fail

        )

      ;(setq cIndex (1+ cIndex))
      (when (= cIndex lLength) (return 'a))
      )
    )


  )

; (I K)  (index1 (V E))(index (A U)(T Z)(I T))
; (I K)  yeni match edilmek istenen
; (index1 (V E))(index (A U)(T Z)(I T)) daha onceden match edilenlerin ornek kumesi
; I ye karsilik gelen sifre daha onceden match edilmismi bakılır
(defun is-matched-before (matches new-match)
  (loop for item in matches do
    (loop for match in (rest item) do
      (format t "new-match: ~a --  match: ~a~%" new-match match)
      (if (equal (first match) (first new-match))
        (return-from is-matched-before match)
        ()))))

(defun match-word (chippedWord index l matches)
  (format t "chippedWord : ~a -- index: ~a -- matches: ~a~%" chippedWord index matches)
  (let* ((dicList (nthcdr  index l)))
      (format t "Dic :~a~%" dicList)
      (loop for word in dicList do
        (format t "word:~a ~%" word)
        (loop for ch1 in chippedWord
            for ch2 in word do
          (let* ((match-val (is-matched-before matches (cons ch1 (cons ch2 nil)))))
            ; match yoksa veya edilen kendisi degilse yeni listeye ekle
            ; diger match durumunda nil dondur
            (if (null match-val)
              (format t "not anymatch~%")
              (if (equal (first (rest match-val)) ch2)
                (format t "matched with old value ~a~%" match-val)
                (format t "matched with diff value ~a~%" match-val))))
          )
        )
    )
  )

(match-word '(a i y t) '0 '((t h i s)(o k e y)(f r o m)) '((2 (a x)(i k))))



;(format t "Test :~a~%" (foo '((K Q S S Y) (A I Y T) (M K Q))) )








;
