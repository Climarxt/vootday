import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/repositories/repositories.dart';

class MultiBlocProviderHome {
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

  // Vous pouvez ajouter d'autres méthodes pour d'autres écrans ou configurations
}
