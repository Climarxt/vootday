import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/blocs/simple_bloc_observer.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/repositories/brand/brand_repository.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/firebase_options.dart';
import 'package:bootdv2/screens/home/bloc/feed_event/feed_event_bloc.dart';
import 'package:bootdv2/screens/home/bloc/home_event/home_event_bloc.dart';
import 'package:bootdv2/screens/home/bloc/month/feed_month_bloc.dart';
import 'package:bootdv2/screens/home/bloc/ootd/feed_ootd_bloc.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'navigation/router.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('fr_FR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false));
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => PostRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) => StorageRepository(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (context) => NotificationRepository(),
        ),
        RepositoryProvider<BrandRepository>(
          create: (context) => BrandRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<LikedPostsCubit>(
            create: (context) => LikedPostsCubit(
              postRepository: context.read<PostRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) {
              final feedOOTDBloc = FeedOOTDBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
                likedPostsCubit: context.read<LikedPostsCubit>(),
              );
              feedOOTDBloc.add(FeedOOTDFetchPostsOOTD());
              return feedOOTDBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final feedMonthBloc = FeedMonthBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
                likedPostsCubit: context.read<LikedPostsCubit>(),
              );
              feedMonthBloc.add(FeedMonthFetchPostsMonth());
              return feedMonthBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final feedEventBloc = FeedEventBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
                likedPostsCubit: context.read<LikedPostsCubit>(),
              );
              return feedEventBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final homeEventBloc = HomeEventBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
              );
              return homeEventBloc;
            },
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
              postRepository: context.read<PostRepository>(),
            ),
          ),
        ],
        child: Builder(
          builder: (context) => MaterialApp.router(
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('fr', ''),
            ],
            locale: const Locale('fr', ''), // Force la localisation française ,
            title: 'VOOTDAY',
            theme: theme(),
            routerConfig: createRouter(context),
          ),
        ),
      ),
    );
  }
}
