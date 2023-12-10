// ignore_for_file: avoid_print
import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/navigation/scaffold_with_navbar.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/calendar/bloc/blocs.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/explorer/bloc/explorer_bloc.dart';
import 'package:bootdv2/screens/following/bloc/following_bloc.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/login/cubit/login_cubit.dart';
import 'package:bootdv2/screens/post/post_collection_screen.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/cubit/createcollection_cubit.dart';
import 'package:bootdv2/screens/profile/myprofile_screen.dart';
import 'package:bootdv2/screens/profile/profile_screen.dart';
import 'package:bootdv2/screens/profile/tab3/feed_collection.dart';
import 'package:bootdv2/screens/screens.dart';
import 'package:bootdv2/screens/signup/cubit/signup_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider<FeedOOTDBloc>(
                          create: (context) {
                            final feedOOTDBloc = FeedOOTDBloc(
                              feedRepository: context.read<FeedRepository>(),
                              authBloc: context.read<AuthBloc>(),
                              likedPostsCubit: context.read<LikedPostsCubit>(),
                            );
                            feedOOTDBloc.add(FeedOOTDFetchPostsOOTD());
                            return feedOOTDBloc;
                          },
                        ),
                        BlocProvider<FeedMonthBloc>(
                          create: (context) {
                            final feedMonthBloc = FeedMonthBloc(
                              feedRepository: context.read<FeedRepository>(),
                              authBloc: context.read<AuthBloc>(),
                            );
                            feedMonthBloc.add(FeedMonthFetchPostsMonth());
                            return feedMonthBloc;
                          },
                        ),
                        BlocProvider(
                          create: (context) {
                            final homeEventBloc = HomeEventBloc(
                              eventRepository: context.read<EventRepository>(),
                              authBloc: context.read<AuthBloc>(),
                            );
                            return homeEventBloc;
                          },
                        ),
                      ],
                      child: const HomeScreen(),
                    ),
                  );
                },
                routes: [
                  // home/post/:postId
                  GoRoute(
                    path: 'post/:postId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final postId = state.pathParameters['postId']!;
                      final username =
                          state.uri.queryParameters['username'] ?? 'Unknown';
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: PostScreen(postId: postId, username: username),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'user/:userId',
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final userId = state.pathParameters['userId']!;
                          final username =
                              state.uri.queryParameters['username'] ??
                                  'Unknown';
                          final title =
                              state.uri.queryParameters['title'] ?? 'title';

                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider<ProfileBloc>(
                                  create: (context) => ProfileBloc(
                                    authBloc: context.read<AuthBloc>(),
                                    userRepository:
                                        context.read<UserRepository>(),
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                                BlocProvider<YourCollectionBloc>(
                                  create: (context) => YourCollectionBloc(
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                              ],
                              child: ProfileScreen(
                                userId: userId,
                                username: username,
                                title: title,
                              ),
                            ),
                          );
                        },
                      ),
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
                    ],
                  ),
                  // home/user/:userId
                  GoRoute(
                    path: 'user/:userId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final userId = state.pathParameters['userId']!;
                      final username =
                          state.uri.queryParameters['username'] ?? 'Unknown';
                      final title =
                          state.uri.queryParameters['title'] ?? 'title';

                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider<ProfileBloc>(
                              create: (context) => ProfileBloc(
                                authBloc: context.read<AuthBloc>(),
                                userRepository: context.read<UserRepository>(),
                                postRepository: context.read<PostRepository>(),
                              ),
                            ),
                            BlocProvider<YourCollectionBloc>(
                              create: (context) => YourCollectionBloc(
                                postRepository: context.read<PostRepository>(),
                              ),
                            ),
                          ],
                          child: ProfileScreen(
                            userId: userId,
                            username: username,
                            title: title,
                          ),
                        ),
                      );
                    },
                  ),
                  // home/event/:event/Id
                  GoRoute(
                    path: 'event/:eventId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final eventId = state.pathParameters['eventId']!;
                      final title =
                          state.uri.queryParameters['title'] ?? 'title';
                      final logoUrl =
                          state.uri.queryParameters['logoUrl'] ?? 'logoUrl';
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: BlocProvider<FeedEventBloc>(
                          create: (context) {
                            final feedEventBloc = FeedEventBloc(
                              eventRepository: context.read<EventRepository>(),
                              feedRepository: context.read<FeedRepository>(),
                              authBloc: context.read<AuthBloc>(),
                              likedPostsCubit: context.read<LikedPostsCubit>(),
                            );
                            // Ajoutez ici un événement initial si nécessaire
                            return feedEventBloc;
                          },
                          child: FeedEvent(
                              eventId: eventId, title: title, logoUrl: logoUrl),
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'post/:postId',
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final postId = state.pathParameters['postId']!;
                          final username =
                              state.uri.queryParameters['username'] ??
                                  'Unknown';
                          final eventId = state.pathParameters['eventId']!;
                          final title =
                              state.uri.queryParameters['title'] ?? 'title';
                          final logoUrl =
                              state.uri.queryParameters['logoUrl'] ?? 'logoUrl';
                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: PostEventScreen(
                              title: title,
                              postId: postId,
                              username: username,
                              eventId: eventId,
                              logoUrl: logoUrl,
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'user/:userId',
                            pageBuilder:
                                (BuildContext context, GoRouterState state) {
                              final userId = state.pathParameters['userId']!;
                              final username =
                                  state.uri.queryParameters['username'] ??
                                      'Unknown';
                              final title =
                                  state.uri.queryParameters['title'] ?? 'title';

                              return MaterialPage<void>(
                                key: state.pageKey,
                                child: MultiBlocProvider(
                                  providers: [
                                    BlocProvider<ProfileBloc>(
                                      create: (context) => ProfileBloc(
                                        authBloc: context.read<AuthBloc>(),
                                        userRepository:
                                            context.read<UserRepository>(),
                                        postRepository:
                                            context.read<PostRepository>(),
                                      ),
                                    ),
                                    BlocProvider<YourCollectionBloc>(
                                      create: (context) => YourCollectionBloc(
                                        postRepository:
                                            context.read<PostRepository>(),
                                      ),
                                    ),
                                  ],
                                  child: ProfileScreen(
                                    userId: userId,
                                    username: username,
                                    title: title,
                                  ),
                                ),
                              );
                            },
                          ),
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
                        ],
                      ),
                      GoRoute(
                        path: 'user/:userId',
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final userId = state.pathParameters['userId']!;
                          final username =
                              state.uri.queryParameters['username'] ??
                                  'Unknown';
                          final title =
                              state.uri.queryParameters['title'] ?? 'title';

                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider<ProfileBloc>(
                                  create: (context) => ProfileBloc(
                                    authBloc: context.read<AuthBloc>(),
                                    userRepository:
                                        context.read<UserRepository>(),
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                                BlocProvider<YourCollectionBloc>(
                                  create: (context) => YourCollectionBloc(
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                              ],
                              child: ProfileScreen(
                                userId: userId,
                                username: username,
                                title: title,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Calendar
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: '/calendar',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return NoAnimationPage(
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider<CalendarLatestBloc>(
                            create: (context) {
                              final latestEventBloc = CalendarLatestBloc(
                                eventRepository:
                                    context.read<EventRepository>(),
                                authBloc: context.read<AuthBloc>(),
                              );
                              return latestEventBloc;
                            },
                          ),
                          BlocProvider(
                            create: (context) {
                              final thisWeekEventsBloc = CalendarThisWeekBloc(
                                eventRepository:
                                    context.read<EventRepository>(),
                                authBloc: context.read<AuthBloc>(),
                              );
                              return thisWeekEventsBloc;
                            },
                          ),
                          BlocProvider(
                            create: (context) {
                              final thisComignSoonEventsBloc =
                                  CalendarComingSoonBloc(
                                eventRepository:
                                    context.read<EventRepository>(),
                                authBloc: context.read<AuthBloc>(),
                              );
                              return thisComignSoonEventsBloc;
                            },
                          ),
                        ],
                        child: const CalendarScreen(),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                        path: 'event/:eventId',
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final eventId = state.pathParameters['eventId']!;
                          final title =
                              state.uri.queryParameters['title'] ?? 'title';
                          final logoUrl =
                              state.uri.queryParameters['logoUrl'] ?? 'logoUrl';
                          final author =
                              state.uri.queryParameters['author'] ?? 'author';
                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: EventScreen(
                              eventId: eventId,
                              title: title,
                              logoUrl: logoUrl,
                              author: author,
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'user/:userId',
                            pageBuilder:
                                (BuildContext context, GoRouterState state) {
                              final userId = state.pathParameters['userId']!;
                              final username =
                                  state.uri.queryParameters['username'] ??
                                      'Unknown';
                              final title =
                                  state.uri.queryParameters['title'] ?? 'title';

                              return MaterialPage<void>(
                                key: state.pageKey,
                                child: MultiBlocProvider(
                                  providers: [
                                    BlocProvider<ProfileBloc>(
                                      create: (context) => ProfileBloc(
                                        authBloc: context.read<AuthBloc>(),
                                        userRepository:
                                            context.read<UserRepository>(),
                                        postRepository:
                                            context.read<PostRepository>(),
                                      ),
                                    ),
                                    BlocProvider<YourCollectionBloc>(
                                      create: (context) => YourCollectionBloc(
                                        postRepository:
                                            context.read<PostRepository>(),
                                      ),
                                    ),
                                  ],
                                  child: ProfileBrandScreen(
                                    userId: userId,
                                    username: username,
                                    title: title,
                                  ),
                                ),
                              );
                            },
                          ),
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
                          GoRoute(
                            path: 'post/:postId',
                            pageBuilder:
                                (BuildContext context, GoRouterState state) {
                              final postId = state.pathParameters['postId']!;
                              final username =
                                  state.uri.queryParameters['username'] ??
                                      'Unknown';
                              final eventId =
                                  state.uri.queryParameters['eventId'] ??
                                      'Unknown';
                              return MaterialPage<void>(
                                key: state.pageKey,
                                child: PostCalendarScreen(
                                    postId: postId,
                                    username: username,
                                    eventId: eventId),
                              );
                            },
                            routes: [
                              GoRoute(
                                path: 'user/:userId',
                                pageBuilder: (BuildContext context,
                                    GoRouterState state) {
                                  final userId =
                                      state.pathParameters['userId']!;
                                  final username =
                                      state.uri.queryParameters['username'] ??
                                          'Unknown';
                                  final title =
                                      state.uri.queryParameters['title'] ??
                                          'title';

                                  return MaterialPage<void>(
                                    key: state.pageKey,
                                    child: MultiBlocProvider(
                                      providers: [
                                        BlocProvider<ProfileBloc>(
                                          create: (context) => ProfileBloc(
                                            authBloc: context.read<AuthBloc>(),
                                            userRepository:
                                                context.read<UserRepository>(),
                                            postRepository:
                                                context.read<PostRepository>(),
                                          ),
                                        ),
                                        BlocProvider<YourCollectionBloc>(
                                          create: (context) =>
                                              YourCollectionBloc(
                                            postRepository:
                                                context.read<PostRepository>(),
                                          ),
                                        ),
                                      ],
                                      child: ProfileScreen(
                                        userId: userId,
                                        username: username,
                                        title: title,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          GoRoute(
                            path: 'create',
                            builder:
                                (BuildContext context, GoRouterState state) {
                              final eventId = state.pathParameters['eventId']!;
                              return BlocProvider<CreatePostCubit>(
                                create: (context) => CreatePostCubit(
                                  postRepository:
                                      context.read<PostRepository>(),
                                  eventRepository:
                                      context.read<EventRepository>(),
                                  storageRepository:
                                      context.read<StorageRepository>(),
                                  authBloc: context.read<AuthBloc>(),
                                ),
                                child: CreatePostEventScreen(eventId: eventId),
                              );
                            },
                            routes: [
                              GoRoute(
                                path: 'brand',
                                builder: (BuildContext context,
                                    GoRouterState state) {
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
                        ]),
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
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider<FollowingBloc>(
                          create: (context) {
                            final followingBloc = FollowingBloc(
                              feedRepository: context.read<FeedRepository>(),
                              authBloc: context.read<AuthBloc>(),
                            );
                            return followingBloc;
                          },
                        ),
                        BlocProvider<ExplorerBloc>(
                          create: (context) {
                            final explorerBloc = ExplorerBloc(
                              feedRepository: context.read<FeedRepository>(),
                              authBloc: context.read<AuthBloc>(),
                            );
                            return explorerBloc;
                          },
                        ),
                      ],
                      child: const SearchScreen(),
                    ),
                  );
                },
                routes: [
                  // search/post/:postId
                  GoRoute(
                    path: 'post/:postId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final postId = state.pathParameters['postId']!;
                      final username =
                          state.uri.queryParameters['username'] ?? 'Unknown';
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: PostSearchScreen(
                            postId: postId, username: username),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'user/:userId',
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final userId = state.pathParameters['userId']!;
                          final username =
                              state.uri.queryParameters['username'] ??
                                  'Unknown';
                          final title =
                              state.uri.queryParameters['title'] ?? 'title';

                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider<ProfileBloc>(
                                  create: (context) => ProfileBloc(
                                    authBloc: context.read<AuthBloc>(),
                                    userRepository:
                                        context.read<UserRepository>(),
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                                BlocProvider<YourCollectionBloc>(
                                  create: (context) => YourCollectionBloc(
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                              ],
                              child: ProfileScreen(
                                userId: userId,
                                username: username,
                                title: title,
                              ),
                            ),
                          );
                        },
                      ),
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
                    ],
                  ),
                  // search/user/:userId
                  GoRoute(
                    path: 'user/:userId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final userId = state.pathParameters['userId']!;
                      final username =
                          state.uri.queryParameters['username'] ?? 'Unknown';
                      final title =
                          state.uri.queryParameters['title'] ?? 'title';

                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider<ProfileBloc>(
                              create: (context) => ProfileBloc(
                                authBloc: context.read<AuthBloc>(),
                                userRepository: context.read<UserRepository>(),
                                postRepository: context.read<PostRepository>(),
                              ),
                            ),
                            BlocProvider<YourCollectionBloc>(
                              create: (context) => YourCollectionBloc(
                                postRepository: context.read<PostRepository>(),
                              ),
                            ),
                          ],
                          child: ProfileScreen(
                            userId: userId,
                            username: username,
                            title: title,
                          ),
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
                builder: (BuildContext context, GoRouterState state) {
                  final authBloc = context.read<AuthBloc>();
                  final userId = authBloc.state.user!.uid;
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<ProfileBloc>(
                        create: (_) => ProfileBloc(
                          authBloc: authBloc,
                          userRepository: context.read<UserRepository>(),
                          postRepository: context.read<PostRepository>(),
                        )..add(ProfileLoadUser(userId: userId)),
                      ),
                      BlocProvider<CreateCollectionCubit>(
                        create: (_) => CreateCollectionCubit(
                          firebaseFirestore: FirebaseFirestore.instance,
                        ),
                      ),
                    ],
                    child: MyProfileScreen(
                      userId: userId,
                    ),
                  );
                },
                routes: <RouteBase>[
                  // Profile/Post
                  GoRoute(
                    path: 'post/:postId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final postId = state.pathParameters['postId']!;
                      final username =
                          state.uri.queryParameters['username'] ?? 'Unknown';
                      final eventId =
                          state.uri.queryParameters['eventId'] ?? 'Unknown';
                      final title =
                          state.uri.queryParameters['title'] ?? 'Unknown';
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: PostProfileScreen(
                            postId: postId,
                            username: username,
                            eventId: eventId,
                            title: title),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'user/:userId',
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final userId = state.pathParameters['userId']!;
                          final username =
                              state.uri.queryParameters['username'] ??
                                  'Unknown';
                          final title =
                              state.uri.queryParameters['title'] ?? 'title';

                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider<ProfileBloc>(
                                  create: (context) => ProfileBloc(
                                    authBloc: context.read<AuthBloc>(),
                                    userRepository:
                                        context.read<UserRepository>(),
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                                BlocProvider<YourCollectionBloc>(
                                  create: (context) => YourCollectionBloc(
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                              ],
                              child: ProfileScreen(
                                userId: userId,
                                username: username,
                                title: title,
                              ),
                            ),
                          );
                        },
                      ),
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
                    ],
                  ),
                  // profile/editprofile
                  GoRoute(
                    path: 'editprofile',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: EditProfileScreen(),
                      );
                    },
                  ),
                  // profile/settings
                  GoRoute(
                    path: 'settings',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: SettingsScreen(),
                      );
                    },
                  ),
                  // profile/notifications
                  GoRoute(
                    path: 'notifications',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: NotificationScreen(),
                      );
                    },
                  ),
                  // profile/create
                  GoRoute(
                    path: 'create',
                    builder: (BuildContext context, GoRouterState state) =>
                        BlocProvider<CreatePostCubit>(
                      create: (context) {
                        print("Creating CreatePostCubit");
                        return CreatePostCubit(
                          postRepository: context.read<PostRepository>(),
                          eventRepository: context.read<EventRepository>(),
                          storageRepository: context.read<StorageRepository>(),
                          authBloc: context.read<AuthBloc>(),
                        );
                      },
                      child: const CreatePostScreen(),
                    ),
                    routes: [
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
                  // profile/collection
                  GoRoute(
                    path: 'collection/:collectionId',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      final collectionId =
                          state.pathParameters['collectionId']!;
                      final title =
                          state.uri.queryParameters['title'] ?? 'title';

                      return MaterialPage<void>(
                        key: state.pageKey,
                        child: FeedCollection(
                            collectionId: collectionId, title: title),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'post/:postId',
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final postId = state.pathParameters['postId']!;
                          final collectionId =
                              state.pathParameters['collectionId']!;
                          final username =
                              state.uri.queryParameters['username'] ??
                                  'Unknown';
                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: PostCollectionScreen(
                              postId: postId,
                              collectionId: collectionId,
                              username: username,
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'user/:userId',
                            pageBuilder:
                                (BuildContext context, GoRouterState state) {
                              final userId = state.pathParameters['userId']!;
                              final username =
                                  state.uri.queryParameters['username'] ??
                                      'Unknown';
                              final title =
                                  state.uri.queryParameters['title'] ?? 'title';

                              return MaterialPage<void>(
                                key: state.pageKey,
                                child: MultiBlocProvider(
                                  providers: [
                                    BlocProvider<ProfileBloc>(
                                      create: (context) => ProfileBloc(
                                        authBloc: context.read<AuthBloc>(),
                                        userRepository:
                                            context.read<UserRepository>(),
                                        postRepository:
                                            context.read<PostRepository>(),
                                      ),
                                    ),
                                    BlocProvider<YourCollectionBloc>(
                                      create: (context) => YourCollectionBloc(
                                        postRepository:
                                            context.read<PostRepository>(),
                                      ),
                                    ),
                                  ],
                                  child: ProfileScreen(
                                    userId: userId,
                                    username: username,
                                    title: title,
                                  ),
                                ),
                              );
                            },
                          ),
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
                        ],
                      ),
                      GoRoute(
                        path: 'user/:userId',
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final userId = state.pathParameters['userId']!;
                          final username =
                              state.uri.queryParameters['username'] ??
                                  'Unknown';
                          final title =
                              state.uri.queryParameters['title'] ?? 'title';

                          return MaterialPage<void>(
                            key: state.pageKey,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider<ProfileBloc>(
                                  create: (context) => ProfileBloc(
                                    authBloc: context.read<AuthBloc>(),
                                    userRepository:
                                        context.read<UserRepository>(),
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                                BlocProvider<YourCollectionBloc>(
                                  create: (context) => YourCollectionBloc(
                                    postRepository:
                                        context.read<PostRepository>(),
                                  ),
                                ),
                              ],
                              child: ProfileScreen(
                                userId: userId,
                                username: username,
                                title: title,
                              ),
                            ),
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
