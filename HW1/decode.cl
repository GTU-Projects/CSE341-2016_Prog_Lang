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


;(format t "~a~%" (encode-parag '((H e l l o)(f r o m)(t h e))))


; word: (A C) (first: chiper last: plain)
; list : (3 (X T)(A C))
; newslyMatched : yeni eslestirmelerin listesi
; eger liste icinde (A C) varsa AC return et
; eger (A ?) varsa onu return et
; yoksa nil return et
(defun isUsedInList (word matchList newslyMatched)
  ;(format t "inUsedList word:~a matchList:~a~%" word matchList)
  (loop for matched in matchList do
    (loop for item in (rest matched) do
      (if (equal (first item) (first word)) ;sifreli eleman listede varmi
            (return-from isUsedInList item)())
      ))

  (loop for item in newslyMatched do
    (if (equal (first item) (first word)) ;sifreli eleman listede varmi
          (return-from isUsedInList item)())
    )
    nil)

;(format t "test: ~a~%" (isUsedInList '(a c) '((2 (a z)(d v))(3 (b v)(a x)))))

; sifreli kelime ile verilen kelimeyi esletrimeye calisir
; eger daha onceden farklı karakter ile eslesen karakter varsa nil dondurur
; eslesmeyen yeni karakterleri liste olarak return eder
(defun is-matched (chiperWord plainWord matchedWords)
  ;(format t "chipperWord: ~a, plainWord:~a, matchedWords : ~a~%" chiperWord plainWord matchedWords)

  (if (equal (length chiperWord) (length plainWord))()(return-from is-matched nil))

  (let* ((newMatches '())) ; create empty list, nil
    (loop for chipCh in chiperWord
      for plainCh in plainWord do
      ;(format t "chipCh : ~a, plainCh : ~a " chipCh plainCh)
      (let* ((result (isUsedInList (list chipCh plainCh) matchedWords newMatches) ))
        (cond
          ((null result)
            (setf newMatches (append (list(list chipCh plainCh)) newMatches))); listede yoksa ekle
          ((equal (second result) plainCh)); ayni ise ekleme
          (t (return-from is-matched nil)) ; daha once eslesmis demekki, hata ver
          )
        )
      )
    newMatches
    )
  )

; belirtilen indexten itibaren esletirmeye calis. Eslesince (2 (x y)(z y))
; seklinde return et, eslesme yoksa nil return et
(defun getMatchedParts (word startIndex matchedWords dictionary)
  ;(format t "getMatchedParts params -> word: ~a, matchedWords: ~a , " word matchedWords)
  (let* ((listLength (length dictionary)))
    ;(format t "Dictionary length: ~a~%" listLength)
    (loop ; sozluk boyutu kadar donecek
      (let* ((matchRes (is-matched word (nth startIndex dictionary) matchedWords)))
        ;(format t "~a. word: ~a, nth: ~a, matchRes : ~a~%" startIndex word (nth startIndex dictionary ) matchRes)
        (cond
          ((null matchRes) (setf startIndex (1+ startIndex)))
          (t (return-from getMatchedParts (cons startIndex matchRes)) )
          )
        )
      (when (equal startIndex listLength) (return-from getMatchedParts nil))
      )
    )
    )

(defun decodeParagraph (paragraph dictionary)
  (let* ((allMatches nil)(parLen (length paragraph))(index 0)(searchIndex 0)(matchAlp '(())))
    (loop
      (let* ((matches (getMatchedParts (nth index paragraph) searchIndex allMatches dictionary)))
        ;(format t "~a. word: ~a, matchRes : ~a~%" index (nth index paragraph) matches)
        (cond
          ((null matches) (progn
              (setf index (1- index))
              (if (equal index -1)(return-from decodeParagraph nil))
              (setf searchIndex (1+ (first (first allMatches))))
              (setf allMatches (rest allMatches))
              ))
          (t (progn
                (setf index (1+ index))
                (setf allMatches (append (list matches) (list allMatches)))
                (setf searchIndex 0)
               ))
          )
        (when (OR (< index 0) (= index parLen)) (return-from decodeParagraph allMatches))
        )
      )
    )
  nil
  )

(defparameter *chipText* '((K Q S S Y) (T W) (G D T Q) (L J) (D M Y T)))

(format t "Result: ~a ~%" (decodeParagraph *chipText* *my-d1*))
;(format t "test: ~a~%" (decodeParagraph '((A I Y T) (M K Q) (c b u b p))))
;(format t "test2: ~a ~%" (decodeParagraph (first *)

;(format t "test: ~a~%"(getMatchedParts '(a i y t) '0 '((2 (a t)(i h)(t a))) '((o k e y)(f r o m)(t h i s))  ))

;(format t "Test :~a~%" (is-matched '(m k q k p) '(t h i s) '((2 (a t)(i h)(t s))) ))
;(format t "Test :~a~%" (is-matched '(k q s s y) '(h a s a n ) nil ))
;(format t "Test :~a~%" (foo '((K Q S S Y) (A I Y T) (M K Q))) )


;
