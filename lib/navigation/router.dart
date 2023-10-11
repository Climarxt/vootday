import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/login/cubit/login_cubit.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/screens/signup/cubit/signup_cubit.dart';
import 'package:bootdv2/widgets/widgets.dart';
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
          child: LoginScreen(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'mail',
            builder: (BuildContext context, GoRouterState state) =>
                BlocProvider<LoginCubit>(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>()),
              child: LoginMailScreen(),
            ),
          ),
          GoRoute(
            path: 'help',
            builder: (BuildContext context, GoRouterState state) =>
                BlocProvider<LoginCubit>(
              create: (context) =>
                  LoginCubit(authRepository: context.read<AuthRepository>()),
              child: const LoginHelpScreen(),
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
      // About
      GoRoute(
        path: '/about',
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<LoginCubit>(
          create: (context) =>
              LoginCubit(authRepository: context.read<AuthRepository>()),
          child: const AboutScreen(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'policies',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                CustomTransitionPage<void>(
              key: state.pageKey,
              child: const SearchScreen(),
              transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) =>
                  SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn)).animate(animation),
                child: child,
              ),
            ),
          ),
          GoRoute(
            path: 'conditionsgen',
            pageBuilder: (BuildContext context, GoRouterState state) =>
                CustomTransitionPage<void>(
              key: state.pageKey,
              child: const SearchScreen(),
              transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) =>
                  SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn)).animate(animation),
                child: child,
              ),
            ),
          ),
        ],
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
            case '/swipe/calendar':
              title = "Calendar";
              actionButton = null;
              break;
            case '/swipe/search':
              title = "Search";
              actionButton = null;
              break;
            case '/createpost':
              title = "Create Post";
              actionButton = null;
              break;
            case '/notifications':
              title = "Notifications";
              actionButton = ActionButton(
                  context: context,
                  icon: Icons.message,
                  route: '/notifications/message');
              break;
            case '/notifications/message':
              title = "Message";
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
                    state.uri.toString().startsWith('/swipe') 
                ? null
                : AppBar(
                    // If the current location is '/swipe', display a leading IconButton
                    leading: state.uri.toString() == '/notifications'
                        ? IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              GoRouter.of(context).go('/swipe/search');
                            },
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
          // navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoAnimationPage(child: const HomeScreen());
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
                routes: <RouteBase>[
                  GoRoute(
                    path: 'search',
                    pageBuilder: (BuildContext context, GoRouterState state) =>
                        CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const SearchScreen(),
                      transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) =>
                          SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        )
                            .chain(CurveTween(curve: Curves.easeIn))
                            .animate(animation),
                        child: child,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'calendar',
                    pageBuilder: (BuildContext context, GoRouterState state) =>
                        CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const CalendarScreen(),
                      transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) =>
                          SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        )
                            .chain(CurveTween(curve: Curves.easeIn))
                            .animate(animation),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Create Post
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/createpost',
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
          // Notification
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/notifications',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return NoAnimationPage(child: const NotificationsScreen());
                },
                routes: <RouteBase>[
                  GoRoute(
                    path: 'message',
                    pageBuilder: (BuildContext context, GoRouterState state) =>
                        CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: const MessageScreen(),
                      transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) =>
                          SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        )
                            .chain(CurveTween(curve: Curves.easeIn))
                            .animate(animation),
                        child: child,
                      ),
                    ),
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
                builder: (BuildContext context, GoRouterState state) =>
                    BlocProvider<ProfileBloc>(
                  create: (_) => ProfileBloc(
                    authBloc: context.read<AuthBloc>(),
                    userRepository: context.read<UserRepository>(),
                    postRepository: context.read<PostRepository>(),
                  )..add(
                      ProfileLoadUser(userId: authBloc.state.user!.uid),
                    ),
                  child:  ProfileScreen(),
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'settings',
                    pageBuilder: (BuildContext context, GoRouterState state) =>
                        CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: BlocProvider<LoginCubit>(
                        create: (context) => LoginCubit(
                            authRepository: context.read<AuthRepository>()),
                        child: const SettingsScreen(),
                      ),
                      transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) =>
                          SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        )
                            .chain(CurveTween(curve: Curves.easeIn))
                            .animate(animation),
                        child: child,
                      ),
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
