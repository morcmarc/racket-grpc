#lang racket/base

(require ffi/unsafe)

(provide (all-defined-out))

(define _gpr-clock-type
  (_enum
   '(gpr-clock-monotonic
     gpr-clock-realtime
     gpr-clock-precise
     gpr-timespan)))
