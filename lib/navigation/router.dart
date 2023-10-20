import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/calendar/event_screen.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/login/cubit/login_cubit.dart';
import 'package:bootdv2/screens/post/postscreen.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/screens/profile/profileedit_screen.dart';
import 'package:bootdv2/screens/signup/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/screens/screens.dart';
import 'scaffold_with_navbar.dart';

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
      // Post
      GoRoute(
        path: '/post',
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            authBloc: context.read<AuthBloc>(),
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
          )..add(
              ProfileLoadUser(userId: authBloc.state.user!.uid),
            ),
          child: PostScreen(postImage: 'assets/images/placeholder-image.png'),
        ),
      ),
      // Post
      GoRoute(
        path: '/event',
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            authBloc: context.read<AuthBloc>(),
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
          )..add(
              ProfileLoadUser(userId: authBloc.state.user!.uid),
            ),
          child: EventScreen(postImage: 'assets/images/placeholder-image.png'),
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
                  return NoAnimationPage(child: const HomeScreen());
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
                  return NoAnimationPage(child: const CalendarScreen());
                },
              ),
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
                  return NoAnimationPage(child: const SearchScreen());
                },
              ),
            ],
          ),
          // Create Post
          /* StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/search',
                builder: (BuildContext context, GoRouterState state) =>
                    BlocProvider<CreatePostCubit>(
                  create: (context) => CreatePostCubit(
                    postRepository: context.read<PostRepository>(),
                    storageRepository: context.read<StorageRepository>(),
                    authBloc: context.read<AuthBloc>(),
                  ),
                  child: const CreatePostScreen(),
                ),
              ),
            ],
          ),
          */
          // Profile
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (BuildContext context, GoRouterState state) =>
                    BlocProvider<ProfileBloc>(
                  create: (_) => ProfileBloc(
                    authBloc: context.read<AuthBloc>(),
                    userRepository: context.read<UserRepository>(),
                    postRepository: context.read<PostRepository>(),
                  )..add(
                      ProfileLoadUser(userId: authBloc.state.user!.uid),
                    ),
                  child: ProfileScreen(),
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'editprofile',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return NoAnimationPage(child: const EditProfileScreen());
                    },
                  ),
                  GoRoute(
                    path: 'settings',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return NoAnimationPage(child: const SettingsScreen());
                    },
                  ),
                  GoRoute(
                    path: 'notifications',
                    pageBuilder: (BuildContext context, GoRouterState state) {
                      return NoAnimationPage(child: const NotificationScreen());
                    },
                  ),
                  GoRoute(
                    path: 'create',
                    builder: (BuildContext context, GoRouterState state) =>
                        BlocProvider<CreatePostCubit>(
                      create: (context) => CreatePostCubit(
                        postRepository: context.read<PostRepository>(),
                        storageRepository: context.read<StorageRepository>(),
                        authBloc: context.read<AuthBloc>(),
                      ),
                      child: const CreatePostScreen(),
                    ),
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
