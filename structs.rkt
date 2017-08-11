#lang racket/base

(require ffi/unsafe
         ffi/cvector
         ffi/unsafe/cvector
         "types.rkt"
         "enums.rkt")

(provide (all-defined-out))

(define-cstruct _gpr-timespec
  ([tv_sec _int64]
   [tv_nsec _int]
   [clock_type _gpr-clock-type]))

(define-cstruct _grpc-slice
  ([refcount _pointer]))

(define-cstruct _grpc-metadata-array
  ([count _size_t]
   [capacity _size_t]
   [metadata _pointer]))

(define-cstruct _grpc-call-details
  ([method _grpc-slice]
   [host _grpc-slice]
   [deadline _gpr-timespec]
   [flags _uint]
   [reserved _pointer]))

(define-cstruct _grpc-completion-queue-attributes
  ([version _int]
   [cq_completion_type _grpc-cq-completion-type]
   [cq_polling_type _grpc-cq-polling-type]))
