import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/add_post_to_collection/add_post_to_collection_cubit.dart';
import 'package:bootdv2/cubits/add_post_to_likes/add_post_to_likes_cubit.dart';
import 'package:bootdv2/cubits/recent_post_image_url/recent_post_image_url_cubit.dart';
import 'package:bootdv2/cubits/update_public_status/update_public_status_cubit.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/cubits/delete_collections/delete_collections_cubit.dart';
import 'package:bootdv2/firebase_options.dart';
import 'package:bootdv2/navigation/router.dart';
import 'package:bootdv2/repositories/post/post_create_repository.dart';
import 'package:bootdv2/repositories/post/post_delete_repository.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/restart_app.dart';
import 'package:bootdv2/screens/comment/bloc/comments_event/comments_event_bloc.dart';
import 'package:bootdv2/screens/comment/bloc/comments_post/comments_bloc.dart';
import 'package:bootdv2/screens/event/bloc/event_bloc.dart';
import 'package:bootdv2/screens/follow_users/followers_users/followers_users_cubit.dart';
import 'package:bootdv2/screens/follow_users/following_users/following_users_cubit.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/feed_mylikes/feed_mylikes_bloc.dart';
import 'package:bootdv2/screens/profile/bloc/my_event/my_event_bloc.dart';
import 'package:bootdv2/screens/profile/cubit/createcollection_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('fr_FR', null);
  runApp(const RestartWidget(child: MyApp()));
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
        RepositoryProvider<PostCreateRepository>(
          create: (context) => PostCreateRepository(),
        ),
        RepositoryProvider<PostDeleteRepository>(
          create: (context) => PostDeleteRepository(),
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
        RepositoryProvider<SwipeRepository>(
          create: (context) => SwipeRepository(),
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
                DeletePostsCubit(context.read<PostDeleteRepository>()),
          ),
          BlocProvider<DeleteCollectionsCubit>(
            create: (context) =>
                DeleteCollectionsCubit(context.read<PostRepository>()),
          ),
          BlocProvider<CreateCollectionCubit>(
            create: (context) => CreateCollectionCubit(
              firebaseFirestore: FirebaseFirestore.instance,
              widgetName: 'CreateCollectionCubit',
            ),
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
          BlocProvider<CommentsEventBloc>(
            create: (context) => CommentsEventBloc(
              authBloc: context.read<AuthBloc>(),
              eventRepository: context.read<EventRepository>(),
            ),
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
          BlocProvider<UpdatePublicStatusCubit>(
            create: (context) => UpdatePublicStatusCubit(
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider<AddPostToCollectionCubit>(
            create: (context) => AddPostToCollectionCubit(
              firebaseFirestore: FirebaseFirestore.instance,
            ),
          ),
          BlocProvider<AddPostToLikesCubit>(
            create: (context) => AddPostToLikesCubit(
              firebaseFirestore: FirebaseFirestore.instance,
              postRepository: context.read<PostRepository>(),
            ),
          ),
          BlocProvider<FeedMyLikesBloc>(
            create: (context) {
              final feedMyLikesBloc = FeedMyLikesBloc(
                feedRepository: context.read<FeedRepository>(),
                authBloc: context.read<AuthBloc>(),
                postRepository: context.read<PostRepository>(),
              );
              feedMyLikesBloc.add(FeedMyLikesFetchPosts());
              return feedMyLikesBloc;
            },
          ),
          BlocProvider<RecentPostImageUrlCubit>(
            create: (context) => RecentPostImageUrlCubit(),
          ),
          BlocProvider<FollowersUsersCubit>(
            create: (context) => FollowersUsersCubit(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<FollowingUsersCubit>(
            create: (context) => FollowingUsersCubit(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) {
              final myEventBloc = MyEventBloc(
                eventRepository: context.read<EventRepository>(),
                authBloc: context.read<AuthBloc>(),
              );
              return myEventBloc;
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
