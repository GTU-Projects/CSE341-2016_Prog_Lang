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

(defvar debugMode t) ; is debug open or close
;; -----------------------------------------------------
;; HELPERS
;; *** PLACE YOUR HELPER FUNCTIONS BELOW ***


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


; this function works recursively, takes paragrah and sequentially match words with
; plain word which in dictionary
; searchIndex : index of dictionary to search point
; matches : matched words, need to block invalid or double matches
; returs all letters
(defun rec-matcher (paragraph searchIndex matches)
  (format debugMode "rec-Matcher params::~tPrg:~a ~%~tSearchIndex:~a ~%~tMatches:~a~%" paragraph searchIndex matches);
  (if (null paragraph) (return-from rec-matcher nil)) ; base case

  (let* ((newMatches (find-matches (first paragraph) searchIndex matches))(result nil)(foundIndex nil))
    (format debugMode "findMatches for: ~a~%" (first paragraph))
    (if (null newMatches) (return-from rec-matcher -1));if not match return -1
    (format debugMode "newMatches: ~a~%" newMatches)
    (setf matches (append (list newMatches) matches)) ;add new matches to head

    (setf result (rec-matcher (rest paragraph) 0 matches)) ;rec. call to next item
    (if (equal result -1) ;if there is no matches
        (progn ;change searchIndex and continue
          (setf foundIndex (1+ (first(first matches))))
         (setf matches (rest matches)) ;delete previous match
               (return-from rec-matcher (rec-matcher paragraph foundIndex matches))) ; yeniden cagir
        )
    (if (null result) ; if paragraph ends
      matches ; return matched words
      result) ;return results for rec. calls
    )
  )

; takes an special list and specifies which letters matched.
; after specifing, makes an array and return match array
; sample (S L)(A E)(P D) is input
; add s to array element which index is l, and add others
(defun list2alph (l)
  (format debugMode "list2Alph l:~a~%" l)
  (if (null l) (return-from list2alph nil))
  (let* ((arr (make-array 26 :initial-element 0)))
    (loop for item in l do
      (loop for i in item do
        ;(format t "i:~a~%" i)
        (if (numberp i) ()
          (setf (aref arr (c2i (second i))) (first i)))
        ))arr))

; this function takes and list and finds most 6 occurances
; then adds their equvalent(acccording to pdf , e t a o i n)
; sample return val : ((a e)(m t)(e a)(y o)(n i)(o n))
; sample : change a with e , m with t to find decoded doc
(defun get-most-6-occ (l)
  (let* ((mostArr (find-occs-of-letters l))(mostList nil)(max -1)(index -1)(resList nil))
    (loop for j from 1 to 6 do
      (loop for i from 0 to 25 do
        (if (member i mostList)
          () ;do not add if added before
          (progn
           (if (> (aref mostArr i) max)
             (progn
                    (setf max (aref mostArr i))
                    (setf index i))
             )))
        )
        (setf mostList (append mostList (list index)))
        (setf max -1)
      )
    ; add six element to list and return it
    (setf resList (append resList (list (list (i2c (first mostList)) 'e))))
    (setf resList (append resList (list (list (i2c (second mostList)) 't))))
    (setf resList (append resList (list (list (i2c (third mostList)) 'a))))
    (setf resList (append resList (list (list (i2c (fourth mostList)) 'o))))
    (setf resList (append resList (list (list (i2c (fifth mostList)) 'i))))
    (setf resList (append resList (list (list (i2c (sixth mostList)) 'n))))
    resList
    )
)

(defun find-in-arr (arr ch)
  (loop for i from 0 to 25 do
    (if (equalp (aref arr i) ch) (progn (format t "eq: ~a ~a ~a  ~%" i ch (aref arr i))(return-from find-in-arr i)) () )
    )
    nil
  )

(defun decode-word (word cipherAlph plainAlph)
  (format t "::: w:~a c:~a p:~a~%" word cipherAlph plainAlph)

	(if (null word) ()
		(append (list (nth (find-in-arr cipherAlph (first word)) plainAlph )) (decode-word (cdr word) cipherAlph plainAlph))
	))

(defun apply-uncipher (doc cipherAlph)
  (loop for parag in doc do
    (loop for word in parag do
      (format t "--" (decode-word word cipherAlph '(a b c d e f g h i j k l m n o p q r s t u v w x y z)))
      )
    )

  )

; this function takes an document then converts it to single paragraph
; after that calls actual decode function
; returns decoded document
(defun decode-all (doc)
  (let* ((allDocAsPrg nil)(matches nil)(cipherAlph nil))
    (loop for i in doc do
      (setf allDocAsPrg (append allDocAsPrg i)));convert all doc to paragraph
      (setf matches (cons 0 (get-most-6-occ doc))) ;find first 6 matches accorting to pdf
      (format debugMode "allDocAsPrg:~a~%" allDocAsPrg); test for new paragraph
      (format debugMode "6matches: ~a~%" matches) ; test for matches
      (format debugMode "Res: ~a~%" (rec-matcher allDocAsPrg 0 (list matches)))
      ;(format t "alph:   ~a~%" (list2alph (rec-matcher allDocAsPrg 0 (list matches))))
      (setf cipherAlph (list2alph (rec-matcher allDocAsPrg 0 (list matches))))
      ;(format t "CipherAlph:~a~%" cipherAlph)

      (apply-uncipher doc cipherAlph)
    )
  )


; Prints number of occurances per letter to control
(defun writeOccAlp (arr)
  (format t "Char occurences: ")
  (loop for i from 0 to 25 do
    (format t "(~a, ~a), " (i2c i) (aref arr i))
    )
  (terpri)
)

;; -----------------------------------------------------
;; DECODE FUNCTIONS
(defun Gen-Decoder-B-0 (paragraph)
  (lambda (paragraph) (decode-all paragraph))
)

(defun Gen-Decoder-B-1 (paragraph)
  ;you should implement this function
)

(defun Code-Breaker (document decoder)
  (funcall (funcall decoder document) document)
)


(defun my-test ()
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
)

(my-test)




(format debugMode "FoundChip:~a~%" (Code-Breaker *encoded-doc* 'Gen-Decoder-B-0) )
;(format t "::~a~%" (funcall (Gen-Decoder-B-0 *encoded-doc*) *encoded-doc*))
;(format t "::~a~%" (decode-all *encoded-doc*) )

;(let* ((myfunc (Gen-Decoder-B-0 *encoded-doc*)))
;  (format t "Test:~a~%" (funcall myfunc *encoded-doc*))
;  )

;(format t "t:~a~%" (is-matched '(e o) '(a n) '((0 (e a)(t r)(a e)(o n)(i s)(n i)))))
