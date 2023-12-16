import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/add_post_to_collection/add_post_to_collection_cubit.dart';
import 'package:bootdv2/cubits/cubits.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/post/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/cubit/createcollection_cubit.dart';

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
  List<String> _imageUrls = [];
  Map<String, bool> _postInCollectionMap = {};
  ValueNotifier<bool> isPublicNotifier = ValueNotifier(true);
  final TextEditingController _collectionNameController =
      TextEditingController();

  @override
  void initState() {
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

    final state = context.read<MyCollectionBloc>().state;
    final nonNullCollections = state.collections
        .where((collection) => collection != null)
        .cast<Collection>()
        .toList();
    _fetchImageUrls(nonNullCollections);
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
      listener: (context, state) {},
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
              _buildTopRow(context, size),
              _buildListView(scrollController, state),
            ],
          ),
        ),
      ),
    );

    print(result);
  }

  Widget _buildTopRow(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildImageContainer(size),
              const SizedBox(width: 14),
              _buildTextColumn(context),
              const Spacer(),
              _buildBookmarkIcon(),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            child: buildCreatenewcollection(context),
          ),
        ],
      ),
    );
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
          final imageUrl = index < _imageUrls.length
              ? _imageUrls[index]
              : 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';

          return ListTile(
            leading: _buildLeadingImage(imageUrl),
            title: Text(
              collection.title,
              style: AppTextStyles.titleHeadlineMidBlackBold(context),
            ),
            subtitle: Text(
              collection.public ? 'Public' : 'Privé',
              style: AppTextStyles.subtitleLargeGrey(context),
            ),
            trailing: FutureBuilder<Widget>(
              future: _buildTrailingIcon(collection.id),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return snapshot.data ?? SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  Future<Widget> _buildTrailingIcon(String collectionId) async {
    final postRepository = context.read<PostRepository>();
    bool isPostInCollection = await postRepository.isPostInCollection(
        postId: widget.postId, collectionId: collectionId);

    // Mise à jour de l'état
    _postInCollectionMap[collectionId] = isPostInCollection;

    return IconButton(
      icon: Icon(isPostInCollection ? Icons.check : Icons.add, color: greyDark),
      onPressed: () {
        if (isPostInCollection) {
          // Supprimer le post de la collection
          context.read<MyCollectionBloc>().add(MyCollectionDeletePostRef(
              postId: widget.postId, collectionId: collectionId));
        } else {
          // Ajouter le post à la collection
          context
              .read<AddPostToCollectionCubit>()
              .addPostToCollection(widget.postId, collectionId);
        }
        Navigator.pop(context);
      },
    );
  }

  Widget _buildLeadingImage(String imageUrl) {
    // Now this function can directly use imageUrl without FutureBuilder
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<String> getMostRecentPostImageUrl(String collectionId) async {
    // Add a debug print to confirm the method is called with a valid ID
    debugPrint(
        "getMostRecentPostImageUrl : Fetching image URL for collection ID: $collectionId");

    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection');

      final querySnapshot =
          await feedEventRef.orderBy('date', descending: true).limit(1).get();

      // Check if there are documents returned
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        final DocumentReference? postRef =
            data?['post_ref'] as DocumentReference?;

        if (postRef != null) {
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            final postData = postDoc.data() as Map<String, dynamic>?;
            final imageUrl = postData?['imageUrl'] as String? ?? '';
            // Print the image URL to verify it's the correct one
            debugPrint(
                "getMostRecentPostImageUrl : Found image URL: $imageUrl");
            return imageUrl;
          } else {
            debugPrint(
                "getMostRecentPostImageUrl : Referenced post document does not exist.");
          }
        } else {
          debugPrint("getMostRecentPostImageUrl : Post reference is null.");
        }
      } else {
        debugPrint(
            "getMostRecentPostImageUrl : No posts found in the collection's feed.");
      }
    } catch (e) {
      // Print any exceptions that occur
      debugPrint(
          "getMostRecentPostImageUrl : An error occurred while fetching the post image URL: $e");
    }
    // Return a default image URL if no image is found or an error occurs
    return 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';
  }

  Future<void> _fetchImageUrls(List<Collection> collections) async {
    // Fetch all image URLs
    List<String> urls = [];
    for (var collection in collections) {
      String imageUrl = await getMostRecentPostImageUrl(collection.id);
      urls.add(imageUrl);
    }

    // Check if the state is still mounted before updating
    if (mounted) {
      setState(() {
        _imageUrls = urls;
      });
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

  TextButton buildCreatenewcollection(BuildContext context) {
    return TextButton(
      onPressed: () => _openCreateCollectionSheet(context),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.add, color: black),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.translate('createnewcollection'),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: black),
            ),
          ),
          const Icon(Icons.arrow_forward, color: black),
        ],
      ),
    );
  }

  void _openCreateCollectionSheet(BuildContext context) {
    final createCollectionCubit = context.read<CreateCollectionCubit>();

    showModalBottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return BlocProvider.value(
          value: createCollectionCubit,
          child: BlocConsumer<CreateCollectionCubit, CreateCollectionState>(
            listener: (context, state) {
              if (state.status == CreateCollectionStatus.success) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.translate('newcollection'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    _buildCaptionInput(context),
                    ValueListenableBuilder<bool>(
                      valueListenable: isPublicNotifier,
                      builder: (context, isPublic, _) {
                        return _buildPublicButton(context, isPublic);
                      },
                    ),
                    const SizedBox(height: 18),
                    buildValidateButton(context, isPublicNotifier.value),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCaptionInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.translate('name'),
          style: AppTextStyles.titleLargeBlackBold(context),
        ),
        Form(
          child: TextFormField(
            controller: _collectionNameController,
            cursorColor: couleurBleuClair2,
            style: AppTextStyles.bodyStyle(context),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: AppTextStyles.subtitleLargeGrey(context),
              hintText: AppLocalizations.of(context)!
                  .translate('enternamecollection'),
            ),
            validator: (value) => value!.trim().isEmpty
                ? AppLocalizations.of(context)!.translate('captionnotempty')
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPublicButton(BuildContext context, bool isPublic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('makePublic'),
              style: AppTextStyles.titleLargeBlackBold(context),
            ),
            Switch(
              activeColor: couleurBleuClair2,
              value: isPublic,
              onChanged: (bool value) {
                debugPrint("Switch Changed: $value"); // Ajout de debugPrint
                isPublicNotifier.value = value;
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            AppLocalizations.of(context)!.translate('makePublicDescription'),
            style: AppTextStyles.bodyStyleGrey(context),
          ),
        ),
      ],
    );
  }

  TextButton buildValidateButton(BuildContext context, bool isPublic) {
    return TextButton(
      onPressed: () {
        final String collectionName = _collectionNameController.text.trim();
        final bool isPublic = isPublicNotifier.value;
        debugPrint("Collection Name: $collectionName"); // Ajout de debugPrint
        debugPrint("Is Public: $isPublic"); // Ajout de debugPrint

        if (collectionName.isNotEmpty) {
          final authState = context.read<AuthBloc>().state;
          final userId = authState.user?.uid;
          if (userId != null) {
            // widget.tabController.animateTo(0);
            context
                .read<CreateCollectionCubit>()
                .createCollection(userId, collectionName, isPublic);

            SnackbarUtil.showSuccessSnackbar(context, 'Collection Created !');
          } else {
            debugPrint('User ID is null');
          }
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        minimumSize: const Size(60, 20),
        backgroundColor: couleurBleuClair2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.translate('validate'),
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
