#lang racket/base

(require ffi/unsafe)

(provide (all-defined-out))

(define _gpr-clock-type
  (_enum
   '(gpr-clock-monotonic = 0
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

(define _grpc-connectivity-state
  (_enum
   '(grpc-channel-init = -1
     grpc-channel-idle
     grpc-channel-connecting
     grpc-channel-ready
     grpc-channel-transient-failure
     grpc-channel-shutdown)))
