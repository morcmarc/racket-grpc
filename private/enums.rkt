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

(define _grpc-op-type
  (_enum
   '(grpc-op-send-initial-metadata = 0
     grpc-op-send-message
     grpc-op-send-close-from-client
     grpc-op-send-status-from-server
     grpc-op-recv-initial-metadata
     grpc-op-recv-message
     grpc-op-recv-status-on-client
     gprc-op-recv-close-on-server)))

(define _grpc-compression-level
  (_enum
   '(grpc-compression-level-none = 0
     grpc-compression-level-low
     grpc-compression-level-med
     grpc-compression-level-high
     grpc-compression-level-count)))

(define _grpc-compression-algorithm
  (_enum
   '(_grpc-compress-none = 0
     _grpc-compress-deflate
     _grpc-compress-gzip
     _grpc-compress-algorithms-count)))

(define _grpc-byte-buffer-type
  (_enum
   '(_grpc-bb-raw)))

(define _grpc-call-error
  (_enum
   '(_grpc-call-ok
     _grpc-call-error
     _grpc-call-error-not-on-server
     _grpc-call-error-not-on-client
     _grpc-call-error-already-accepted
     _grpc-call-error-already-invoked
     _grpc-call-error-not-invoked
     _grpc-call-error-already-finished
     _grpc-call-error-too-many-operations
     _grpc-call-error-invalid-flags
     _grpc-call-error-invalid-metadata
     _grpc-call-error-invalid-message
     _grpc-call-error-not-server-completion-queue
     _grpc-call-error-batch-too-big
     _grpc-call-error-payload-type-mismatch)))
