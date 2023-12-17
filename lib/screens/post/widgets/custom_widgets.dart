// ignore_for_file: use_build_context_synchronously

import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/add_post_to_collection/add_post_to_collection_cubit.dart';
import 'package:bootdv2/cubits/add_post_to_likes/add_post_to_likes_cubit.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/post/widgets/widgets.dart';
import 'package:bootdv2/screens/profile/bloc/mycollection/mycollection_bloc.dart';
import 'package:bootdv2/screens/profile/cubit/createcollection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextButton buildCreatenewcollection(BuildContext context,
    void Function(BuildContext) openCreateCollectionSheet) {
  return TextButton(
    onPressed: () => openCreateCollectionSheet(context),
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

TextButton buildValidateButton(
  BuildContext context,
  TextEditingController collectionNameController,
  ValueNotifier<bool> isPublicNotifier,
  String postId,
) {
  return TextButton(
    onPressed: () async {
      final String collectionName = collectionNameController.text.trim();
      final bool isPublic = isPublicNotifier.value;

      if (collectionName.isNotEmpty) {
        final authState = context.read<AuthBloc>().state;
        final userId = authState.user?.uid;
        if (userId != null) {
          String newCollectionId = await context
              .read<CreateCollectionCubit>()
              .createCollectionReturnCollectionId(
                  userId, collectionName, isPublic);

          if (newCollectionId.isNotEmpty) {
            await context
                .read<AddPostToCollectionCubit>()
                .addPostToCollection(postId, newCollectionId);

            Navigator.pop(context);
          } else {
            debugPrint('Error: Collection creation failed');
          }
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
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
    ),
  );
}

Widget buildPublicButton(
  BuildContext context,
  bool isPublic,
  ValueNotifier<bool> isPublicNotifier,
) {
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

Widget buildCaptionInput(
  BuildContext context,
  TextEditingController collectionNameController,
) {
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
          controller: collectionNameController,
          cursorColor: couleurBleuClair2,
          style: AppTextStyles.bodyStyle(context),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: AppTextStyles.subtitleLargeGrey(context),
            hintText:
                AppLocalizations.of(context)!.translate('enternamecollection'),
          ),
          validator: (value) => value!.trim().isEmpty
              ? AppLocalizations.of(context)!.translate('captionnotempty')
              : null,
        ),
      ),
    ],
  );
}

Widget buildBookmarkIcon(
  BuildContext context,
  String postId,
) {
  final authState = context.read<AuthBloc>().state;
  final userId = authState.user?.uid;
  final cubit = context.read<AddPostToLikesCubit>();

  return IconButton(
    icon: const Icon(Icons.bookmark, color: Colors.black, size: 32),
    onPressed: () async {
      bool isLiked = await cubit.isPostLiked(postId, userId!);

      if (isLiked) {
        await cubit.deletePostRefFromLikes(postId: postId, userId: userId);
      }

      Navigator.pop(context);
    },
  );
}

Widget buildIconButton(IconData icon, VoidCallback onPressed) {
  return IconButton(
    icon: Icon(icon, color: Colors.black, size: 24),
    onPressed: onPressed,
  );
}

Widget buildActionIcons(
    MyCollectionState state,
    BuildContext context,
    void Function(BuildContext) showBottomSheet,
    void Function(BuildContext) navigateToCommentScreen,
    void Function(MyCollectionState) addToLikesThenShowCollections,
    String postId,
    Animation<double> animation,
    AnimationController controller) {
  final authState = context.read<AuthBloc>().state;
  final _userId = authState.user?.uid;
  return Column(
    children: [
      buildIconButton(Icons.more_vert, () => showBottomSheet(context)),
      buildIconButton(Icons.comment, () => navigateToCommentScreen(context)),
      buildIconButton(Icons.share, () => showBottomSheet(context)),
      buildIconButton(
          Icons.add_to_photos, () => addToLikesThenShowCollections(state)),
      buildFavoriteButton(context, postId, _userId!, animation, controller),
    ],
  );
}

Widget buildFavoriteButton(BuildContext context, String postId, String userId,
    Animation<double> animation, AnimationController controller) {
  return BlocBuilder<AddPostToLikesCubit, AddPostToLikesState>(
    builder: (context, state) {
      final cubit = context.read<AddPostToLikesCubit>();

      return FutureBuilder<bool>(
        future: cubit.isPostLiked(postId, userId),
        builder: (context, snapshot) {
          bool isLiked = snapshot.data ?? false;

          return ScaleTransition(
            scale: animation,
            child: IconButton(
              icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.black, size: 24),
              onPressed: () async {
                controller.forward(from: 0.0);
                if (isLiked) {
                  await cubit.deletePostRefFromLikes(
                      postId: postId, userId: userId);
                } else {
                  await cubit.addPostToLikes(postId, userId);
                }
              },
            ),
          );
        },
      );
    },
  );
}

Widget buildUserProfile(
  User user,
  Post post,
  VoidCallback onTitleTap,
) {
  return ProfileImagePost(
    title: '${user.firstName} ${user.lastName}',
    likes: post.likes,
    profileImageProvider: user.profileImageProvider,
    description: post.caption,
    tags: post.tags,
    onTitleTap: onTitleTap,
  );
}
