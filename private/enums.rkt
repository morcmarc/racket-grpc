#lang racket/base

(require ffi/unsafe)

(provide (all-defined-out))

(define _gpr-clock-type
  (_enum
   '(monotonic = 0
     realtime
     precise
     gpr-timespan)))

(define _grpc-cq-completion-type
  (_enum '(next pluck)))

(define _grpc-cq-polling-type
  (_enum '(default-polling non-listening non-polling)))

(define _grpc-completion-type
  (_enum '(queue-shutdown queue-timeout op-complete)))

(define _grpc-connectivity-state
  (_enum
   '(init = -1
     idle
     connecting
     ready
     transient-failure
     shutdown)))

(define _grpc-op-type
  (_enum
   '(send-initial-metadata = 0
     send-message
     send-close-from-client
     send-status-from-server
     recv-initial-metadata
     recv-message
     recv-status-on-client
     recv-close-on-server)))

(define _grpc-compression-level
  (_enum
   '(none = 0
     low
     med
     high
     count)))

(define _grpc-compression-algorithm
  (_enum
   '(none = 0
     deflate
     gzip
     algorithms-count)))

(define _grpc-byte-buffer-type
  (_enum '(raw)))

(define _grpc-call-error
  (_enum
   '(ok
     error
     not-on-server
     not-on-client
     already-accepted
     already-invoked
     not-invoked
     already-finished
     too-many-operations
     invalid-flags
     invalid-metadata
     invalid-message
     not-server-completion-queue
     batch-too-big
     payload-type-mismatch)))

(define _grpc-arg-type
  (_enum '(string integer pointer)))

(define _grpc-status-code
  (_enum
   '(do-not-use = -1
     ok = 0
     cancelled = 1
     unknown = 2
     invalid-argument = 3
     deadline-exceeded = 4
     not-found = 5
     already-exists = 6
     permission-denied = 7
     unauthenticated = 16
     resource-exhausted = 8
     failed-precondition = 9
     aborted = 10
     out-of-range = 11
     unimplemented = 12
     internal = 13
     unavailable = 14
     data-loss = 15)))
