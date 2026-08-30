# Архитектура обработки ошибок

## Общая схема

Основной путь ошибки HTTP-запроса:

```text
Dio
  → interceptors
  → DioClient
  → service
  → repository
  → BLoC/Cubit
  → presentation
```

Преобразование ошибки выполняется на том уровне, где появляется необходимый контекст: transport, endpoint или операция приложения.

## Типы ошибок

### FetchException

`DioClient` создаёт `FetchException` при перехвате `DioException`. Исключение содержит:

- `FetchExceptionType`;
- `DioExceptionType`;
- HTTP status code;
- тело ответа.

`FetchExceptionType.requestFailed` используется для общей ошибки запроса. `UserService` использует типы `bookmarkCommentsLoadFailed` и `userCommentsLoadFailed` для соответствующих запросов. `ImageActionCubit` использует тип `missingMimeType`, когда в ответе изображения отсутствует header `content-type`.

### CommentsListException

`CommentsListException` описывает ошибки загрузки комментариев. `PublicationService` создаёт его из `FetchException`, извлекая `httpCode` и `errorCode` из тела ответа.

### ValueException и NotFoundException

`ValueException` используется для известных недопустимых значений и отрицательных результатов операций API. `NotFoundException` используется, когда ожидаемое значение отсутствует.

### AppFailure

`AppFailure` хранит тип операции приложения и, при наличии, исходную ошибку в `cause`. BLoC и Cubit помещают его в состояние, чтобы presentation мог выбрать сообщение с учётом контекста операции.

## Ответственность компонентов

### Dio interceptors

Interceptors настраивают cookies, CSRF, язык запросов и логирование. Ошибки продолжают цепочку Dio как `DioException`.

### DioClient

Все методы `DioClient` выполняют запрос через общий `_execute`. Он перехватывает только `DioException`, создаёт `FetchException` и повторно выбрасывает его с исходным stack trace через `Error.throwWithStackTrace`.

Ошибки, возникшие после получения `Response`, этим преобразованием не охватываются.

Интерфейс `HttpClient` использует Dio-типы `Response` и `Options`. Он централизует выполнение запросов и преобразование transport errors, но не скрывает Dio API от вызывающего кода.

### Service

Service задаёт endpoint и параметры запроса, получает `Response` и преобразует его данные в типизированную модель.

В текущих service нет общего `catch`, преобразующего любую ошибку в `FetchException`. Поэтому ошибки parsing и программные ошибки распространяются с исходным типом.

Endpoint-specific обработка выполняется точечно:

- `PublicationService.fetchComments` преобразует `FetchException` в `CommentsListException`;
- `UserService` уточняет `FetchExceptionType` для двух вариантов загрузки комментариев;
- `PublicationService` и `SearchService` создают `ValueException` для известных ошибок операции.

При повторном выбрасывании endpoint-specific ошибки сохраняется stack trace пойманного исключения.

### Repository

Repository получает от service типизированные модели. В repository выполняются объединение источников данных, работа с cache и storage, сортировка и преобразования моделей.

Repository не обрабатывает `DioException` и не преобразует transport errors. Ошибки локального cache могут обрабатываться на месте, если повреждённые данные допускается удалить и восстановить.

### BLoC/Cubit

BLoC и Cubit перехватывают ошибки выполняемой операции и отражают failure-состояние. Для сообщений, зависящих от операции, они создают `AppFailure` с соответствующим `AppFailureType` и исходной ошибкой.

Обработчики, получающие `StackTrace`, передают ошибку в `onError` для логирования.

### Presentation

`ErrorTranslations.errorMessage` сначала извлекает `cause` из `AppFailure`, затем выбирает сообщение в следующем порядке:

1. сообщение для известного типа исключения или непустой строки;
2. сообщение для `AppFailureType`;
3. общее сообщение о неизвестной ошибке.

Локализация выполняется при отображении, поэтому используется текущий язык приложения.

## ImageActionCubit

`ImageActionCubit` использует `HttpClient` напрямую для загрузки изображения как массива bytes. Cubit читает MIME type из headers и создаёт `FetchException` с типом `missingMimeType`, если header `content-type` отсутствует.

Ошибки загрузки, сохранения и отправки изображения помещаются в `AppFailure` с типом `operationFailed`.
