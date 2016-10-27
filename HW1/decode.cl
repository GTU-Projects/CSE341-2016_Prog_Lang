; *********************************************
; *  341  Programming Languages               *
; *  Fall 2016                                *
; *  Author: Liu Liu                          *
; *          Ulrich Kremer                    *
; *          Furkan Tektas , clisp            *
; *          Hasan Men -- 131044009           *
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

(defvar debugMode nil) ; is debug open or close
(defvar debugMode2 nil)
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
      (if (equal (second item) (second word)) ;ikinci karakterleride esitmi
            (return-from isUsedInList '(* *))()) ;var ise hatali return et
      ))

  (loop for item in newslyMatched do
    (if (equal (first item) (first word)) ;sifreli eleman listede varmi
          (return-from isUsedInList item)())
    (if (equal (second item) (second word)) ;ikinci karakterleride esitmi
          (return-from isUsedInList '(* *))()); var ise hatali return et
    )
    nil)

; sifreli kelime ile verilen kelimeyi esletrimeye calisir
; eger daha onceden farklı karakter ile eslesen karakter varsa nil dondurur
; eslesmeyen yeni karakterleri liste olarak return eder
(defun is-matched (chiperWord plainWord matchedWords)
  (if (equal (length chiperWord) (length plainWord))()(return-from is-matched nil))

  (let* ((newMatches '())) ; create empty list, nil
    (loop for chipCh in chiperWord
      for plainCh in plainWord do
      (format debugMode "chipperWord: ~a, plainWord:~a, matchedWords : ~a~%" chiperWord plainWord matchedWords)
      (let ((result (isUsedInList (list chipCh plainCh) matchedWords newMatches) ))
        (format debugMode "rest:~a~%" result)
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
  (format debugMode "getMatchedParts params -> word: ~a, matchedWords: ~a ~%" word matchedWords)
  (let* ((listLength (length *dictionary*)))
    ;(format t "Dictionary length: ~a~%" listLength)
    (loop ; sozluk boyutu kadar donecek
      (format debugMode "str:~a~%" (nth startIndex *dictionary*))
      (let* ((matchRes (is-matched word (nth startIndex *dictionary*) matchedWords)))
        (format debugMode "~a. word: ~a, nth: ~a, matchRes : ~a~%" startIndex word (nth startIndex *dictionary* ) matchRes)
        (cond
          ((null matchRes) (setf startIndex (1+ startIndex)))
          (t (return-from find-matches (cons startIndex matchRes)) )
          )
        )
      (when (equal startIndex listLength) (return-from find-matches nil))
      )
    )
    )

; dokuman icin karakterlerin sıklık oranını bulur ve array olarak return eder
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
    (format debugMode "newMatches: ~a~%" newMatches)
    (if (null newMatches) (return-from rec-matcher -1));if not match return -1
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

; array icin eleman arar, var ise indexi yok ise nil return eder
(defun find-in-arr (arr ch)
  (loop for i from 0 to 25 do
    (if (equalp (aref arr i) ch) (return-from find-in-arr i) () )
    )
    nil
  )

;apply-uncipher ile birlikte kullanilir
;alfabelerden yararlanarak kelime üzerinde degistirmeler yapar ve return eder
;sifreli kelimeyi plain kelimeye cevir
(defun decode-word (word cipherAlph plainAlph)
	(if (null word) ()
		(let* ((index (find-in-arr cipherAlph (first word))))
    ; kelimeleyi recursive olarak coz
      (if (null index) (append '(*) (decode-word (cdr word) cipherAlph plainAlph))
          (append (list (nth index plainAlph )) (decode-word (cdr word) cipherAlph plainAlph))
        ))))

; sifreli dokuman uzerinde alfabeyi kullanarak plain texti bulur vve return eder
(defun apply-uncipher (doc cipherAlph)
  (let* ((newDoc nil)(alphabet '(a b c d e f g h i j k l m n o p q r s t u v w x y z)))
    (loop for parag in doc do
      (let* ((newParag nil))
        (loop for word in parag do
          (setf newParag (append newParag (list(decode-word word cipherAlph alphabet))))
          )
        (setf newDoc (append newDoc (list newParag)))
      )
    )
    newDoc
  )
)

; Bir dokuman alarak hepsini bir paragraf haline getirir ve sifre cozmaya baslar
; cozulen sifreyi return eder
(defun decode-all (doc)
  (let* ((allDocAsPrg nil)(matches nil)(cipherAlph nil)(plainText nil)); degiskenler
    (loop for i in doc do
      (setf allDocAsPrg (append allDocAsPrg i)));dokumani paragraf yap

      (setf matches (cons 0 (get-most-6-occ doc))); en cok tekrar eden 6 karakteri bul
      (format debugMode "allDocAsPrg:~a~%" allDocAsPrg); test icin bast
      (format debugMode "6matches: ~a~%" matches); test icin bas
      (format debugMode "~%~%-----------------------------------~%")

      ; recursive olarak kelimelere es deger kelime bul
      ;bulunan kelimelerden sifre alfabesini bul
      (setf cipherAlph (list2alph (rec-matcher allDocAsPrg 0 (list matches))))
      ;(format debugMode2 "NormalAlph: ~a~%" *alphabet*)
      ;(format debugMode2 "CipherAlph:~a~%" cipherAlph)
      ;(format debugMode2 "alp2:       ~a~%" *chipAlph*)

      ;alfabe ile metni coz
      (setf plainText (apply-uncipher doc cipherAlph))
    plainText
    )
  )


; dizi icindeki sayilarin karakter karsiligini basar
; tekrar numaralarinin aitliklerini basmak ici test fonsiyonumda calisir
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

;;;;;;;;; TEST ICIN CALISTIRABILIRSINIZ ;;;;;;;;;;;;;;;;;;;;;;;;;;
(format t "Found Plain Text:~a~%" (Code-Breaker *document* 'Gen-Decoder-B-0) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1-2 tane ufak test metodunu icerir ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-test ()
  (defparameter *alphabet* '(a b c d e f g h i j k l m n o p q r s t u v w x y z))
  (defparameter *chipAlph* '(E D F P A Q B K N C R S J O Y Z H T I M L G U V W X))
  (defparameter *my-test-doc* '(
                    ((a )(j u l y)(j u n e)(o )(o )(h e r)(a e o)(t h i s)(c o u r s e)(i t s)(c o v e r s)(t o p i c s)(i n)(l a n g u a g e )(a d d)(c o m p i l e r s))
                    ((o )(t h i s)(a t t r i b u t e)(t h i n g)(g r a m m a r s)(a n d)(t h e i r)(u s e)(i n)(s y n t a x)(d i r e c t e d)(t r a n s l a t i o n))
                    ((a n)(o n)(t h o u g h)(m o d e l )(o f)(p r o g r a m m i n g)(l a n g u a g e)(s e m a n t i c s))
                    ((t h e s e)(i n t e r m e d i a t e)(r e p r e s e n t a t i o n)(o f)(a t)(o k)(m o d e l))
                    ))
  (defparameter *dictionary* '(
            (e)(a)(i)(o)(i s)(a m)(a n)(a t)(i n)(o n)(m y)(a s)(h i s)(t h e)
            (h e r)(a n d)(a d d)(a r e)(n a m e)(j u n e)(j u l y)(a t o m)
            (t h i s)(t h a t)(a k a y)(n a n a)(h a s a n)(h e l l o)(t o p i c s)
            (c o u r s e)(c o v e r s)(p r o g r a m m i n g)(l a n g u a g e s)
            (a n d) (c o m p i l e r s)
            (a )(o )(o )(h e r)(a e o)(t h i s)(c o u r s e)(i t s)(c o v e r s)(t o p i c s)(i n)(l a n g u a g e )(a d d)(c o m p i l e r s)
            (o )(t h i s)(a t t r i b u t e)(t h i n g)(g r a m m a r s)(a n d)(t h e i r)(u s e)(i n)(s y n t a x)(d i r e c t e d)(t r a n s l a t i o n)
            (a n)(o n)(t h o u g h)(m o d e l )(o f)(p r o g r a m m i n g)(l a n g u a g e)(s e m a n t i c s)
            (t h e s e)(i n t e r m e d i a t e)(r e p r e s e n t a t i o n)(o f)(a t)(o k)(m o d e l)
            ))
  (format t "Alph:    ~a~%" *alphabet*)
  (format t "ChipAlp: ~a~%"*chipAlph*)
  (format t "--------------------------------------------------------------~%")

  (format t "Plain doc: ~a~%~%" *my-test-doc*)
  (writeOccAlp (find-occs-of-letters *my-test-doc*))
  (format t "--------------------------------------------------------------~%")

  (defvar *encoded-doc* (encode-doc *my-test-doc*))
  (format t "Encoded doc: ~a~%~%" *encoded-doc* )
  (writeOccAlp (find-occs-of-letters *encoded-doc*))
  (format t "--------------------------------------------------------------~%")
  (format t "Found Plain Text:~a~%" (Code-Breaker *my-test-doc* 'Gen-Decoder-B-0) )
)

;(my-test)
