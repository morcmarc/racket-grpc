#lang racket/base

(require "private/bindings.rkt"
         "private/structs.rkt"
         "private/malloc.rkt")

(provide start)

(define (start config)
  (let* ([args (malloc-struct _grpc-channel-args)]
         [server (grpc-server-create args #f)])
    (grpc-server-start server)))
