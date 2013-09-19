;;; -*- syntax: Lisp; font-size: 16; theme: "Emacs"; -*-

;Live Coding Session 1
; 9/18/2013
; Jan Freymann

(ports)
(send "mp:open" :out 2)
(metro 120)

(define (hits) (process
  (send "mp:on" 0.05 5)
  (send "mp:ctrl" 0 11 (between 30 110))
 (wait (metro-dur 0.5))
))

(sprout (hits) (sync) 3)

(define (kicks) (process
  (send "mp:on" 0 3)
  (send "mp:ctrl" 0 9 (between 20 80))
  (wait (metro-dur 2))
))

(sprout (kicks) (sync) 1)
(send "mp:ctrl" 0 9 20)

(define (backing) (process
  (send "mp:ctrl" 0 3 0)
  (wait -1)
))

(sprout (backing) (sync) 4)

(define (snares) (process
  (send "mp:on" 0.5 4)
  (send "mp:on" 1.5 4)
  (wait (metro-dur 4))
))

(sprout (snares) (sync) 2)
(stop 2)

(define (modulator) (process
  (loop for delay from 1 to 8
  do
  (send "mp:ctrl" (metro-dur delay) 7 (random 128))
  (send "mp:ctrl" (metro-dur delay) 8 (+ 20 (* delay 6)))
  )
  (wait (metro-dur 8))
))

(sprout (modulator) (sync) 17)

(define (modulator2) (process
  (loop for delay from 1 to 8
  do
  (send "mp:ctrl" (* 2 (metro-dur delay)) 12 (between 2 10))
  )
  (wait (metro-dur 16))
))

(sprout (modulator2) (sync) 18)

(send "mp:ctrl" 0 13 120)


(stop)

(send "mp:ctrl" 0 13 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







