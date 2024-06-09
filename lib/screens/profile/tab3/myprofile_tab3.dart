import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/profile/bloc/blocs.dart';
import 'package:bootdv2/screens/profile/cubit/createcollection_cubit.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileTab3 extends StatefulWidget {
  final TabController tabController;

  const MyProfileTab3({
    super.key,
    required this.tabController,
  });

  @override
  _MyProfileTab3State createState() => _MyProfileTab3State();
}

class _MyProfileTab3State extends State<MyProfileTab3>
    with
        AutomaticKeepAliveClientMixin<MyProfileTab3>,
        LoggingMixin<MyProfileTab3> {
  final TextEditingController _collectionNameController =
      TextEditingController();
  ValueNotifier<bool> isPublicNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<CreateCollectionCubit, CreateCollectionState>(
      listener: (context, state) {
        if (state.status == CreateCollectionStatus.success) {
          logInfo('CreateCollectionCubit.listener', 'CreateCollection success',
              {'status': state.status});
          context.read<MyCollectionBloc>().add(MyCollectionFetchCollections());
        }
      },
      child: BlocConsumer<MyCollectionBloc, MyCollectionState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == MyCollectionStatus.initial) {
            logInfo('MyCollectionBloc.builder',
                'Initial state detected, fetching collections', {});
            context
                .read<MyCollectionBloc>()
                .add(MyCollectionFetchCollections());
          }
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(MyCollectionState state) {
    const String widgetName = '_buildBody';
    logInfo(widgetName, 'Building body with ', {'state': state});

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            child: buildCreatenewcollection(context),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<MyCollectionBloc>()
                      .add(MyCollectionFetchCollections());
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  padding: const EdgeInsets.only(top: 5),
                  physics: const ClampingScrollPhysics(),
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.transparent),
                            );
                          }
                          if (snapshot.hasError) {
                            logError(widgetName, 'Error fetching image URL',
                                {'error': snapshot.error});
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            logInfo(
                                widgetName,
                                'No image available for collection',
                                {'collectionId': collection.id});
                            return const Text('No image available');
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
          ),
        ],
      ),
    );
  }

  Future<String> getMostRecentPostImageUrl(String collectionId) async {
    const String widgetName = 'getMostRecentPostImageUrl';

    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection');

      final querySnapshot =
          await feedEventRef.orderBy('date', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        final DocumentReference? postRef =
            data['post_ref'] as DocumentReference?;

        if (postRef != null) {
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            final postData = postDoc.data() as Map<String, dynamic>?;
            logInfo(widgetName, 'Referenced post document exists',
                {'collectionId': collectionId});
            return postData?['imageUrl'] as String? ?? '';
          } else {
            logInfo(widgetName, 'Referenced post document does not exist',
                {'collectionId': collectionId});
          }
        } else {
          logInfo(widgetName, 'Post reference is null',
              {'collectionId': collectionId});
        }
      }
    } catch (e) {
      logError(widgetName, 'Error fetching most liked post image URL',
          {'collectionId': collectionId, 'error': e.toString()});
    }
    return 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fwhite_placeholder.png?alt=media&token=2d4e4176-e9a6-41e4-93dc-92cd7f257ea7';
  }

  void _openCreateCollectionSheet(BuildContext context) {
    const String widgetName = '_openCreateCollectionSheet';

    final createCollectionCubit = context.read<CreateCollectionCubit>();
    logInfo(widgetName, 'Opening create collection sheet', {});

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
                logInfo(widgetName, 'Collection creation successful',
                    {'status': state.status});
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(20),
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
    const String widgetName = '_buildPublicButton';

    logInfo(widgetName, 'Building public button', {'isPublic': isPublic});

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
                logInfo(
                    widgetName, 'Public switch changed', {'newValue': value});
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
    const String widgetName = 'buildValidateButton';

    return TextButton(
      onPressed: () {
        final String collectionName = _collectionNameController.text.trim();
        final bool isPublic = isPublicNotifier.value;

        logInfo(widgetName, 'Validate button pressed',
            {'collectionName': collectionName, 'isPublic': isPublic});

        if (collectionName.isNotEmpty) {
          final authState = context.read<AuthBloc>().state;
          final userId = authState.user?.uid;

          if (userId != null) {
            logInfo(widgetName, 'User ID is not null', {'userId': userId});
            context
                .read<CreateCollectionCubit>()
                .createCollection(userId, collectionName, isPublic);
          } else {
            logError(widgetName, 'User ID is null');
          }
        } else {
          logError(widgetName, 'Collection name is empty');
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

  TextButton buildCreatenewcollection(BuildContext context) {
    const String widgetName = 'buildCreatenewcollection';

    return TextButton(
      onPressed: () {
        logInfo(widgetName, 'Create new collection button pressed', {});
        _openCreateCollectionSheet(context);
      },
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

  @override
  bool get wantKeepAlive => true;
}
