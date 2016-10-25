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

(defun Gen-Decoder-A (paragraph)
  ;you should implement this function
)

(defun Gen-Decoder-B-0 (paragraph)
  ;you should implement this function
)

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

(defun find-most-occs (document)
  (let* ((arr (make-array 26 :initial-element 0)))
    (loop for paragraph in document do
      ;(format t "prg:~a~%" paragraph)
      (loop for item in paragraph do
        ;(format t "item:~a~%" item)
        (loop for ch in item do
          ;(format t "ch:~a~%" ch)
          (setf (aref arr (c2i ch)) (1+ (aref arr (c2i ch))))
)) ; return result array
    )
    arr))


(defun foo (paragraph searchIndex matches)
  ;(format t "Debug::~%~tP:~a ~%~tSI:~a ~%~tM:~a~%" paragraph searchIndex matches);
  (if (null paragraph) (return-from foo nil))

  (let* ((newMatches (find-matches (first paragraph) searchIndex matches))(result nil)(foundIndex nil))
    ;(format t "findMatches: ~a~%" (first paragraph))
    (if (null newMatches) (return-from foo -1)); eslesme yoksa -1 yolla
    ;(format t "Debug2:: newMatches: ~a~%" newMatches)
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
  (let* ((arr (make-array 26 :initial-element 0)))
    (loop for item in l do
      (loop for i in item do
        ;(format t "i:~a~%" i)
        (if (numberp i) ()
          (setf (aref arr (c2i (second i))) (first i)))
        ))arr))


(defun decode-all (doc)
  ;(let* ((allDoc nil)(matches '((0 (a e)(r t)(e a)(n o)(s i)(i n)))))
  (let* ((allDoc nil)(matches '((0 (e a)(t r)(a e)(o n)(i s)(n i)))))
    (loop for i in doc do
      (setf allDoc (append allDoc i))
      )
      (format t "allDoc:~a~%" allDoc)
      (format t "Res: ~a~%" (foo allDoc 0 matches))
      (format t"alph:   ~a~%" (list2alph (foo allDoc 0 matches)))
    )
  )


(defun writeOccAlp (arr)
  (format t "Char occurences: ")
  (loop for i from 0 to 25 do
    (format t "~a - ~a, " (i2c i) (aref arr i))
    )
  (terpri)
  )

(defparameter *alphabet* '(a b c d e f g h i j k l m n o p q r s t u v w x y z))
(defvar *chipAlph* (encode-word *alphabet*))

(format t "Alph:    ~a~%" *alphabet*)
(format t "ChipAlp: ~a~%"*chipAlph*)

(format t "Plain doc: ~a~%" *document*)
(writeOccAlp (find-most-occs *document*))

(defvar *encoded-doc* (encode-doc *document*))
(format t "Encoded doc: ~a~%" *encoded-doc* )

(let* ((r (find-most-occs *encoded-doc*)))
  (writeOccAlp r)
  )

(decode-all *encoded-doc*)

(format t "ChipAlp: ~a~%"*chipAlph*)

;(format t "t:~a~%" (is-matched '(e o) '(a n) '((0 (e a)(t r)(a e)(o n)(i s)(n i)))))


;(format t "Most Occs: ~a~%" (find-most-occs *prg*))
;(format t "RetVal of find-alphabet: ~a~%" (foo *prg* 0 *matches*))
