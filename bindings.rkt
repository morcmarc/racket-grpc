#lang racket/base

(require ffi/unsafe
         "structs.rkt")

(provide (all-defined-out))

(module+ test
         (require rackunit
                  "malloc.rkt"))

(define lib-grpc (ffi-lib "libgrpc"))

(define grpc-init
  (get-ffi-obj "grpc_init" lib-grpc (_fun -> _void)))

(define grpc-shutdown
  (get-ffi-obj "grpc_shutdown" lib-grpc (_fun -> _void)))

(define grpc-metadata-array-init
  (get-ffi-obj "grpc_metadata_array_init" lib-grpc (_fun _grpc-metadata-array-pointer -> _void)))

(define grpc-metadata-array-destroy
  (get-ffi-obj "grpc_metadata_array_destroy" lib-grpc (_fun _grpc-metadata-array-pointer -> _void)))

(module+ test
 (test-not-exn
  "grpc-metadata-array-init doesn't throw"
  (lambda () (call-with-malloc _pointer grpc-metadata-array-init #:cast _grpc-metadata-array-pointer)))
 (test-not-exn
  "grpc-metadata-array-destroy doesn't throw"
  (lambda () (call-with-malloc _pointer grpc-metadata-array-destroy #:cast _grpc-metadata-array-pointer))))


(define grpc-call-details-init
  (get-ffi-obj "grpc_call_details_init" lib-grpc (_fun _grpc-call-details-pointer -> _void)))

(define grpc-call-details-destroy
  (get-ffi-obj "grpc_call_details_destroy" lib-grpc (_fun _grpc-call-details-pointer -> _void)))

(module+ test
 (test-not-exn
  "grpc-call-details-init doesn't throw"
  (lambda () (call-with-malloc _pointer grpc-call-details-init #:cast _grpc-call-details-pointer)))
 (test-not-exn
  "grpc-call-details-destroy doesn't throw"
  (lambda () (call-with-malloc _pointer grpc-call-details-destroy #:cast _grpc-call-details-pointer))))


(define grpc-register-plugin
  (get-ffi-obj "grpc_register_plugin" lib-grpc (_fun (_fun _pointer -> _void) (_fun _pointer -> _void) -> _void)))

(module+ test
         (let ([init-fn (lambda () #f)]
               [destroy-fn (lambda () #f)])
           (test-not-exn "grpc-register-plugin doesn't throw" (lambda () (grpc-register-plugin init-fn destroy-fn)))))


  ;
  ;GRPCAPI const char *   grpc_version_string (void)
  ;   Return a string representing the current version of grpc. More...
  ;
  ;GRPCAPI const char *   grpc_g_stands_for (void)
  ;   Return a string specifying what the 'g' in gRPC stands for. More...
  ;
  ;GRPCAPI const
  ;grpc_completion_queue_factory *   grpc_completion_queue_factory_lookup (const grpc_completion_queue_attributes *attributes)
  ;   Returns the completion queue factory based on the attributes. More...
  ;
  ;GRPCAPI grpc_completion_queue *   grpc_completion_queue_create_for_next (void *reserved)
  ;   Helper function to create a completion queue with grpc_cq_completion_type of GRPC_CQ_NEXT and grpc_cq_polling_type of GRPC_CQ_DEFAULT_POLLING. More...
  ;
  ;GRPCAPI grpc_completion_queue *   grpc_completion_queue_create_for_pluck (void *reserved)
  ;   Helper function to create a completion queue with grpc_cq_completion_type of GRPC_CQ_PLUCK and grpc_cq_polling_type of GRPC_CQ_DEFAULT_POLLING. More...
  ;
  ;GRPCAPI grpc_completion_queue *   grpc_completion_queue_create (const grpc_completion_queue_factory *factory, const grpc_completion_queue_attributes *attributes, void *reserved)
  ;   Create a completion queue. More...
  ;
  ;GRPCAPI grpc_event   grpc_completion_queue_next (grpc_completion_queue *cq, gpr_timespec deadline, void *reserved)
  ;   Blocks until an event is available, the completion queue is being shut down, or deadline is reached. More...
  ;
  ;GRPCAPI grpc_event   grpc_completion_queue_pluck (grpc_completion_queue *cq, void *tag, gpr_timespec deadline, void *reserved)
  ;   Blocks until an event with tag 'tag' is available, the completion queue is being shutdown or deadline is reached. More...
  ;
  ;GRPCAPI void   grpc_completion_queue_shutdown (grpc_completion_queue *cq)
  ;   Begin destruction of a completion queue. More...
  ;
  ;GRPCAPI void   grpc_completion_queue_destroy (grpc_completion_queue *cq)
  ;   Destroy a completion queue. More...
  ;
  ;GRPCAPI grpc_alarm *   grpc_alarm_create (grpc_completion_queue *cq, gpr_timespec deadline, void *tag)
  ;   Create a completion queue alarm instance associated to cq. More...
  ;
  ;GRPCAPI void   grpc_alarm_cancel (grpc_alarm *alarm)
  ;   Cancel a completion queue alarm. More...
  ;
  ;GRPCAPI void   grpc_alarm_destroy (grpc_alarm *alarm)
  ;   Destroy the given completion queue alarm, cancelling it in the process. More...
  ;
  ;GRPCAPI grpc_connectivity_state   grpc_channel_check_connectivity_state (grpc_channel *channel, int try_to_connect)
  ;   Check the connectivity state of a channel. More...
  ;
  ;GRPCAPI int   grpc_channel_num_external_connectivity_watchers (grpc_channel *channel)
  ;   Number of active "external connectivity state watchers" attached to a channel. More...
  ;
  ;GRPCAPI void   grpc_channel_watch_connectivity_state (grpc_channel *channel, grpc_connectivity_state last_observed_state, gpr_timespec deadline, grpc_completion_queue *cq, void *tag)
  ;   Watch for a change in connectivity state. More...
  ;
  ;GRPCAPI grpc_call *   grpc_channel_create_call (grpc_channel *channel, grpc_call *parent_call, uint32_t propagation_mask, grpc_completion_queue *completion_queue, grpc_slice method, const grpc_slice *host, gpr_timespec deadline, void *reserved)
  ;   Create a call given a grpc_channel, in order to call 'method'. More...
  ;
  ;GRPCAPI void   grpc_channel_ping (grpc_channel *channel, grpc_completion_queue *cq, void *tag, void *reserved)
  ;   Ping the channels peer (load balanced channels will select one sub-channel to ping); if the channel is not connected, posts a failed. More...
  ;
  ;GRPCAPI void *   grpc_channel_register_call (grpc_channel *channel, const char *method, const char *host, void *reserved)
  ;   Pre-register a method/host pair on a channel. More...
  ;
  ;GRPCAPI grpc_call *   grpc_channel_create_registered_call (grpc_channel *channel, grpc_call *parent_call, uint32_t propagation_mask, grpc_completion_queue *completion_queue, void *registered_call_handle, gpr_timespec deadline, void *reserved)
  ;   Create a call given a handle returned from grpc_channel_register_call. More...
  ;
  ;GRPCAPI void *   grpc_call_arena_alloc (grpc_call *call, size_t size)
  ;   Allocate memory in the grpc_call arena: this memory is automatically discarded at call completion. More...
  ;
  ;GRPCAPI grpc_call_error   grpc_call_start_batch (grpc_call *call, const grpc_op *ops, size_t nops, void *tag, void *reserved)
  ;   Start a batch of operations defined in the array ops; when complete, post a completion of type 'tag' to the completion queue bound to the call. More...
  ;
  ;GRPCAPI char *   grpc_call_get_peer (grpc_call *call)
  ;   Returns a newly allocated string representing the endpoint to which this call is communicating with. More...
  ;
  ;GRPCAPI void   grpc_census_call_set_context (grpc_call *call, struct census_context *context)
  ;   Set census context for a call; Must be called before first call to grpc_call_start_batch(). More...
  ;
  ;GRPCAPI struct census_context *   grpc_census_call_get_context (grpc_call *call)
  ;   Retrieve the calls current census context. More...
  ;
  ;GRPCAPI char *   grpc_channel_get_target (grpc_channel *channel)
  ;   Return a newly allocated string representing the target a channel was created for. More...
  ;
  ;GRPCAPI void   grpc_channel_get_info (grpc_channel *channel, const grpc_channel_info *channel_info)
  ;   Request info about the channel. More...
  ;
  ;GRPCAPI grpc_channel *   grpc_insecure_channel_create (const char *target, const grpc_channel_args *args, void *reserved)
  ;   Create a client channel to 'target'. More...
  ;
  ;GRPCAPI grpc_channel *   grpc_lame_client_channel_create (const char *target, grpc_status_code error_code, const char *error_message)
  ;   Create a lame client: this client fails every operation attempted on it. More...
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
