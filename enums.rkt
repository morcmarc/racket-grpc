#lang racket/base

(require ffi/unsafe)

(provide (all-defined-out))

(define _gpr-clock-type
  (_enum
   '(gpr-clock-monotonic
     gpr-clock-realtime
     gpr-clock-precise
     gpr-timespan)))

(define _grpc-cq-completion-type
  (_enum
   '(grpc-cq-next
     grpc-cq-pluck)))

(define _grpc-cq-polling-type
  (_enum
   '(grpc-cq-default-polling
     grpc-cq-non-listening
     grpc-cq-non-polling)))

(define _grpc-completion-type
  (_enum
   '(grpc-queue-shutdown
     grpc-queue-timeout
     grpc-op-complete)))
