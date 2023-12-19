// ignore_for_file: avoid_print
import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/navigation/bloc_provider_config.dart';
import 'package:bootdv2/navigation/route_config.dart';
import 'package:bootdv2/navigation/scaffold_with_navbar.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/follow_users/follow_users.dart';
import 'package:bootdv2/screens/login/cubit/login_cubit.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/myprofile_screen.dart';
import 'package:bootdv2/screens/profile/profile_screen.dart';
import 'package:bootdv2/screens/profile/tab3/feed_collection.dart';
import 'package:bootdv2/screens/screens.dart';
import 'package:bootdv2/screens/search/cubit/search_cubit.dart';
import 'package:bootdv2/screens/search/searching_screen.dart';
import 'package:bootdv2/screens/signup/cubit/signup_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
// final GlobalKey<NavigatorState> _sectionANavigatorKey =
//    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

GoRouter createRouter(BuildContext context) {
  final authBloc = context.read<AuthBloc>();
  final goRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/home',
    routes: <RouteBase>[
      //Login
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<LoginCubit>(
          create: (context) =>
              LoginCubit(authRepository: context.read<AuthRepository>()),
          child: const LoginScreen(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'termsandconditions',
            builder: (BuildContext context, GoRouterState state) =>
                const TermsAndConditions(),
          ),
          GoRoute(
            path: 'privacypolicy',
            builder: (BuildContext context, GoRouterState state) =>
                const PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: 'help',
            builder: (BuildContext context, GoRouterState state) =>
                const LoginHelpScreen(),
          ),
          GoRoute(
            path: 'mail',
            builder: (BuildContext context, GoRouterState state) =>
                BlocProvider<LoginCubit>(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>()),
              child: LoginMailScreen(),
            ),
          ),
        ],
      ),
      // Signup
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<SignupCubit>(
          create: (context) =>
              SignupCubit(authRepository: context.read<AuthRepository>()),
          child: SignupScreen(),
        ),
      ),
      // FeedEvent
      GoRoute(
        path: '/feedevent/:eventId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final eventId = RouteConfig.getEventId(state);
          final title = RouteConfig.getTitle(state);
          final logoUrl = RouteConfig.getLogoUrl(state);
          return MaterialPage<void>(
            key: state.pageKey,
            child: BlocProviderConfig.getFeedEventBlocProvider(
              context,
              FeedEvent(eventId: eventId, title: title, logoUrl: logoUrl),
            ),
          );
        },
      ),
      // FeedCollection
      GoRoute(
        path: '/collection/:collectionId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final collectionId = RouteConfig.getCollectionId(state);
          final title = RouteConfig.getTitle(state);
          return MaterialPage<void>(
            key: state.pageKey,
            child: BlocProviderConfig.getFeedCollectionBlocProvider(
              context,
              FeedCollection(
                collectionId: collectionId,
                title: title,
              ),
            ),
          );
        },
      ),
      // Brand Profile
      GoRoute(
        path: '/brand/:userId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final userId = RouteConfig.getUserId(state);
          final username = RouteConfig.getUsername(state);
          final title = RouteConfig.getTitle(state);

          return MaterialPage<void>(
            key: state.pageKey,
            child: BlocProviderConfig.getProfileMultiBlocProvider(
              context,
              ProfileBrandScreen(
                userId: userId,
                username: username,
                title: title,
              ),
            ),
          );
        },
      ),
      // User Profile
      GoRoute(
        path: '/user/:userId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final userId = RouteConfig.getUserId(state);
          final username = RouteConfig.getUsername(state);
          final title = RouteConfig.getTitle(state);

          return MaterialPage<void>(
            key: state.pageKey,
            child: BlocProviderConfig.getProfileMultiBlocProvider(
              context,
              ProfileScreen(
                userId: userId,
                username: username,
                title: title,
              ),
            ),
          );
        },
      ),
      // Post
      GoRoute(
        path: '/post/:postId',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final postId = RouteConfig.getPostId(state);
          final fromPath = state.extra as String? ?? 'defaultFromPath';
          return MaterialPage<void>(
            key: state.pageKey,
            child: PostScreen(postId: postId, fromPath: fromPath),
          );
        },
        routes: [
          GoRoute(
            path: 'comment',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return MaterialPage<void>(
                key: state.pageKey,
                child: const CommentWIPScreen(),
              );
            },
          ),
        ],
      ),
      // Followers Following
      GoRoute(
        path: '/followersfollowingscreen',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final userId = RouteConfig.getUserIdUri(state);
          int initialTabIndex = 0;
          if (state.extra is Map<String, dynamic>) {
            final extra = state.extra as Map<String, dynamic>;
            initialTabIndex = extra['initialTabIndex'] ?? 0;
          }
          return MaterialPage<void>(
            key: state.pageKey,
            child: BlocProvider<ProfileBloc>(
              create: (context) => ProfileBloc(
                authBloc: context.read<AuthBloc>(),
                userRepository: context.read<UserRepository>(),
                postRepository: context.read<PostRepository>(),
              ),
              child: FollowUsersScreen(
                  userId: userId, initialTabIndex: initialTabIndex),
            ),
          );
        },
      ),

      // StatefulShellBranch
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          String title;
          Widget? actionButton;
          // Switch on the state's location
          switch (state.matchedLocation) {
            case '/home':
              title = "Home";
              actionButton = null;
              break;
            case '/swipe':
              title = "Swipe";
              actionButton = null;
              break;
            case '/search':
              title = "Search";
              actionButton = null;
              break;
            case '/profile':
              title = "Ctbast";
              actionButton = null;
              break;
            case '/profile/settings':
              title = "Settings";
              actionButton = null;
              break;
            case '/profile/parameters':
              title = "Parameters";
              actionButton = null;
              break;
            default:
              title = "Default Screen";
              actionButton = null;
          }
          return ScaffoldWithNavBar(
            currentLocation: state.uri.toString(),
            navigationShell: navigationShell,
            appTitle: title,
            appBar: state.uri.toString().startsWith('/home') ||
                    state.uri.toString().startsWith('/profile') ||
                    state.uri.toString().startsWith('/swipe') ||
                    state.uri.toString().startsWith('/search') ||
                    state.uri.toString().startsWith('/notifications') ||
                    state.uri.toString().startsWith('/calendar') ||
                    state.uri.toString().startsWith('/post')
                ? null
                : AppBar(
                    // If the current location is '/** */', display a leading IconButton
                    leading: state.uri.toString() == '/***'
                        ? IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          )
                        : null,
                    // If the current location is '/swipe', don't display a title
                    title: state.uri.toString() == '/swipe' ||
                            state.uri.toString() == '/profile'
                        ? null
                        : Text(
                            title,
                            style: const TextStyle(color: Colors.black),
                          ),
                    backgroundColor: Colors.white,
                    // If an actionButton is defined, display it. Otherwise, don't display anything
                    actions: actionButton != null ? [actionButton] : null,
                    // Setting the color of the icons in the AppBar
                    iconTheme: const IconThemeData(color: Colors.black),
                    elevation: 0,
                  ),
          );
        },
        branches: <StatefulShellBranch>[
          // Home
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: BlocProviderConfig.getHomeMultiBlocProvider(
                        context, const HomeScreen()),
                  );
                },
              ),
            ],
          ),
          // Calendar
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/calendar',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return MaterialPage<void>(
                      key: state.pageKey,
                      child: BlocProviderConfig.getCalendarMultiBlocProvider(
                          context, const CalendarScreen()),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: 'event/:eventId',
                      pageBuilder: (BuildContext context, GoRouterState state) {
                        final eventId = RouteConfig.getEventId(state);
                        String currentPath = RouteConfig.getCurrentPath(state);
                        return MaterialPage<void>(
                          key: state.pageKey,
                          child: EventScreen(
                            fromPath: currentPath,
                            eventId: eventId,
                          ),
                        );
                      },
                      routes: [
                        // calendar/event/:eventId/comment
                        GoRoute(
                          path: 'comment',
                          pageBuilder:
                              (BuildContext context, GoRouterState state) {
                            return MaterialPage<void>(
                              key: state.pageKey,
                              child: const CommentWIPScreen(),
                            );
                          },
                        ),
                        // calendar/event/:eventId/create
                        GoRoute(
                          path: 'create',
                          builder: (BuildContext context, GoRouterState state) {
                            final eventId = RouteConfig.getEventId(state);
                            return BlocProviderConfig.getCreatePostBlocProvider(
                              context,
                              CreatePostEventScreen(eventId: eventId),
                            );
                          },
                        ),
                      ],
                    ),
                  ]),
            ],
          ),
          // Swipe
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/swipe',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoAnimationPage(child: const SwipeScreen());
                },
              ),
            ],
          ),
          // Search
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/search',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: BlocProviderConfig
                        .getFollowingExplorerMultiBlocProvider(
                      context,
                      const SearchScreen(),
                    ),
                  );
                },
                routes: <RouteBase>[
                  // search/searching
                  GoRoute(
                    path: 'searching',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: BlocProvider<SearchCubit>(
                          create: (context) => SearchCubit(
                            userRepository: context.read<UserRepository>(),
                          ),
                          child: const SearchingScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Profile
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final userId = authBloc.state.user!.uid;
                  return MaterialPage<void>(
                    key: state.pageKey,
                    child: BlocProviderConfig.getMyProfileMultiBlocProvider(
                      context,
                      MyProfileScreen(
                        userId: userId,
                      ),
                    ),
                  );
                },
                routes: <RouteBase>[
                  // profile/editprofile
                  GoRoute(
                    path: 'editprofile',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: const EditProfileScreen(),
                      );
                    },
                  ),
                  // profile/settings
                  GoRoute(
                    path: 'settings',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: const SettingsScreen(),
                      );
                    },
                  ),
                  // profile/notifications
                  GoRoute(
                    path: 'notifications',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: const NotificationScreen(),
                      );
                    },
                  ),
                  // profile/create
                  GoRoute(
                    path: 'create',
                    builder: (BuildContext context, GoRouterState state) {
                      return BlocProviderConfig.getCreatePostBlocProvider(
                        context,
                        const CreatePostScreen(),
                      );
                    },
                    routes: [
                      // calendar/event/:eventId/create/brand
                      GoRoute(
                        path: 'brand',
                        builder: (BuildContext context, GoRouterState state) {
                          print('State extra value: ${state.extra}');

                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: state.extra! as CreatePostCubit,
                              ),
                              BlocProvider<BrandCubit>(
                                create: (context) => BrandCubit(
                                  brandRepository:
                                      context.read<BrandRepository>(),
                                ),
                              ),
                            ],
                            child: const BrandSearchScreen(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  authBloc.stream.listen((state) {
    if (state.status == AuthStatus.unauthenticated) {
      goRouter.go('/login');
    } else if (state.status == AuthStatus.authenticated) {
      goRouter.go('/home');
    }
  });

  return goRouter;
}
