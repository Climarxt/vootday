import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/update_public_status/update_public_status_cubit.dart';
import 'package:bootdv2/cubits/delete_collections/delete_collections_cubit.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppBarTitleOption extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String collectionId;
  final bool isUserTheAuthor;

  const AppBarTitleOption(
      {super.key,
      required this.title,
      required this.collectionId,
      required this.isUserTheAuthor});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.black),
      ),
      toolbarHeight: 62,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => _showBottomSheet(context),
          icon: const Icon(
            Icons.view_headline,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(Paths.collections)
              .doc(collectionId)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No data available'));
            }

            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            bool currentStatus = data['public'] as bool;

            return Wrap(
              children: <Widget>[
                if (isUserTheAuthor)
                  ListTile(
                    leading: const Icon(Icons.public),
                    title: const Text('Public'),
                    trailing: Switch(
                      activeColor: couleurBleuClair2,
                      value: currentStatus,
                      onChanged: (value) {
                        Navigator.pop(context);
                        context
                            .read<UpdatePublicStatusCubit>()
                            .updatePublicStatus(collectionId, value);
                      },
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text('Report'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                if (isUserTheAuthor)
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(Duration.zero, () {
                        final postCubit =
                            context.read<DeleteCollectionsCubit>();
                        postCubit.deleteCollections(collectionId);
                        GoRouter.of(context).replace('/profile');
                        SnackbarUtil.showSuccessSnackbar(
                            context, 'Collection Deleted !');
                      });
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
