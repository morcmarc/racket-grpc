#lang racket/base

(require ffi/unsafe
         ffi/cvector
         ffi/unsafe/cvector
         "enums.rkt")

(provide (all-defined-out))

(define _size_t _int64)

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
