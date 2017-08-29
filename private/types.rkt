#lang racket/base

(require ffi/unsafe)

(provide (all-defined-out))

(define _void-fn (_fun _pointer -> _void))
(define _size_t _int64)
(define _grpc-completion-queue-pointer _pointer)
(define _grpc-completion-queue-factory-pointer _pointer)
(define _grpc-alarm-pointer _pointer)
(define _grpc-channel-pointer _pointer)
(define _grpc-call-pointer _pointer)
(define _grpc-registered-call-handle-pointer _pointer)
(define _grpc-metadata-pointer _pointer)
(define _grpc-census-context-pointer _pointer)
(define _grpc-arg-pointer-vtable-pointer _pointer)
(define _grpc-server-pointer _pointer)
(define _grpc-resource-quota-pointer _pointer)
(define _reserved (_or-null _pointer))
(define _tag (_or-null _pointer))
