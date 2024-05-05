// ignore_for_file: avoid_print
import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/user/user_repository.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_bloc.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedOOTD extends StatefulWidget {
  FeedOOTD({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _FeedOOTDState createState() => _FeedOOTDState();
}

class _FeedOOTDState extends State<FeedOOTD>
    with AutomaticKeepAliveClientMixin<FeedOOTD> {
  final TextEditingController _textController = TextEditingController();
  late final String currentUserId;
  late final UserRepository _userRepository;
  late Future<User> _userDetailsFuture;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();

    // Prépare le future pour récupérer les détails de l'utilisateur
    _userDetailsFuture = _userRepository
        .fetchUserDetails(context.read<AuthBloc>().state.user!.uid);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder<User>(
      future: _userDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(child: Text("Error: ${snapshot.error}")));
          }
          if (snapshot.hasData) {
            String? selectedGender = snapshot.data!.selectedGender;
            return _buildGenderSpecificBloc(selectedGender);
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildGenderSpecificBloc(String? selectedGender) {
    debugPrint("DEBUG PRINT : $selectedGender");
    if (selectedGender == "Masculin") {
      debugPrint("Executing Masculin code");
      return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
        listener: (context, state) {
          debugPrint(
              "DEBUG PRINT : Déclenchement de FeedOOTDManFetchPostsOOTD");
          context.read<FeedOOTDBloc>().add(FeedOOTDManFetchPostsOOTD());
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyMasculin(state),
            ),
          );
        },
      );
    } else if (selectedGender == "Féminin") {
      debugPrint("Executing Féminin code");
      return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
        listener: (context, state) {
          debugPrint(
              "DEBUG PRINT : Déclenchement de FeedOOTDFemaleFetchPostsOOTD");
          context.read<FeedOOTDBloc>().add(FeedOOTDFemaleFetchPostsOOTD());
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyFeminin(state),
            ),
          );
        },
      );
    } else {
      debugPrint("Executing fallback code");
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildBodyMasculin(FeedOOTDState state) {
    switch (state.status) {
      case FeedOOTDStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              cacheExtent: 10000,
              itemCount: state.posts.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                if (index == state.posts.length) {
                  return state.status == FeedOOTDStatus.paginating
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                } else {
                  final Post post = state.posts[index] ?? Post.empty;
                  return PostView(
                    post: post,
                  );
                }
              },
            ),
            if (state.status == FeedOOTDStatus.paginating)
              const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
    }
  }

  Widget _buildBodyFeminin(FeedOOTDState state) {
    switch (state.status) {
      case FeedOOTDStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              cacheExtent: 10000,
              itemCount: state.posts.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                if (index == state.posts.length) {
                  return state.status == FeedOOTDStatus.paginating
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                } else {
                  final Post post = state.posts[index] ?? Post.empty;
                  return PostView(
                    post: post,
                  );
                }
              },
            ),
            if (state.status == FeedOOTDStatus.paginating)
              const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
    }
  }

// Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
