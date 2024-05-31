import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePostBrandInput extends StatelessWidget {
  const CreatePostBrandInput({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '(${context.read<CreatePostCubit>().state.tags.length})',
            style: AppTextStyles.subtitleLargeGrey(context),
          ), // Display the count
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward),
        ],
      ),
      title: Text(AppLocalizations.of(context)!.translate('brand'),
          style: AppTextStyles.titleLargeBlackBold(context)),
      onTap: () => GoRouter.of(context).go('/profile/create/brand', extra: context.read<CreatePostCubit>()),
    );
  }
}
