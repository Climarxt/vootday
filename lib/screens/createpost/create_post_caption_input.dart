import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostCaptionInput extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const CreatePostCaptionInput(this.formKey, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.translate('description'),
            style: AppTextStyles.titleLargeBlackBold(context),
          ),
          Form(
            key: formKey,
            child: TextFormField(
              cursorColor: couleurBleuClair2,
              style: AppTextStyles.bodyStyle(context),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: AppTextStyles.subtitleLargeGrey(context),
                hintText: AppLocalizations.of(context)!.translate('detaildescription'),
              ),
              onChanged: (value) => context.read<CreatePostCubit>().captionChanged(value),
              validator: (value) => value!.trim().isEmpty
                  ? AppLocalizations.of(context)!.translate('captionnotempty')
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
