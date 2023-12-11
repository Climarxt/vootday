import 'package:go_router/go_router.dart';

class RouteConfig {
  static String getPostId(GoRouterState state) {
    return state.pathParameters['postId']!;
  }

  static String getUsername(GoRouterState state) {
    return state.uri.queryParameters['username'] ?? 'Unknown';
  }
}
