// ignore_for_file: use_build_context_synchronously

import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/add_post_to_collection/add_post_to_collection_cubit.dart';
import 'package:bootdv2/cubits/add_post_to_likes/add_post_to_likes_cubit.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/collection/collection_repository.dart';
import 'package:bootdv2/screens/profile/bloc/mycollection/mycollection_bloc.dart';
import 'package:bootdv2/screens/profile/cubit/createcollection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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
                .addPostToCollection(postId, newCollectionId, userId);

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
  String userIdfromPost,
) {
  final authState = context.read<AuthBloc>().state;
  final userIdfromAuth = authState.user?.uid;
  final cubit = context.read<AddPostToLikesCubit>();

  return IconButton(
    icon: const Icon(Icons.bookmark, color: Colors.black, size: 32),
    onPressed: () async {
      bool isLiked =
          await cubit.isPostLiked(postId, userIdfromPost, userIdfromAuth!);

      if (isLiked) {
        await cubit.deletePostRefFromLikes(
            postId: postId,
            userIdfromPost: userIdfromPost,
            userIdfromAuth: userIdfromAuth);
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

Future<Widget> buildTrailingIcon(
    BuildContext context,
    String collectionId,
    String userIdfromPost,
    String postId,
    Map<String, bool> postInCollectionMap) async {
  final collectionRepository = context.read<CollectionRepository>();
  bool isPostInCollection = await collectionRepository.isPostInCollection(
      postId: postId,
      collectionId: collectionId,
      userIdfromPost: userIdfromPost);

  // Mise à jour de l'état
  postInCollectionMap[collectionId] = isPostInCollection;

  return IconButton(
    icon: Icon(isPostInCollection ? Icons.check : Icons.add, color: greyDark),
    onPressed: () {
      if (isPostInCollection) {
        // Supprimer le post de la collection
        context.read<MyCollectionBloc>().add(MyCollectionDeletePostRef(
              postId: postId,
              collectionId: collectionId,
              userIdfromPost: userIdfromPost,
            ));
      } else {
        final authState = context.read<AuthBloc>().state;
        final userId = authState.user?.uid;
        // Ajouter le post à la collection
        context
            .read<AddPostToCollectionCubit>()
            .addPostToCollection(postId, collectionId, userId!);
      }
      Navigator.pop(context);
    },
  );
}

Widget buildListView(
  ScrollController scrollController,
  MyCollectionState state,
  List<String> imageUrls,
  String postId,
  String userIdfromPost,
  Map<String, bool> postInCollectionMap,
) {
  return Expanded(
    child: ListView.separated(
      padding: EdgeInsets.zero,
      controller: scrollController,
      itemCount: state.collections.length,
      separatorBuilder: (context, index) => const Divider(color: greyDark),
      itemBuilder: (BuildContext context, int index) {
        final collection = state.collections[index] ?? Collection.empty;
        final imageUrl = index < imageUrls.length
            ? imageUrls[index]
            : 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';

        return ListTile(
          leading: buildLeadingImage(imageUrl),
          title: Text(
            collection.title,
            style: AppTextStyles.titleHeadlineMidBlackBold(context),
          ),
          subtitle: Text(
            collection.public ? 'Public' : 'Privé',
            style: AppTextStyles.subtitleLargeGrey(context),
          ),
          trailing: FutureBuilder<Widget>(
            future: buildTrailingIcon(
              context,
              collection.id,
              userIdfromPost,
              postId,
              postInCollectionMap,
            ),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              return snapshot.data ?? const SizedBox.shrink();
            },
          ),
        );
      },
    ),
  );
}

Widget buildLeadingImage(String imageUrl) {
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

Container buildImageContainer(
  Size size,
  Post post,
) {
  const double imageContainerFractionWidth = 0.2;
  const double imageContainerFractionHeight = 0.15;

  return Container(
    width: size.width * imageContainerFractionWidth,
    height: size.height * imageContainerFractionHeight,
    decoration: BoxDecoration(
      color: greyDark,
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: post.imageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Column buildTextColumn(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Enregistré dans mes Likes',
        style: AppTextStyles.titleHeadlineMidBlackBold(context),
      ),
      Text(
        'Privé',
        style: AppTextStyles.subtitleLargeGrey(context),
      ),
    ],
  );
}

Widget buildTopRow(BuildContext context, Size size, Post post,
    void Function(BuildContext) openCreateCollectionSheet) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 7),
    child: Column(
      children: [
        Row(
          children: [
            buildImageContainer(size, post),
            const SizedBox(width: 14),
            buildTextColumn(context),
            const Spacer(),
            buildBookmarkIcon(context, post.id!, post.author.id),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          child: buildCreatenewcollection(context, openCreateCollectionSheet),
        ),
      ],
    ),
  );
}

EdgeInsets swiperPaddingLeft() => const EdgeInsets.only(
      left: 0,
      right: 7.5,
      bottom: 7.5,
      top: 0,
    );

EdgeInsets swiperPaddingRight() => const EdgeInsets.only(
      left: 7.5,
      right: 0,
      bottom: 7.5,
      top: 0,
    );

AllowedSwipeDirection allowedSwipeDirection() =>
    const AllowedSwipeDirection.only(
        up: true, left: false, down: true, right: false);
