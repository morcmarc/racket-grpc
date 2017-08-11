#lang racket/base

(require ffi/unsafe)

(provide (all-defined-out))

(define _void-fn (_fun _pointer -> _void))
(define _size_t _int64)
