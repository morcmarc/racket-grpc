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

(module+ test
  (test-not-exn
   "grpc-completion-queue-factory-lookup doesn't throw"
   (lambda ()
     (let ([attributes (malloc-struct _grpc-completion-queue-attributes)])
       (set-grpc-completion-queue-attributes-version! attributes 1)
       (grpc-completion-queue-factory-lookup attributes)
       (free attributes)))))

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


  ;
  ;GRPCAPI void   grpc_channel_destroy (grpc_channel *channel)
  ;   Close and destroy a grpc channel. More...
  ;
  ;GRPCAPI grpc_call_error   grpc_call_cancel (grpc_call *call, void *reserved)
  ;   Error handling for grpc_call Most grpc_call functions return a grpc_error. More...
  ;
  ;GRPCAPI grpc_call_error   grpc_call_cancel_with_status (grpc_call *call, grpc_status_code status, const char *description, void *reserved)
  ;   Called by clients to cancel an RPC on the server. More...
  ;
  ;GRPCAPI void   grpc_call_ref (grpc_call *call)
  ;   Ref a call. More...
  ;
  ;GRPCAPI void   grpc_call_unref (grpc_call *call)
  ;   Unref a call. More...
  ;
  ;GRPCAPI grpc_call_error   grpc_server_request_call (grpc_server *server, grpc_call **call, grpc_call_details *details, grpc_metadata_array *request_metadata, grpc_completion_queue *cq_bound_to_call, grpc_completion_queue *cq_for_notification, void *tag_new)
  ;   Request notification of a new call. More...
  ;
  ;GRPCAPI void *   grpc_server_register_method (grpc_server *server, const char *method, const char *host, grpc_server_register_method_payload_handling payload_handling, uint32_t flags)
  ;   Registers a method in the server. More...
  ;
  ;GRPCAPI grpc_call_error   grpc_server_request_registered_call (grpc_server *server, void *registered_method, grpc_call **call, gpr_timespec *deadline, grpc_metadata_array *request_metadata, grpc_byte_buffer **optional_payload, grpc_completion_queue *cq_bound_to_call, grpc_completion_queue *cq_for_notification, void *tag_new)
  ;   Request notification of a new pre-registered call. More...
  ;
  ;GRPCAPI grpc_server *   grpc_server_create (const grpc_channel_args *args, void *reserved)
  ;   Create a server. More...
  ;
  ;GRPCAPI void   grpc_server_register_completion_queue (grpc_server *server, grpc_completion_queue *cq, void *reserved)
  ;   Register a completion queue with the server. More...
  ;
  ;GRPCAPI int   grpc_server_add_insecure_http2_port (grpc_server *server, const char *addr)
  ;   Add a HTTP2 over plaintext over tcp listener. More...
  ;
  ;GRPCAPI void   grpc_server_start (grpc_server *server)
  ;   Start a server - tells all listeners to start listening. More...
  ;
  ;GRPCAPI void   grpc_server_shutdown_and_notify (grpc_server *server, grpc_completion_queue *cq, void *tag)
  ;   Begin shutting down a server. More...
  ;
  ;GRPCAPI void   grpc_server_cancel_all_calls (grpc_server *server)
  ;   Cancel all in-progress calls. More...
  ;
  ;GRPCAPI void   grpc_server_destroy (grpc_server *server)
  ;   Destroy a server. More...
  ;
  ;GRPCAPI int   grpc_tracer_set_enabled (const char *name, int enabled)
  ;   Enable or disable a tracer. More...
  ;
  ;GRPCAPI int   grpc_header_key_is_legal (grpc_slice slice)
  ;   Check whether a metadata key is legal (will be accepted by core) More...
  ;
  ;GRPCAPI int   grpc_header_nonbin_value_is_legal (grpc_slice slice)
  ;   Check whether a non-binary metadata value is legal (will be accepted by core) More...
  ;
  ;GRPCAPI int   grpc_is_binary_header (grpc_slice slice)
  ;   Check whether a metadata key corresponds to a binary value. More...
  ;
  ;GRPCAPI const char *   grpc_call_error_to_string (grpc_call_error error)
  ;   Convert grpc_call_error values to a string. More...
  ;
  ;GRPCAPI grpc_resource_quota *   grpc_resource_quota_create (const char *trace_name)
  ;   Create a buffer pool. More...
  ;
  ;GRPCAPI void   grpc_resource_quota_ref (grpc_resource_quota *resource_quota)
  ;   Add a reference to a buffer pool. More...
  ;
  ;GRPCAPI void   grpc_resource_quota_unref (grpc_resource_quota *resource_quota)
  ;   Drop a reference to a buffer pool. More...
  ;
  ;GRPCAPI void   grpc_resource_quota_resize (grpc_resource_quota *resource_quota, size_t new_size)
  ;   Update the size of a buffer pool. More...
  ;
  ;GRPCAPI const
  ;grpc_arg_pointer_vtable *   grpc_resource_quota_arg_vtable (void)
  ;   Fetch a vtable for a grpc_channel_arg that points to a grpc_resource_quota. More...)
