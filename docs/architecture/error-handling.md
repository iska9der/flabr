# Error Handling Architecture

## Overview

The primary error propagation path is:

```text
HTTP client
  → service
  → repository
  → BLoC/Cubit
  → presentation
```

Feature-local operations may omit individual layers, but the responsibility boundaries between data retrieval, state management, and presentation remain intact.

## Error categories

### Transport errors

HTTP request execution errors are converted to application exceptions at the HTTP client boundary. An exception may contain transport metadata required by downstream layers to interpret the response.

### Data and semantic errors

Parsing errors retain their original type. Known data format, missing value, and API semantic errors are represented by dedicated application exceptions.

### Operation failures

`AppFailure` adds user-operation context to the original error. It is used in BLoC/Cubit state and does not replace the original exception.

## Layer responsibilities

### HTTP infrastructure

Interceptors perform infrastructure tasks and continue the transport library’s error chain.

The HTTP client converts request execution errors only. Errors raised after a response is received must not be classified as transport errors.

Conversions preserve the original stack trace and any transport metadata required for further processing.

### Service

A service defines request parameters and converts a transport response into a typed model.

A service may convert a transport exception into a more specific exception when endpoint knowledge or the error payload is required. Rethrowing must preserve the caught exception’s stack trace.

A service does not wrap every error in a broad `catch`; parsing errors and programming errors propagate with their original types.

### Repository

A repository receives typed data from a service and combines data sources, cache, and storage. It does not depend on transport exceptions or duplicate their conversion.

Recoverable local-source errors may be handled inside the repository when corrupted data can be safely removed or fetched again.

### BLoC/Cubit

A BLoC/Cubit converts an operation result into state. User-facing operation context is represented by `AppFailure`, which may retain the original exception as its cause.

When a handler catches an error locally, it passes both the error and stack trace to `onError`.

### Presentation

The presentation layer converts an error from state into a localized message when rendering it.

Message priority:

1. a known exception with specific semantics;
2. operation context from `AppFailure`;
3. a generic unknown-error message.

This order preserves a precise message when the cause is known and provides a correct fallback in all other cases.

## Conversion rules

1. An error is converted only by a layer that has the required context.
2. Parsing errors and programming errors are not disguised as transport errors.
3. Rethrowing does not replace the original stack trace.
4. A repository does not receive a raw transport response.
5. Localization does not occur in the data layer or BLoC/Cubit.
