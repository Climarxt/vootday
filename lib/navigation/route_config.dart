import 'package:go_router/go_router.dart';

class RouteConfig {
  static String getPostId(GoRouterState state) {
    return state.pathParameters['postId']!;
  }

    static String getPostIdUri(GoRouterState state) {
    return state.uri.queryParameters['postId'] ?? 'Unknown';
  }

  static String getUsername(GoRouterState state) {
    return state.uri.queryParameters['username'] ?? 'Unknown';
  }

  static String getUserId(GoRouterState state) {
    return state.pathParameters['userId']!;
  }

  static String getUserIdUri(GoRouterState state) {
    return state.uri.queryParameters['userId'] ?? 'Unknown';
  }

  static String getTitle(GoRouterState state) {
    return state.uri.queryParameters['title'] ?? 'title';
  }

  static String getCollectionId(GoRouterState state) {
    return state.pathParameters['collectionId']!;
  }

  static String getEventId(GoRouterState state) {
    return state.pathParameters['eventId']!;
  }

  static String getLogoUrl(GoRouterState state) {
    return state.uri.queryParameters['logoUrl'] ?? 'logoUrl';
  }

  static String getAuthor(GoRouterState state) {
    return state.uri.queryParameters['author'] ?? 'author';
  }

  static String getCurrentLocation(GoRouterState state) {
    return state.uri.queryParameters['author'] ?? 'author';
  }

  static String getCurrentPath(GoRouterState state) {
    return state.uri.toString();
  }
}
