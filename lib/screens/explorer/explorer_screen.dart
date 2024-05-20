import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/explorer/bloc/explorer_bloc.dart';
import 'package:bootdv2/screens/explorer/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorerScreen extends StatefulWidget {
  ExplorerScreen({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen>
    with AutomaticKeepAliveClientMixin<ExplorerScreen> {
  late final String currentUserId;
  late final UserRepository _userRepository;
  late Future<User> _userDetailsFuture;

  @override
  void initState() {
    super.initState();
    context.read<ExplorerBloc>().add(ExplorerFetchPostsMan());
    context.read<ExplorerBloc>().add(ExplorerFetchPostsWoman());
    _userRepository = UserRepository();

    // Prépare le future pour récupérer les détails de l'utilisateur
    _userDetailsFuture = _userRepository
        .fetchUserDetails(context.read<AuthBloc>().state.user!.uid);
  }

  @override
  void dispose() {
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

  /*
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ExplorerBloc, ExplorerState>(
      listener: (context, state) {
        if (state.status == ExplorerStatus.initial && state.posts.isEmpty) {
          context.read<ExplorerBloc>().add(ExplorerFetchPosts());
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Scaffold(
            body: _buildBody(state),
          ),
        );
      },
    );
  }
  */

  Widget _buildGenderSpecificBloc(String? selectedGender) {
    if (selectedGender == "Masculin") {
      return BlocConsumer<ExplorerBloc, ExplorerState>(
        listener: (context, state) {
          context.read<ExplorerBloc>().add(ExplorerFetchPostsMan());
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
      return BlocConsumer<ExplorerBloc, ExplorerState>(
        listener: (context, state) {
          context.read<ExplorerBloc>().add(ExplorerFetchPostsWoman());
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

  Widget _buildBodyMasculin(ExplorerState state) {
    switch (state.status) {
      case ExplorerStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                context.read<ExplorerBloc>().add(ExplorerFetchPostsMan());
                context.read<LikedPostsCubit>().clearAllLikedPosts();
              },
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.5,
                ),
                physics: const BouncingScrollPhysics(),
                cacheExtent: 10000,
                itemCount: state.posts.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == state.posts.length) {
                    return state.status == ExplorerStatus.paginating
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
            ),
            if (state.status == ExplorerStatus.paginating)
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

  Widget _buildBodyFeminin(ExplorerState state) {
    switch (state.status) {
      case ExplorerStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                context.read<ExplorerBloc>().add(ExplorerFetchPostsWoman());
                context.read<LikedPostsCubit>().clearAllLikedPosts();
              },
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.5,
                ),
                physics: const BouncingScrollPhysics(),
                cacheExtent: 10000,
                itemCount: state.posts.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == state.posts.length) {
                    return state.status == ExplorerStatus.paginating
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
            ),
            if (state.status == ExplorerStatus.paginating)
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
