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

(define-cstruct _grpc-event
  ([type _grpc-completion-type]
   [success _int]
   [reserved _pointer]))

(define-cstruct _grpc-maybe-compression-level
  ([is_set _uint8]
   [level _grpc-compression-level]))

(define-cstruct _grpc-slice-buffer
  ([base_slices _grpc-slice-pointer]
   [slices _grpc-slice-pointer]
   [count _size_t]
   [capacity _size_t]
   [length _size_t]
   [inlined _grpc-slice]))

(define-cstruct _grpc-send-initial-metadata
  ([count _size_t]
   [metadata _grpc-metadata-pointer]
   [maybe_compression_level _grpc-maybe-compression-level]))

(define-cstruct _reserved-struct
  ([reserved _pointer]))

(define-cstruct _raw
  ([compression _grpc-compression-algorithm]
   [slice_buffer _grpc-slice-buffer]))

(define-cstruct _grpc-byte-buffer
  ([reserved _pointer]
   [type _grpc-byte-buffer-type]
   [data (_union _reserved-struct
                 _raw)]))

(define-cstruct _grpc-send-message
  ([send_message _grpc-byte-buffer-pointer]))

(define-cstruct _grpc-op
  ([op _grpc-op-type]
   [flags _uint32]
   [reserved _pointer]
   [data (_union
          _reserved-struct
          _grpc-send-initial-metadata
          _grpc-send-message
          ;_grpc-send-status-from-server
          ;_grpc-recv-initial-metadata
          ;_grpc-recv-message
          ;_grpc-recv-status-on-client
          ;_grpc-close-on-server
          )]))
