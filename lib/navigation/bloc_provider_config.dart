import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/repositories/repositories.dart';

class BlocProviderConfig {
  static MultiBlocProvider getHomeMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedOOTDBloc>(
          create: (context) {
            final feedOOTDBloc = FeedOOTDBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
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
      child: child,
    );
  }

  static MultiBlocProvider getProfileMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
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
      child: child,
    );
  }

  static BlocProvider getFeedCollectionBlocProvider(
      BuildContext context, Widget child) {
    return BlocProvider<FeedCollectionBloc>(
      create: (context) {
        final feedCollectionBloc = FeedCollectionBloc(
          feedRepository: context.read<FeedRepository>(),
          authBloc: context.read<AuthBloc>(),
        );
        return feedCollectionBloc;
      },
      child: child,
    );
  }

  static BlocProvider getFeedEventBlocProvider(
      BuildContext context, Widget child) {
    return BlocProvider<FeedEventBloc>(
      create: (context) {
        final feedEventBloc = FeedEventBloc(
          eventRepository: context.read<EventRepository>(),
          feedRepository: context.read<FeedRepository>(),
          authBloc: context.read<AuthBloc>(),
        );
        return feedEventBloc;
      },
      child: child,
    );
  }
}
