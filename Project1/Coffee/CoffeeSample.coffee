(deffun sumup (x)
  (if (equal x 0)
  then 1
  else (+ x (sumup (- x 1)))
  ))
(sumup 8)