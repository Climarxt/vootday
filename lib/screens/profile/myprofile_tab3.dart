import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileTab3 extends StatefulWidget {
  const MyProfileTab3({super.key});

  @override
  State<MyProfileTab3> createState() => _MyProfileTab3State();
}

class _MyProfileTab3State extends State<MyProfileTab3> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCollectionBloc, MyCollectionState>(
      listener: (context, state) {
        if (state.status == MyCollectionStatus.initial &&
            state.collections.isEmpty) {
          context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());
        }
      },
      builder: (context, state) {
        return _buildBody(state);
      },
    );
  }

  Widget _buildBody(MyCollectionState state) {
    return Column(
      children: [
        Container(
          child: buildCreatenewcollection(context),
        ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 0.8,
              ),
              physics: const BouncingScrollPhysics(),
              cacheExtent: 10000,
              itemCount: state.collections.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == state.collections.length) {
                  return state.status == MyCollectionStatus.paginating
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                } else {
                  final collection =
                      state.collections[index] ?? Collection.empty;

                  return FutureBuilder<String>(
                    future: getMostRecentPostImageUrl(collection.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.transparent),
                        );
                      }
                      if (snapshot.hasError) {
                        // Handle the error state
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        // Handle the case where there is no image URL
                        return Text('No image available');
                      }
                      return MosaiqueCollectionCard(
                        imageUrl: snapshot.data!,
                        name: collection.title,
                        collectionId: collection.id,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
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
    return '';
  }

  void _openCreateCollectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
              // const SizedBox(height: 8),
              _buildPublicButton(context),
              const SizedBox(height: 18),
              buildValidateButton(context),
            ],
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
          // key: _formKey,
          child: TextFormField(
            cursorColor: couleurBleuClair2,
            style: AppTextStyles.bodyStyle(context),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: AppTextStyles.subtitleLargeGrey(context),
              hintText: AppLocalizations.of(context)!
                  .translate('enternamecollection'),
            ),
            // onChanged: (value) => context.read<CreatePostCubit>().captionChanged(value),
            validator: (value) => value!.trim().isEmpty
                ? AppLocalizations.of(context)!.translate('captionnotempty')
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPublicButton(BuildContext context) {
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
            Switch(value: false, onChanged: (bool value) {}),
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

  TextButton buildValidateButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
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

  TextButton buildCreatenewcollection(BuildContext context) {
    return TextButton(
      onPressed: () => _openCreateCollectionSheet(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.add, color: black),
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
          Icon(Icons.arrow_forward, color: black),
        ],
      ),
    );
  }
}
