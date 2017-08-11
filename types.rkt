#lang racket/base

(require ffi/unsafe)

(provide (all-defined-out))

(define _void-fn (_fun _pointer -> _void))
(define _size_t _int64)
(define _grpc-completion-queue-pointer _pointer)
(define _grpc-completion-queue-factory-pointer _pointer)
(define _reserved (_or-null _pointer))
(define _tag (_or-null _pointer))
