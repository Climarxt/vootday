import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/cubits/recent_post_image_url/recent_post_image_url_cubit.dart';
import 'package:bootdv2/repositories/collection/collection_repository.dart';
import 'package:bootdv2/repositories/post/post_create_repository.dart';
import 'package:bootdv2/repositories/post/post_delete_repository.dart';
import 'package:bootdv2/repositories/post/post_fetch_repository.dart';
import 'package:bootdv2/screens/calendar/bloc/blocs.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/screens/explorer/bloc/explorer_bloc.dart';
import 'package:bootdv2/screens/following/bloc/following_bloc.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/bloc/feed_collection/feed_collection_bloc.dart';
import 'package:bootdv2/screens/profile_edit/cubit/edit_profile_cubit.dart';
import 'package:bootdv2/screens/swipe/bloc/swipeevent/swipe_event_bloc.dart';
import 'package:bootdv2/screens/swipe/bloc/swipeootd/swipe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/repositories/repositories.dart';

class BlocProviderConfig {
  static MultiBlocProvider getHomeMultiBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getHomeMultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedOOTDBloc>(
          create: (context) {
            final feedOOTDBloc = FeedOOTDBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            feedOOTDBloc.add(FeedOOTDManFetchPostsByCity());
            feedOOTDBloc.add(FeedOOTDManFetchPostsByState());
            feedOOTDBloc.add(FeedOOTDManFetchPostsByCountry());
            logger.logInfo('FeedOOTDBloc.create',
                'Initialized and added FeedOOTDManFetchPostsOOTD event', {
              'feedRepository': context.read<FeedRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
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
            logger.logInfo('FeedOOTDBloc.create',
                'Initialized and added FeedOOTDFemaleFetchPostsOOTD event', {
              'feedRepository': context.read<FeedRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
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
            logger.logInfo('FeedMonthBloc.create',
                'Initialized and added FeedMonthManFetchPostsMonth event', {
              'feedRepository': context.read<FeedRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
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
            logger.logInfo('FeedMonthBloc.create',
                'Initialized and added FeedMonthFemaleFetchPostsMonth event', {
              'feedRepository': context.read<FeedRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return feedMonthBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final homeEventBloc = HomeEventBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger
                .logInfo('HomeEventBloc.create', 'Initialized HomeEventBloc', {
              'eventRepository': context.read<EventRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return homeEventBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getCalendarMultiBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getCalendarMultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarLatestBloc>(
          create: (context) {
            final latestEventBloc = CalendarLatestBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger.logInfo(
                'CalendarLatestBloc.create', 'Initialized CalendarLatestBloc', {
              'eventRepository': context.read<EventRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return latestEventBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final thisWeekEventsBloc = CalendarThisWeekBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger.logInfo('CalendarThisWeekBloc.create',
                'Initialized CalendarThisWeekBloc', {
              'eventRepository': context.read<EventRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return thisWeekEventsBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            final thisComignSoonEventsBloc = CalendarComingSoonBloc(
              eventRepository: context.read<EventRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger.logInfo('CalendarComingSoonBloc.create',
                'Initialized CalendarComingSoonBloc', {
              'eventRepository': context.read<EventRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return thisComignSoonEventsBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getSwipeMultiBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getSwipeMultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<SwipeBloc>(
          create: (context) {
            final swipeBloc = SwipeBloc(
              swipeRepository: context.read<SwipeRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger.logInfo('SwipeBloc.create', 'Initialized SwipeBloc', {
              'swipeRepository': context.read<SwipeRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return swipeBloc;
          },
        ),
        BlocProvider<SwipeEventBloc>(
          create: (context) {
            final swipeEventBloc = SwipeEventBloc(
              swipeRepository: context.read<SwipeRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger.logInfo(
                'SwipeEventBloc.create', 'Initialized SwipeEventBloc', {
              'swipeRepository': context.read<SwipeRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return swipeEventBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getFollowingExplorerMultiBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger = ContextualLogger(
        'BlocProviderConfig.getFollowingExplorerMultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<FollowingBloc>(
          create: (context) {
            final followingBloc = FollowingBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger
                .logInfo('FollowingBloc.create', 'Initialized FollowingBloc', {
              'feedRepository': context.read<FeedRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return followingBloc;
          },
        ),
        BlocProvider<ExplorerBloc>(
          create: (context) {
            final explorerBloc = ExplorerBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger.logInfo('ExplorerBloc.create', 'Initialized ExplorerBloc', {
              'feedRepository': context.read<FeedRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return explorerBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getMyProfileMultiBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getMyProfileMultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) {
            final profileBloc = ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
              postRepository: context.read<PostRepository>(),
              postDeleteRepository: context.read<PostDeleteRepository>(),
              postFetchRepository: context.read<PostFetchRepository>(),
            );
            logger.logInfo('ProfileBloc.create', 'Initialized ProfileBloc', {
              'authBloc': context.read<AuthBloc>().toString(),
              'userRepository': context.read<UserRepository>().toString(),
              'postRepository': context.read<PostRepository>().toString(),
              'postDeleteRepository':
                  context.read<PostDeleteRepository>().toString(),
            });
            return profileBloc;
          },
        ),
        BlocProvider<MyCollectionBloc>(
          create: (context) {
            final myCollectionBloc = MyCollectionBloc(
              authBloc: context.read<AuthBloc>(),
              collectionRepository: context.read<CollectionRepository>(),
            );
            logger.logInfo(
                'MyCollectionBloc.create', 'Initialized MyCollectionBloc', {
              'authBloc': context.read<AuthBloc>().toString(),
              'postRepository': context.read<PostRepository>().toString(),
            });
            return myCollectionBloc;
          },
        ),
        BlocProvider<RecentPostImageUrlCubit>(
          create: (context) {
            final recentPostImageUrlCubit = RecentPostImageUrlCubit();
            logger.logInfo('RecentPostImageUrlCubit.create',
                'Initialized RecentPostImageUrlCubit');
            return recentPostImageUrlCubit;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getProfileMultiBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getProfileMultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) {
            final profileBloc = ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
              postRepository: context.read<PostRepository>(),
              postDeleteRepository: context.read<PostDeleteRepository>(),
              postFetchRepository: context.read<PostFetchRepository>(),
            );
            logger.logInfo('ProfileBloc.create', 'Initialized ProfileBloc', {
              'authBloc': context.read<AuthBloc>().toString(),
              'userRepository': context.read<UserRepository>().toString(),
              'postRepository': context.read<PostRepository>().toString(),
              'postDeleteRepository':
                  context.read<PostDeleteRepository>().toString(),
            });
            return profileBloc;
          },
        ),
        BlocProvider<YourCollectionBloc>(
          create: (context) {
            final yourCollectionBloc = YourCollectionBloc(
              collectionRepository: context.read<CollectionRepository>(),
            );
            logger.logInfo(
                'YourCollectionBloc.create', 'Initialized YourCollectionBloc', {
              'postRepository': context.read<CollectionRepository>().toString(),
            });
            return yourCollectionBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getFeedCollectionBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getFeedCollectionBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedCollectionBloc>(
          create: (context) {
            final feedCollectionBloc = FeedCollectionBloc(
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger.logInfo(
                'FeedCollectionBloc.create', 'Initialized FeedCollectionBloc', {
              'feedRepository': context.read<FeedRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return feedCollectionBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getFeedEventBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getFeedEventBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedEventBloc>(
          create: (context) {
            final feedEventBloc = FeedEventBloc(
              eventRepository: context.read<EventRepository>(),
              feedRepository: context.read<FeedRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger
                .logInfo('FeedEventBloc.create', 'Initialized FeedEventBloc', {
              'eventRepository': context.read<EventRepository>().toString(),
              'feedRepository': context.read<FeedRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return feedEventBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static MultiBlocProvider getCreatePostMultiBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getCreatePostMultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) {
            final profileBloc = ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
              postRepository: context.read<PostRepository>(),
              postDeleteRepository: context.read<PostDeleteRepository>(),
              postFetchRepository: context.read<PostFetchRepository>(),
            );
            logger.logInfo('ProfileBloc.create', 'Initialized ProfileBloc', {
              'authBloc': context.read<AuthBloc>().toString(),
              'userRepository': context.read<UserRepository>().toString(),
              'postRepository': context.read<PostRepository>().toString(),
              'postDeleteRepository':
                  context.read<PostDeleteRepository>().toString(),
            });
            return profileBloc;
          },
        ),
        BlocProvider<CreatePostCubit>(
          create: (context) {
            final createPostBloc = CreatePostCubit(
              postCreateRepository: context.read<PostCreateRepository>(),
              eventRepository: context.read<EventRepository>(),
              storageRepository: context.read<StorageRepository>(),
              userRepository: context.read<UserRepository>(),
              authBloc: context.read<AuthBloc>(),
            );
            logger.logInfo(
                'CreatePostCubit.create', 'Initialized CreatePostCubit', {
              'postRepository': context.read<PostRepository>().toString(),
              'eventRepository': context.read<EventRepository>().toString(),
              'storageRepository': context.read<StorageRepository>().toString(),
              'userRepository': context.read<UserRepository>().toString(),
              'authBloc': context.read<AuthBloc>().toString(),
            });
            return createPostBloc;
          },
        ),
      ],
      child: child,
    );
  }

  static BlocProvider getEditProfileBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getEditProfileBlocProvider');

    return BlocProvider<EditProfileCubit>(
      create: (context) {
        final editProfileCubit = EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: context.read<ProfileBloc>(),
        );
        logger.logInfo(
            'EditProfileCubit.create', 'Initialized EditProfileCubit', {
          'userRepository': context.read<UserRepository>().toString(),
          'storageRepository': context.read<StorageRepository>().toString(),
          'profileBloc': context.read<ProfileBloc>().toString(),
        });
        return editProfileCubit;
      },
      child: child,
    );
  }

  static MultiBlocProvider getEditProfileMultiBlocProvider(
      BuildContext context, Widget child) {
    final ContextualLogger logger =
        ContextualLogger('BlocProviderConfig.getEditProfileMultiBlocProvider');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) {
            final profileBloc = ProfileBloc(
              authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
              postRepository: context.read<PostRepository>(),
              postDeleteRepository: context.read<PostDeleteRepository>(),
              postFetchRepository: context.read<PostFetchRepository>(),
            );
            logger.logInfo('ProfileBloc.create', 'Initialized ProfileBloc', {
              'authBloc': context.read<AuthBloc>().toString(),
              'userRepository': context.read<UserRepository>().toString(),
              'postRepository': context.read<PostRepository>().toString(),
              'postDeleteRepository':
                  context.read<PostDeleteRepository>().toString(),
            });
            return profileBloc;
          },
        ),
        BlocProvider<EditProfileCubit>(
          create: (context) {
            final editProfileCubit = EditProfileCubit(
              userRepository: context.read<UserRepository>(),
              storageRepository: context.read<StorageRepository>(),
              profileBloc: context.read<ProfileBloc>(),
            );
            logger.logInfo(
                'EditProfileCubit.create', 'Initialized EditProfileCubit', {
              'userRepository': context.read<UserRepository>().toString(),
              'storageRepository': context.read<StorageRepository>().toString(),
              'profileBloc': context.read<ProfileBloc>().toString(),
            });
            return editProfileCubit;
          },
        ),
      ],
      child: child,
    );
  }
}
