#lang racket/base

(require ffi/unsafe
         (except-in ffi/unsafe/define
                    define-ffi-definer)
         ffi-definer-convention
         "structs.rkt"
         "types.rkt"
         "enums.rkt")

(provide (all-defined-out))

(module+ test
  (require rackunit
           "malloc.rkt"))

(define lib-grpc (ffi-lib "libgrpc"))
(define-ffi-definer define-grpc lib-grpc
  #:make-c-id convention:hyphen->underscore)


#| generic functions |#

(define-grpc grpc-init
  (_fun -> _void))

(define-grpc grpc-shutdown
  (_fun -> _void))

(define-grpc grpc-register-plugin
  (_fun _void-fn _void-fn -> _void))

(module+ test
  (let ([init-fn (lambda () #f)]
        [destroy-fn (lambda () #f)])
    (test-not-exn
     "grpc-register-plugin doesn't throw"
     (lambda () (grpc-register-plugin init-fn destroy-fn)))))

(define-grpc grpc-version-string
  (_fun -> _string/utf-8))

(module+ test
  (check-equal? (grpc-version-string) "4.0.0"))


(define-grpc grpc-g-stands-for
  (_fun -> _string/utf-8))

(module+ test
  (check-equal? (grpc-g-stands-for) "gregarious"))


#| metadata array |#

(define-grpc grpc-metadata-array-init
  (_fun _grpc-metadata-array-pointer -> _void))

(define-grpc grpc-metadata-array-destroy
  (_fun _grpc-metadata-array-pointer -> _void))

(module+ test
  (test-not-exn
   "grpc-metadata-array-init doesn't throw"
   (lambda ()
     (call-with-malloc _pointer
                       grpc-metadata-array-init
                       #:cast _grpc-metadata-array-pointer)))
 (test-not-exn
  "grpc-metadata-array-destroy doesn't throw"
  (lambda ()
    (call-with-malloc _pointer
                      grpc-metadata-array-destroy
                      #:cast _grpc-metadata-array-pointer))))


#| call details |#

(define-grpc grpc-call-details-init
  (_fun _grpc-call-details-pointer -> _void))

(define-grpc grpc-call-details-destroy
  (_fun _grpc-call-details-pointer -> _void))

(module+ test
 (test-not-exn
  "grpc-call-details-init doesn't throw"
  (lambda ()
    (call-with-malloc _pointer
                      grpc-call-details-init
                      #:cast _grpc-call-details-pointer)))
 (test-not-exn
  "grpc-call-details-destroy doesn't throw"
  (lambda ()
    (call-with-malloc _pointer
                      grpc-call-details-destroy
                      #:cast _grpc-call-details-pointer))))


#| completion queue |#

(define-grpc grpc-completion-queue-factory-lookup
  (_fun _grpc-completion-queue-attributes-pointer -> _pointer))

(define-grpc grpc-completion-queue-create-for-next
  (_fun _reserved -> _grpc-completion-queue-pointer))

(define-grpc grpc-completion-queue-create-for-pluck
  (_fun _reserved -> _grpc-completion-queue-pointer))

(define-grpc grpc-completion-queue-create
  (_fun _grpc-completion-queue-factory-pointer
        _grpc-completion-queue-attributes-pointer
        _reserved
        -> _grpc-completion-queue-pointer))

(define-grpc grpc-completion-queue-next
  (_fun _grpc-completion-queue-pointer
        _gpr-timespec
        _reserved
        -> _grpc-event))

(define-grpc grpc-completion-queue-pluck
  (_fun _grpc-completion-queue-pointer
        _tag
        _gpr-timespec
        _reserved
        -> _grpc-event))

(define-grpc grpc-completion-queue-shutdown
  (_fun _grpc-completion-queue-pointer -> _void))

(define-grpc grpc-completion-queue-destroy
  (_fun _grpc-completion-queue-pointer -> _void))

(module+ test
  (test-not-exn
   "completion queue creation and shutdown"
   (λ ()
     (let* ([attributes (malloc-struct _grpc-completion-queue-attributes)]
            [_ (set-grpc-completion-queue-attributes-version! attributes 1)]
            [factory (grpc-completion-queue-factory-lookup attributes)]
            [cq (grpc-completion-queue-create factory attributes #f)])
       (grpc-completion-queue-shutdown cq)
       (grpc-completion-queue-destroy cq)
       (free attributes)))))


#| alarm |#

(define-grpc grpc-alarm-create
  (_fun _grpc-completion-queue-pointer
        _gpr-timespec
        _tag
        -> _grpc-alarm-pointer))

(define-grpc grpc-alarm-cancel
  (_fun _grpc-alarm-pointer -> _void))

(define-grpc grpc-alarm-destroy
  (_fun _grpc-alarm-pointer -> _void))


#| channels |#

(define-grpc grpc-channel-check-connectivity-state
  (_fun _grpc-channel-pointer _int -> _grpc-connectivity-state))

(define-grpc grpc-channel-num-external-connectivity-watchers
  (_fun _grpc-channel-pointer -> _int))

(define-grpc grpc-channel-watch-connectivity-state
  (_fun _grpc-channel-pointer
        _grpc-connectivity-state
        _gpr-timespec
        _grpc-completion-queue-pointer
        _tag
        -> _void))

(define-grpc grpc-channel-create-call
  (_fun _grpc-channel-pointer
        _grpc-call-pointer
        _uint
        _grpc-completion-queue-pointer
        _grpc-slice
        _grpc-slice-pointer
        _gpr-timespec
        _reserved
        -> _grpc-call-pointer))

(define-grpc grpc-channel-ping
  (_fun _grpc-channel-pointer
        _grpc-completion-queue-pointer
        _tag
        _reserved
        -> _void))

(define-grpc grpc-channel-register-call
  (_fun _grpc-channel-pointer
        _string/utf-8
        _string/utf-8
        _reserved
        -> _pointer))

(define-grpc grpc-channel-create-registered-call
  (_fun _grpc-channel-pointer
        _grpc-call-pointer
        _uint
        _grpc-completion-queue-pointer
        _grpc-registered-call-handle-pointer
        _gpr-timespec
        _reserved
        -> _grpc-call-pointer))

#| call functions |#

(define-grpc grpc-call-arena-alloc
  (_fun _grpc-call-pointer _size_t -> _pointer))

(define-grpc grpc-call-start-batch
  (_fun _grpc-call-pointer
        _grpc-op-pointer
        _size_t
        _tag
        _reserved
        -> _grpc-call-error))

(define-grpc grpc-call-get-peer
  (_fun _grpc-call-pointer -> _string/utf-8))


#| census functions |#

(define-grpc grpc-census-call-set-context
  (_fun _grpc-call-pointer _grpc-census-context-pointer -> _void))

(define-grpc grpc-census-call-get-context
  (_fun _grpc-call-pointer -> _grpc-census-context-pointer))

(define-grpc grpc-channel-get-target
  (_fun _grpc-channel-pointer -> _string/utf-8))

(define-grpc grpc-channel-get-info
  (_fun _grpc-channel-pointer _grpc-channel-info-pointer -> _void))

(define-grpc grpc-insecure-channel-create
  (_fun _string/utf-8
        _grpc-channel-args-pointer
        _reserved
        -> _grpc-channel-pointer))

(define-grpc grpc-lame-client-channel-create
  (_fun _string/utf-8
        _grpc-status-code
        _string/utf-8
        -> _grpc-channel-pointer))

(define-grpc grpc-channel-destroy
  (_fun _grpc-channel-pointer -> _void))

(define-grpc grpc-call-cancel
  (_fun _grpc-call-pointer _reserved -> _grpc-call-error))

(define-grpc grpc-call-cancel-with-status
  (_fun _grpc-call-pointer
        _grpc-status-code
        _string/utf-8
        _reserved
        -> _grpc-call-error))

(define-grpc grpc-call-ref
  (_fun _grpc-call-pointer -> _void))

(define-grpc grpc_call-unref
  (_fun _grpc-call-pointer -> _void))

(define-grpc grpc-server-request-call
  (_fun _grpc-server-pointer
        _grpc-call-pointer
        _grpc-call-details-pointer
        _grpc-metadata-array-pointer
        _grpc-completion-queue-pointer
        _grpc-completion-queue-pointer
        _pointer
        -> _grpc-call-error))

(define-grpc grpc-server-register-method
  (_fun _grpc-server-pointer
        _string/utf-8
        _string/utf-8
        _grpc-server-register-method-payload-handling
        _uint32
        -> _void))

(define-grpc grpc-server-request-registered-call
  (_fun _grpc-server-pointer
        _pointer
        _grpc-call-pointer
        _gpr-timespec-pointer
        _grpc-metadata-array-pointer
        _grpc-byte-buffer-pointer
        _grpc-completion-queue-pointer
        _grpc-completion-queue-pointer
        _pointer
        -> _grpc-call-error))

(define-grpc grpc-server-create
  (_fun _grpc-channel-args-pointer
        _reserved
        -> _grpc-server-pointer))

(define-grpc grpc-server-register-completion-queue
  (_fun _grpc-server-pointer
        _grpc-completion-queue-pointer
        _reserved
        -> _void))

(define-grpc grpc-server-add-insecure-http2-port
  (_fun _grpc-server-pointer _string/utf-8 -> _int))

(define-grpc grpc-server-start
  (_fun _grpc-server-pointer -> _void))

(define-grpc grpc-server-shutdown-and-notify
  (_fun _grpc-server-pointer
        _grpc-completion-queue-pointer
        _pointer
        -> _void))

(define-grpc grpc-server-cancel-all-calls
  (_fun _grpc-server-pointer -> _void))

(define-grpc grpc-server-destroy
  (_fun _grpc-server-pointer -> _void))

(define-grpc grpc-tracer-set-enabled
  (_fun _string/utf-8 _int -> _int))

(define-grpc grpc-header-key-is-legal
  (_fun _grpc-slice -> _int))

(define-grpc grpc-header-nonbin-value-is-legal
  (_fun _grpc-slice -> _int))

(define-grpc grpc-is-binary-header
  (_fun _grpc-slice -> _int))

(define-grpc grpc-call-error-to-string
  (_fun _grpc-call-error -> _string/utf-8))

(define-grpc grpc-resource-quota-create
  (_fun _string/utf-8 -> _grpc-resource-quota-pointer))

(define-grpc grpc-resource-quota-ref
  (_fun _grpc-resource-quota-pointer -> _void))

(define-grpc grpc-resource-quota-unref
  (_fun _grpc-resource-quota-pointer -> _void))

(define-grpc grpc-resource-quota-resize
  (_fun _grpc-resource-quota-pointer _size_t -> _void))

(define-grpc grpc-resource-quota-arg-vtable
  (_fun -> _grpc-arg-pointer-vtable-pointer))
