import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/paths.dart';
import 'package:bootdv2/cubits/delete_posts/delete_posts_cubit.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/post_repository.dart';
import 'package:bootdv2/screens/createpost/widgets/widgets.dart';
import 'package:bootdv2/screens/post/widgets/image_loader.dart';
import 'package:bootdv2/widgets/appbar/appbar_title.dart';
import 'package:bootdv2/widgets/profileimagepost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostEventScreen extends StatefulWidget {
  final String postId;
  final String username;
  final String title;
  final String eventId;
  final String logoUrl;

  const PostEventScreen({
    super.key,
    required this.postId,
    required this.username,
    required this.title,
    required this.eventId,
    required this.logoUrl,
  });

  @override
  State<PostEventScreen> createState() => _PostEventScreenState();
}

class _PostEventScreenState extends State<PostEventScreen>
    with AutomaticKeepAliveClientMixin {
  Post? _post;
  User? _user;
  bool _isLoading = true;
  bool _isUserTheAuthor = false;

  @override
  void initState() {
    super.initState();
    _loadPost();
    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.uid;
    if (userId != null) {
      _checkIfUserIsAuthor(userId);
    } else {
      print('User ID is null');
    }
  }

  void _checkIfUserIsAuthor(String userId) async {
    try {
      DocumentSnapshot postDoc = await FirebaseFirestore.instance
          .collection(Paths.posts)
          .doc(widget.postId)
          .get();

      if (postDoc.exists) {
        var data = postDoc.data() as Map<String, dynamic>;
        DocumentReference authorRef = data['author'];
        if (authorRef.id == userId) {
          setState(() {
            _isUserTheAuthor = true;
          });
        }
      }
    } catch (e) {
      print('Erreur lors de la récupération du post: $e');
    }
  }

  Future<void> _loadPost() async {
    try {
      final post =
          await context.read<PostRepository>().getPostById(widget.postId);
      if (post != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection(Paths.users)
            .doc(post.author.id)
            .get();
        if (userDoc.exists) {
          setState(() {
            _post = post;
            _user = User.fromDocument(userDoc);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBarTitle(title: widget.username),
        body: const Center(
          child: Opacity(
            opacity: 0.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_post == null || _user == null) {
      return Scaffold(
        appBar: AppBarTitle(title: widget.username),
        body: const Center(child: Text('Post or user not found')),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBarTitle(title: widget.username),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageLoader(
                  imageProvider: _post!.imageProvider,
                  width: size.width,
                  height: size.height / 1.5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                    children: [
                      ProfileImagePost(
                        title: '${_user!.firstName} ${_user!.lastName}',
                        likes: _post!.likes,
                        profileImageProvider: _user!.profileImageProvider,
                        description: _post!.caption,
                        tags: _post!.tags,
                        onTitleTap: () =>
                            _navigateToUserScreen(context, _user!),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.black, size: 24),
                            onPressed: () => _showBottomSheet(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.comment,
                                color: Colors.black, size: 24),
                            onPressed: () => _showBottomSheet(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share,
                                color: Colors.black, size: 24),
                            onPressed: () => _showBottomSheet(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_to_photos,
                                color: Colors.black, size: 24),
                            onPressed: () => _showBottomSheet(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToUserScreen(BuildContext context, User user) {
    final String encodedUsername = Uri.encodeComponent(user.username);
    final String encodedTitle = Uri.encodeComponent(widget.title);
    final String encodedLogoUrl = Uri.encodeComponent(widget.logoUrl);

    context.push(
      '/home/event/${widget.eventId}/post/${widget.postId}/user/${user.id}'
      '?username=$encodedUsername'
      '&title=$encodedTitle'
      '&logoUrl=$encodedLogoUrl',
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            if (_isUserTheAuthor) // Affiche cette option seulement si l'utilisateur est l'auteur
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  final postCubit = context.read<DeletePostsCubit>();
                  postCubit.deletePosts(
                      widget.postId); // Assurez-vous d'avoir l'userId correct
                  GoRouter.of(context).go('/home');
                  SnackbarUtil.showSuccessSnackbar(context, 'Post Deleted !');
                },
              ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                // Implémentez votre logique de signalement ici
                Navigator.pop(context);
              },
            ),
            // Ajoutez d'autres options si nécessaire
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
