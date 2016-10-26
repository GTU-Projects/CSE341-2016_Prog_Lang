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

;(load "dictionary.cl") ;;  real dictionary (45K words)

(load "encode.cl")


;; -----------------------------------------------------
;; HELPERS
;; *** PLACE YOUR HELPER FUNCTIONS BELOW ***


;; -----------------------------------------------------
;; DECODE FUNCTIONS

(defun Gen-Decoder-B-1 (paragraph)
  ;you should implement this function
)

(defun Code-Breaker (document decoder)
  ;you should implement this function
)

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
    (if (equal (length chiperWord) (length plainWord))()(return-from is-matched nil))
    ;(format t "chipperWord: ~a, plainWord:~a, matchedWords : ~a~%" chiperWord plainWord matchedWords)
    (let* ((newMatches '())) ; create empty list, nil
      (loop for chipCh in chiperWord
        for plainCh in plainWord do
        (let* ((result (isUsedInList (list chipCh plainCh) matchedWords newMatches) ))
          ;(format t "rest:~a~%" result)
          (cond
            ((null result)
              (setf newMatches (append (list(list chipCh plainCh)) newMatches))); listede yoksa ekle
            ((equal (second result) plainCh) (setf newMatches (append (list(list chipCh plainCh)) newMatches))); ayni ise ekle
            (t (return-from is-matched nil)) ; daha once eslesmis demekki, hata ver
            )
          )
        )
        newMatches
      )
    )

  ; belirtilen indexten itibaren esletirmeye calis. Eslesince (2 (x y)(z y))
  ; seklinde return et, eslesme yoksa nil return et
  (defun find-matches (word startIndex matchedWords)
    ;(format t "getMatchedParts params -> word: ~a, matchedWords: ~a , " word matchedWords)
    (let* ((listLength (length *dictionary*)))
      ;(format t "Dictionary length: ~a~%" listLength)
      (loop ; sozluk boyutu kadar donecek
        ;(format t "str:~a~%" (nth startIndex *dictionary*))
        (let* ((matchRes (is-matched word (nth startIndex *dictionary*) matchedWords)))
          ;(format t "~a. word: ~a, nth: ~a, matchRes : ~a~%" startIndex word (nth startIndex *dictionary* ) matchRes)
          (cond
            ((null matchRes) (setf startIndex (1+ startIndex)))
            (t (return-from find-matches (cons startIndex matchRes)) )
            )
          )
        (when (equal startIndex listLength) (return-from find-matches nil))
        )
      )
      )

(defun find-occs-of-letters (document)
  (let* ((arr (make-array 26 :initial-element 0)))
    (loop for paragraph in document do
      (loop for item in paragraph do
        (loop for ch in item do
          (setf (aref arr (c2i ch)) (1+ (aref arr (c2i ch)))))))
    arr)); return result arr


(defun foo (paragraph searchIndex matches)
  (format t "Debug::~%~tP:~a ~%~tSI:~a ~%~tM:~a~%" paragraph searchIndex matches);
  (if (null paragraph) (return-from foo nil))


  (let* ((newMatches (find-matches (first paragraph) searchIndex matches))(result nil)(foundIndex nil))
    (format t "findMatches: ~a~%" (first paragraph))
    (if (null newMatches) (return-from foo -1)); eslesme yoksa -1 yolla
    (format t "Debug2:: newMatches: ~a~%" newMatches)
    (setf matches (append (list newMatches) matches)) ; yenileri basa ekle


    (setf result (foo (rest paragraph) 0 matches)) ; recursive kolu gerisi icin cagir
    ;(format t "res:~a~%" result)

    (if (equal result -1) ; eger eslesme yoksa
      (progn ; indexten sonrasi icin arama yap
        (setf foundIndex (1+ (first(first matches))))
       (setf matches (rest matches)) ; listenin basini temizle
             (return-from foo (foo paragraph foundIndex matches))) ; yeniden cagir
      ) ; eslesmeler bitti - return et

      (if (null result) ; eger paragraf bittiyse eslemeleri dondur
        matches
        result) ; recursive kollar icin return dondur

    )
  )

(defun list2alph (l)
  (if (null l) (return-from list2alph nil))
  (let* ((arr (make-array 26 :initial-element 0)))
    (loop for item in l do
      (loop for i in item do
        ;(format t "i:~a~%" i)
        (if (numberp i) ()
          (setf (aref arr (c2i (second i))) (first i)))
        ))arr))

(defun get-most-6-occ (l)
  ;((a e)(m t)(e a)(y o)(n i)(o n))
  ; a sifresi e yi belirtir
  ; y nin decodu o
  (let* ((mostArr (find-occs-of-letters l))(mostList nil)(max -1)(index -1)(resList nil))
    (loop for j from 1 to 6 do
      (loop for i from 0 to 25 do
        (if (member i mostList)
          () ; eger eklenmisse devam et
          (progn
           (if (> (aref mostArr i) max)
             (progn ;(format t"i:~amax:~a--"(aref mostArr i) max) ; max olana bak
                    (setf max (aref mostArr i))
                    (setf index i))
             )))
        )
        (setf mostList (append mostList (list index)))
        (setf max -1)
      )
    ;(format t"mostList ~a~%" mostList )
    (setf resList (append resList (list (list (i2c (first mostList)) 'e))))
    (setf resList (append resList (list (list (i2c (second mostList)) 't))))
    (setf resList (append resList (list (list (i2c (third mostList)) 'a))))
    (setf resList (append resList (list (list (i2c (fourth mostList)) 'o))))
    (setf resList (append resList (list (list (i2c (fifth mostList)) 'i))))
    (setf resList (append resList (list (list (i2c (sixth mostList)) 'n))))
    )
  )


  ;(format t "TEST::get-most-6-occ l:~a~% res:~a" (encode-doc *document3*) (get-most-6-occ (encode-doc *document3*)))
  ;(terpri)(terpri)(terpri)


(defun decode-all (doc)
  ;(let* ((allDoc nil)(matches '((0 (a e)(r t)(e a)(n o)(s i)(i n)))))
  (let* ((allDocAsPrg nil)(matches nil))
    (loop for i in doc do
      (setf allDocAsPrg (append allDocAsPrg i)));tum documani tek prg gibi yap

      (setf matches (cons 0 (get-most-6-occ doc))) ; ilk 6 eslemeyi al

      (format t "allDocAsPrg:~a~%" allDocAsPrg)
      (format t "6matches: ~a~%" matches)
      (format t "Res: ~a~%" (foo allDocAsPrg 0 (list matches)))
      (format t "alph:   ~a~%" (list2alph (foo allDocAsPrg 0 (list matches))))
      (list2alph (foo allDocAsPrg 0 (list matches)))
    )
  )


(defun writeOccAlp (arr)
  (format t "Char occurences: ")
  (loop for i from 0 to 25 do
    (format t "(~a, ~a), " (i2c i) (aref arr i))
    )
  (terpri)
  )

(defparameter *alphabet* '(a b c d e f g h i j k l m n o p q r s t u v w x y z))
(defparameter *chipAlph* (encode-word *alphabet*))

(format t "Alph:    ~a~%" *alphabet*)
(format t "ChipAlp: ~a~%"*chipAlph*)
(format t "--------------------------------------------------------------~%")

(format t "Plain doc: ~a~%~%" *document3*)
(writeOccAlp (find-occs-of-letters *document3*))
(format t "--------------------------------------------------------------~%")


(defvar *encoded-doc* (encode-doc *document3*))
(format t "Encoded doc: ~a~%~%" *encoded-doc* )
(writeOccAlp (find-occs-of-letters *encoded-doc*))
(format t "--------------------------------------------------------------~%")


(defun Gen-Decoder-B-0 (paragraph)
  (lambda (paragraph) (decode-all paragraph))
)

(defun test (x)
  (lambda (x) (+ x 10)))

(format t "::~a~%"(decode-all *encoded-doc*))
(format t "ChipAlp: ~a~%"*chipAlph*)
;(let* ((myfunc (Gen-Decoder-B-0 *encoded-doc*)))
;  (format t "Test:~a~%" (funcall myfunc *encoded-doc*))
;  )

;(format t "t:~a~%" (is-matched '(e o) '(a n) '((0 (e a)(t r)(a e)(o n)(i s)(n i)))))


;(format t "Most Occs: ~a~%" (find-most-occs *prg*))
;(format t "RetVal of find-alphabet: ~a~%" (foo *prg* 0 *matches*))
