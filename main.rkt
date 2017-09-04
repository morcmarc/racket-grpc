#lang racket/base

(require "private/bindings.rkt"
         "server.rkt")

(grpc-init)

(start #f)
