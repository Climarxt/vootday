import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/blocs/simple_bloc_observer.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:bootdv2/repositories/brand/brand_repository.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/firebase_options.dart';
import 'package:bootdv2/screens/home/bloc/ootd/feed_ootd_bloc.dart';
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
              final feedBloc = FeedOOTDBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
                likedPostsCubit: context.read<LikedPostsCubit>(),
              );
              feedBloc.add(FeedOOTDFetchPostsOOTD());
              return feedBloc;
            },
          )
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
