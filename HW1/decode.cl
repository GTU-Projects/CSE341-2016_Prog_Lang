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
(defun spell-checker-0 (word)
  ; return t if word exist in file, otherwise nil
	(dolist (item *dictionary*)
			(write item)
			(if (equal item word)
				(return t)
				())
	)
)

(defun spell-checker-1 (word)
  ; this function checks the word is in file
  ; uses binary search

  
  
)


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

(format t "~a" (spell-checker-1 '(h e l l o)))


