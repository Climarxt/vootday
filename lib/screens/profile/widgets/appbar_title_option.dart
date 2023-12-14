import 'package:bootdv2/cubits/delete_collections/delete_collections_cubit.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';
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
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                // Implémentez votre logique de signalement ici
                Navigator.pop(context);
              },
            ),
            if (isUserTheAuthor) // Condition pour afficher l'option de suppression
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context); // Ferme la bottomSheet d'abord
                  Future.delayed(Duration.zero, () {
                    final postCubit = context.read<DeleteCollectionsCubit>();
                    postCubit.deleteCollections(collectionId);
                    GoRouter.of(context).replace('/profile');
                    SnackbarUtil.showSuccessSnackbar(context, 'Post Deleted !');
                  });
                },
              ),
          ],
        );
      },
    );
  }
}
