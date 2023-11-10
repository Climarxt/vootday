import 'package:bootdv2/config/paths.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/post_repository.dart';
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

  const PostEventScreen({
    super.key,
    required this.postId,
    required this.username,
    required this.title,
    required this.eventId,
  });

  @override
  State<PostEventScreen> createState() => _PostEventScreenState();
}

class _PostEventScreenState extends State<PostEventScreen>
    with AutomaticKeepAliveClientMixin {
  Post? _post;
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPost();
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
                        profileImageProvider: _user!.profileImageProvider,
                        description: _post!.caption,
                        tags: _post!.tags,
                        onTitleTap: () =>
                            _navigateToUserScreen(context, _user!),
                      ),
                      const Spacer(),
                      const Column(
                        children: [
                          SizedBox(height: 12),
                          Icon(Icons.more_vert, color: Colors.black, size: 24),
                          SizedBox(height: 32),
                          Icon(Icons.comment, color: Colors.black, size: 24),
                          SizedBox(height: 32),
                          Icon(Icons.share, color: Colors.black, size: 24),
                          SizedBox(height: 32),
                          Icon(Icons.add_to_photos,
                              color: Colors.black, size: 24),
                        ],
                      )
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
    final String encodedUsername = Uri.encodeComponent(user.username ?? '');
    final String encodedTitle = Uri.encodeComponent(widget.title ?? '');

    context.go(
      '/home/event/${widget.eventId}/post/${widget.postId}/user/${user.id}'
      '?username=$encodedUsername'
      '&title=$encodedTitle',
    );
  }

  @override
  bool get wantKeepAlive => true;
}
