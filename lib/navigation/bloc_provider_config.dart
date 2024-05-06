import 'package:bootdv2/cubits/recent_post_image_url/recent_post_image_url_cubit.dart';
import 'package:bootdv2/screens/calendar/bloc/blocs.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/explorer/bloc/explorer_bloc.dart';
import 'package:bootdv2/screens/following/bloc/following_bloc.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_bloc.dart';
import 'package:bootdv2/screens/swipe/bloc/swipeevent/swipe_event_bloc.dart';
import 'package:bootdv2/screens/swipe/bloc/swipeootd/swipe_bloc.dart';
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
            feedOOTDBloc.add(FeedOOTDManFetchPostsOOTD());
            return feedOOTDBloc;
          },
        ),
        BlocProvider<FeedOOTDBloc>(
          create: (context) {
            final feedOOTDBloc = FeedOOTDBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            feedOOTDBloc.add(FeedOOTDFemaleFetchPostsOOTD());
            return feedOOTDBloc;
          },
        ),
        BlocProvider<FeedMonthBloc>(
          create: (context) {
            final feedMonthBloc = FeedMonthBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            feedMonthBloc.add(FeedMonthManFetchPostsMonth());
            return feedMonthBloc;
          },
        ),
        BlocProvider<FeedMonthBloc>(
          create: (context) {
            final feedMonthBloc = FeedMonthBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            feedMonthBloc.add(FeedMonthFemaleFetchPostsMonth());
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

  static MultiBlocProvider getCalendarMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarLatestBloc>(
          create: (context) {
            final latestEventBloc = CalendarLatestBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return latestEventBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final thisWeekEventsBloc = CalendarThisWeekBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return thisWeekEventsBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final thisComignSoonEventsBloc = CalendarComingSoonBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return thisComignSoonEventsBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getSwipeMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SwipeBloc>(
          create: (context) {
            final swipeBloc = SwipeBloc(
              swipeRepository: context.read<SwipeRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return swipeBloc;
          },
        ),
        BlocProvider<SwipeEventBloc>(
          create: (context) {
            final swipeEventBloc = SwipeEventBloc(
              swipeRepository: context.read<SwipeRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return swipeEventBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getFollowingExplorerMultiBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
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
      child: child,
    );
  }

  static MultiBlocProvider getMyProfileMultiBlocProvider(
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
        BlocProvider<MyCollectionBloc>(
          create: (context) => MyCollectionBloc(
            authBloc: context.read<AuthBloc>(),
            postRepository: context.read<PostRepository>(),
          ),
        ),
        BlocProvider<RecentPostImageUrlCubit>(
          create: (context) => RecentPostImageUrlCubit(),
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

  static MultiBlocProvider getFeedCollectionBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedCollectionBloc>(
          create: (context) {
            final feedCollectionBloc = FeedCollectionBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return feedCollectionBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getFeedEventBlocProvider(
      BuildContext context, Widget child) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedEventBloc>(
          create: (context) {
            final feedEventBloc = FeedEventBloc(
              eventRepository: context.read<EventRepository>(),
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            return feedEventBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static BlocProvider getCreatePostBlocProvider(
      BuildContext context, Widget child) {
    return BlocProvider<CreatePostCubit>(
      create: (context) {
        final createPostBloc = CreatePostCubit(
          postRepository: context.read<PostRepository>(),
          eventRepository: context.read<EventRepository>(),
          storageRepository: context.read<StorageRepository>(),
          authBloc: context.read<AuthBloc>(),
        );
        return createPostBloc;
      },
      child: child,
    );
  }
}
