import 'dart:async';

import 'package:json_api/document.dart';
import 'package:json_api/src/document/identifier.dart';
import 'package:json_api/src/document/resource.dart';
import 'package:json_api/src/server/response/response.dart';

abstract class Controller {
  FutureOr<Response> fetchCollection(String type, Uri uri);

  FutureOr<Response> fetchResource(String type, String id, Uri uri);

  FutureOr<Response> fetchRelated(
      String type, String id, String relationship, Uri uri);

  FutureOr<Response> fetchRelationship(
      String type, String id, String relationship, Uri uri);

  FutureOr<Response> deleteResource(String type, String id);

  FutureOr<Response> createResource(String type, Resource resource);

  FutureOr<Response> updateResource(String type, String id, Resource resource);

  FutureOr<Response> replaceToOne(
      String type, String id, String relationship, Identifier identifier);

  FutureOr<Response> replaceToMany(String type, String id, String relationship,
      List<Identifier> identifiers);

  FutureOr<Response> addToMany(String type, String id, String relationship,
      List<Identifier> identifiers);
}