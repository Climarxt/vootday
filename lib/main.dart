import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/firebase_options.dart';
import 'package:bootdv2/navigation/router.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/calendar/bloc/coming_soon/calendar_coming_soon_bloc.dart';
import 'package:bootdv2/screens/calendar/bloc/latest/calendar_latest_bloc.dart';
import 'package:bootdv2/screens/calendar/bloc/this_week/calendar_this_week_bloc.dart';
import 'package:bootdv2/screens/comment/bloc/comments_bloc.dart';
import 'package:bootdv2/screens/event/bloc/event_bloc.dart';
import 'package:bootdv2/screens/explorer/bloc/explorer_bloc.dart';
import 'package:bootdv2/screens/following/bloc/following_bloc.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        RepositoryProvider<FeedRepository>(
          create: (context) => FeedRepository(),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(),
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
          BlocProvider<DeletePostsCubit>(
            create: (context) =>
                DeletePostsCubit(context.read<PostRepository>()),
          ),
          BlocProvider(
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
          BlocProvider(
            create: (context) {
              final feedEventBloc = FeedEventBloc(
                eventRepository: context.read<EventRepository>(),
                feedRepository: context.read<FeedRepository>(),
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
          BlocProvider(
            create: (context) {
              final latestEventBloc = CalendarLatestBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
              );
              return latestEventBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final thisWeekEventsBloc = CalendarThisWeekBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
              );
              return thisWeekEventsBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final thisComignSoonEventsBloc = CalendarComingSoonBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
              );
              return thisComignSoonEventsBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final eventBloc = EventBloc(
                eventRepository: context.read<EventRepository>(),
              );
              return eventBloc;
            },
          ),
          BlocProvider<CommentsBloc>(
            create: (context) => CommentsBloc(
              authBloc: context.read<AuthBloc>(),
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) {
              final followingBloc = FollowingBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
                likedPostsCubit: context.read<LikedPostsCubit>(),
              );
              return followingBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final explorerBloc = ExplorerBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
                likedPostsCubit: context.read<LikedPostsCubit>(),
              );
              return explorerBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final myCollectionBloc = MyCollectionBloc(
                authBloc: context.read<AuthBloc>(),
                postRepository: context.read<PostRepository>(),
              );
              return myCollectionBloc;
            },
          ),
          BlocProvider(
            create: (context) {
              final feedCollectionBloc = FeedCollectionBloc(
                postRepository: context.read<PostRepository>(),
                authBloc: context.read<AuthBloc>(),
                likedPostsCubit: context.read<LikedPostsCubit>(),
              );
              return feedCollectionBloc;
            },
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
