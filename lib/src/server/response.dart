import 'package:json_api/document.dart';
import 'package:json_api/src/server/response_converter.dart';

/// The base interface for all JSON:API responses
abstract class Response {
  /// Converts the JSON:API response to another object, e.g. HTTP response.
  T convert<T>(ResponseConverter<T> converter);
}

/// HTTP 204 No Content response.
///
/// See:
/// - https://jsonapi.org/format/#crud-creating-responses-204
/// - https://jsonapi.org/format/#crud-updating-responses-204
/// - https://jsonapi.org/format/#crud-updating-relationship-responses-204
/// - https://jsonapi.org/format/#crud-deleting-responses-204
class NoContentResponse implements Response {
  @override
  T convert<T>(ResponseConverter<T> converter) => converter.noContent();
}

/// HTTP 200 OK response with a resource collection.
///
/// See: https://jsonapi.org/format/#fetching-resources-responses-200
class CollectionResponse implements Response {
  CollectionResponse(this.resources, {this.included, this.total});

  final Iterable<Resource> resources;
  final Iterable<Resource> included;

  final int total;

  @override
  T convert<T>(ResponseConverter<T> converter) =>
      converter.collection(resources, included: included, total: total);
}

/// HTTP 202 Accepted response.
///
/// See: https://jsonapi.org/recommendations/#asynchronous-processing
class AcceptedResponse implements Response {
  AcceptedResponse(this.resource);

  final Resource resource;

  @override
  T convert<T>(ResponseConverter<T> converter) => converter.accepted(resource);
}

/// A common error response.
///
/// See: https://jsonapi.org/format/#errors
class ErrorResponse implements Response {
  ErrorResponse(this.statusCode, this.errors,
      {Map<String, String> headers = const {}})
      : _headers = Map.unmodifiable(headers);

  /// HTTP 400 Bad Request response.
  ///
  /// See:
  /// - https://jsonapi.org/format/#fetching-includes
  /// - https://jsonapi.org/format/#fetching-sorting
  /// - https://jsonapi.org/format/#query-parameters
  ErrorResponse.badRequest(Iterable<ErrorObject> errors) : this(400, errors);

  /// HTTP 403 Forbidden response.
  ///
  /// See:
  /// - https://jsonapi.org/format/#crud-creating-client-ids
  /// - https://jsonapi.org/format/#crud-creating-responses-403
  /// - https://jsonapi.org/format/#crud-updating-resource-relationships
  /// - https://jsonapi.org/format/#crud-updating-relationship-responses-403
  ErrorResponse.forbidden(Iterable<ErrorObject> errors) : this(403, errors);

  /// HTTP 404 Not Found response.
  ///
  /// See:
  /// - https://jsonapi.org/format/#fetching-resources-responses-404
  /// - https://jsonapi.org/format/#fetching-relationships-responses-404
  /// - https://jsonapi.org/format/#crud-creating-responses-404
  /// - https://jsonapi.org/format/#crud-updating-responses-404
  /// - https://jsonapi.org/format/#crud-deleting-responses-404
  ErrorResponse.notFound(Iterable<ErrorObject> errors) : this(404, errors);

  /// HTTP 405 Method Not Allowed response.
  /// The allowed methods can be specified in [allow]
  ErrorResponse.methodNotAllowed(
      Iterable<ErrorObject> errors, Iterable<String> allow)
      : this(405, errors, headers: {'Allow': allow.join(', ')});

  /// HTTP 409 Conflict response.
  ///
  /// See:
  /// - https://jsonapi.org/format/#crud-creating-responses-409
  /// - https://jsonapi.org/format/#crud-updating-responses-409
  ErrorResponse.conflict(Iterable<ErrorObject> errors) : this(409, errors);

  /// HTTP 500 Internal Server Error response.
  ErrorResponse.internalServerError(Iterable<ErrorObject> errors)
      : this(500, errors);

  /// HTTP 501 Not Implemented response.
  ErrorResponse.notImplemented(Iterable<ErrorObject> errors)
      : this(501, errors);

  /// Error objects to send with the response
  final Iterable<ErrorObject> errors;

  /// HTTP status code
  final int statusCode;
  final Map<String, String> _headers;

  @override
  T convert<T>(ResponseConverter<T> converter) =>
      converter.error(errors, statusCode, _headers);
}

/// HTTP 200 OK response containing an empty document.
///
/// See:
/// - https://jsonapi.org/format/#crud-updating-responses-200
/// - https://jsonapi.org/format/#crud-updating-relationship-responses-200
/// - https://jsonapi.org/format/#crud-deleting-responses-200
class MetaResponse implements Response {
  MetaResponse(Map<String, Object> meta) : meta = Map.unmodifiable(meta);

  final Map<String, Object> meta;

  @override
  T convert<T>(ResponseConverter<T> converter) => converter.meta(meta);
}

/// A successful response containing a resource object.
///
/// See:
/// - https://jsonapi.org/format/#fetching-resources-responses-200
/// - https://jsonapi.org/format/#crud-updating-responses-200
class ResourceResponse implements Response {
  ResourceResponse(this.resource, {this.included});

  final Resource resource;

  final Iterable<Resource> included;

  @override
  T convert<T>(ResponseConverter<T> converter) =>
      converter.resource(resource, included: included);
}

/// HTTP 201 Created response containing a newly created resource
///
/// See: https://jsonapi.org/format/#crud-creating-responses-201
class ResourceCreatedResponse implements Response {
  ResourceCreatedResponse(this.resource);

  final Resource resource;

  @override
  T convert<T>(ResponseConverter<T> converter) =>
      converter.resourceCreated(resource);
}

/// HTTP 303 See Other response.
///
/// See: https://jsonapi.org/recommendations/#asynchronous-processing
class SeeOtherResponse implements Response {
  SeeOtherResponse(this.type, this.id);

  /// Resource type
  final String type;

  /// Resource id
  final String id;

  @override
  T convert<T>(ResponseConverter<T> converter) => converter.seeOther(type, id);
}

/// HTTP 200 OK response containing a to-may relationship.
///
/// See:
/// - https://jsonapi.org/format/#fetching-relationships-responses-200
/// - https://jsonapi.org/format/#crud-updating-relationship-responses-200
class ToManyResponse implements Response {
  ToManyResponse(this.type, this.id, this.relationship, this.identifiers);

  final String type;
  final String id;
  final String relationship;
  final Iterable<Identifier> identifiers;

  @override
  T convert<T>(ResponseConverter<T> converter) =>
      converter.toMany(type, id, relationship, identifiers);
}

/// HTTP 200 OK response containing a to-one relationship
///
/// See:
/// - https://jsonapi.org/format/#fetching-relationships-responses-200
/// - https://jsonapi.org/format/#crud-updating-relationship-responses-200
class ToOneResponse implements Response {
  ToOneResponse(this.type, this.id, this.relationship, this.identifier);

  final String type;
  final String id;
  final String relationship;

  final Identifier identifier;

  @override
  T convert<T>(ResponseConverter<T> converter) =>
      converter.toOne(identifier, type, id, relationship);
}