import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/post/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostScreen extends StatefulWidget {
  final String postId;

  final String fromPath;

  const PostScreen({
    super.key,
    required this.postId,
    required this.fromPath,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with AutomaticKeepAliveClientMixin {
  Post? _post;
  User? _user;
  bool _isLoading = true;
  bool _isUserTheAuthor = false;

  @override
  void initState() {
    debugPrint("DEBUG : fromPath = ${widget.fromPath}");
    super.initState();
    _loadPost();
    Future.delayed(Duration.zero, () {
      context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());
    });
    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.uid;
    if (userId != null) {
      _checkIfUserIsAuthor(userId);
    } else {
      debugPrint('User ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Opacity(
            opacity: 0.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_post == null || _user == null) {
      return Scaffold(
        appBar: AppBarTitle(title: _user!.username),
        body: const Center(child: Text('Post or user not found')),
      );
    }

    return BlocConsumer<MyCollectionBloc, MyCollectionState>(
      listener: (context, state) {
        if (state.status == MyCollectionStatus.initial &&
            state.collections.isEmpty) {
          context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBarTitle(title: _user!.username),
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPostImage(size),
                    _buildPostDetails(state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showBottomSheetCollection(
      BuildContext context, MyCollectionState state) async {
    final Size size = MediaQuery.of(context).size;

    int? result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, size),
              _buildListView(scrollController, state),
            ],
          ),
        ),
      ),
    );

    print(result);
  }

  Widget _buildListView(
      ScrollController scrollController, MyCollectionState state) {
    return Expanded(
      child: ListView.separated(
        controller: scrollController,
        itemCount: state.collections.length,
        separatorBuilder: (context, index) => Divider(color: greyDark),
        itemBuilder: (BuildContext context, int index) {
          final collection = state.collections[index] ?? Collection.empty;

          return ListTile(
            leading: _buildLeadingImage(collection),
            title: Text(
              collection.title,
              style: AppTextStyles.titleHeadlineMidBlackBold(context),
            ),
            subtitle: Text(
              collection.public ? 'Public' : 'Privé',
              style: AppTextStyles.subtitleLargeGrey(context),
            ),
            trailing: const Icon(Icons.add, color: greyDark),
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildLeadingImage(Collection collection) {
    if (collection == Collection.empty) {
      return const SizedBox(
        width: 60,
        height: 60,
        child: Placeholder(),
      );
    }

    return FutureBuilder<String>(
      future: getMostRecentPostImageUrl(collection.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No image available');
        }
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            image: DecorationImage(
              image: NetworkImage(snapshot.data!),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Future<String> getMostRecentPostImageUrl(String collectionId) async {
    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection');

      final querySnapshot =
          await feedEventRef.orderBy('date', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        final DocumentReference? postRef =
            data?['post_ref'] as DocumentReference?;

        if (postRef != null) {
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            final postData = postDoc.data() as Map<String, dynamic>?;
            debugPrint("Referenced post document exist.");
            return postData?['imageUrl'] as String? ?? '';
          } else {
            debugPrint("Referenced post document does not exist.");
          }
        } else {
          debugPrint("Post reference is null.");
        }
      } else {
        debugPrint("No posts found in the event's feed.");
      }
    } catch (e) {
      debugPrint(
          "An error occurred while fetching the most liked post image URL: $e");
    }
    return 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';
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

  Widget _buildPostImage(Size size) {
    return ImageLoader(
      imageProvider: _post!.imageProvider,
      width: size.width,
      height: size.height / 1.5,
    );
  }

  Widget _buildPostDetails(MyCollectionState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          _buildUserProfile(),
          const Spacer(),
          _buildActionIcons(state),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return ProfileImagePost(
      title: '${_user!.firstName} ${_user!.lastName}',
      likes: _post!.likes,
      profileImageProvider: _user!.profileImageProvider,
      description: _post!.caption,
      tags: _post!.tags,
      onTitleTap: () => _navigateToUserScreen(context, _user!),
    );
  }

  Widget _buildActionIcons(MyCollectionState state) {
    return Column(
      children: [
        _buildIconButton(Icons.more_vert, () => _showBottomSheet(context)),
        _buildIconButton(
            Icons.comment, () => _navigateToCommentScreen(context)),
        _buildIconButton(Icons.share, () => _showBottomSheet(context)),
        _buildIconButton(Icons.add_to_photos,
            () => _showBottomSheetCollection(context, state)),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.black, size: 24),
      onPressed: onPressed,
    );
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
      debugPrint('Erreur lors de la récupération du post: $e');
    }
  }

  void _navigateToUserScreen(BuildContext context, User user) {
    context.push('/user/${user.id}');
  }

  void _navigateToCommentScreen(BuildContext context) {
    context.push('/post/${widget.postId}/comment');
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            if (_isUserTheAuthor)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  final postCubit = context.read<DeletePostsCubit>();
                  postCubit.deletePosts(widget.postId);
                  if (widget.fromPath.contains("/calendar")) {
                    GoRouter.of(context).go('/calendar');
                  } else {
                    GoRouter.of(context).go('/profile');
                  }

                  SnackbarUtil.showSuccessSnackbar(context, 'Post Deleted !');
                },
              ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, Size size) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: _buildTopRow(context, size),
    );
  }

  Row _buildTopRow(BuildContext context, Size size) {
    return Row(
      children: [
        _buildImageContainer(size),
        const SizedBox(width: 14),
        _buildTextColumn(context),
        const Spacer(),
        _buildBookmarkIcon(),
      ],
    );
  }

  Container _buildImageContainer(Size size) {
    const double imageContainerFractionWidth = 0.2;
    const double imageContainerFractionHeight = 0.15;

    return Container(
      width: size.width * imageContainerFractionWidth,
      height: size.height * imageContainerFractionHeight,
      decoration: BoxDecoration(
        color: greyDark,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: _post!.imageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Column _buildTextColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enregistré',
          style: AppTextStyles.titleHeadlineMidBlackBold(context),
        ),
        Text(
          'Privé',
          style: AppTextStyles.subtitleLargeGrey(context),
        ),
      ],
    );
  }

  Icon _buildBookmarkIcon() {
    const black = Colors.black; // Example color
    return const Icon(Icons.bookmark, color: black, size: 32);
  }

  @override
  bool get wantKeepAlive => true;
}
