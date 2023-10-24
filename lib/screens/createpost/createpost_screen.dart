import 'dart:io';

import 'package:bootdv2/config/colors.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/localizations.dart';
import 'package:bootdv2/widgets/appbar/appbar_title.dart';
import 'package:bootdv2/widgets/cards/create_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';

import 'widgets/widgets.dart';
import '../../helpers/helpers.dart';
import 'cubit/create_post_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/createPost';

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _tagAutocompleteController = TextEditingController();

  final List<String> predefinedTags = [
    'Tag1',
    'Tag2',
    'Tag3',
    'Tag4',
    'Tag5',
    'Tag6',
    'Tag7',
    'Tag8',
    'Tag9',
    'Tag10',
  ];

  @override
  void initState() {
    super.initState();
    _pickAndCropImage(context);
  }

  // Image file to be posted
  late File _postImage;

  // Helper for image operations
  final imageHelper = ImageHelperPost();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) =>
              _handleCreatePostStateChanges(context, state),
          builder: (context, state) => _buildForm(context, state),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  // Builds the form
  Widget _buildForm(BuildContext context, CreatePostState state) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarTitle(
          title: AppLocalizations.of(context)!.translate('addpost'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildImageSection(context, state),
              if (state.status == CreatePostStatus.submitting)
                const LinearProgressIndicator(),
              _buildCaptionInput(context),
              _buildChipInputSection(context, state),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                title: const Text("Marque"),
                onTap: () => GoRouter.of(context).go('/profile/create/brand'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // New chip input section
  Widget _buildChipInputSection(BuildContext context, CreatePostState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate('brand'),
            style: AppTextStyles.titleLargeBlackBold(context),
          ),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable.empty();
              }
              // Vérifiez d'abord les tags prédéfinis qui contiennent le texte actuel
              var matchingTags = predefinedTags
                  .where((tag) => tag.contains(textEditingValue.text));

              // Si le texte actuel ne correspond à aucun tag prédéfini, ajoutez-le comme une nouvelle option
              if (!matchingTags.contains(textEditingValue.text)) {
                matchingTags = matchingTags.followedBy([textEditingValue.text]);
              }

              return matchingTags;
            },
            onSelected: (tag) {
              context.read<CreatePostCubit>().addTag(tag);
              _tagAutocompleteController
                  .clear(); // Réinitialise le champ de saisie
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              _tagAutocompleteController =
                  textEditingController; // connectez le controller
              return TextField(
                cursorColor: couleurBleuClair2,
                controller: _tagAutocompleteController,
                focusNode: focusNode,
                style: AppTextStyles.bodyStyle(context),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: AppTextStyles.subtitleLargeGrey(context),
                  hintText: AppLocalizations.of(context)!.translate('addbrand'),
                ),
                onSubmitted: (String value) {
                  onFieldSubmitted();
                },
              );
            },
          ),
          const SizedBox(height: 6.0),
          SizedBox(
            height: 32.0, // Adjust this height as per your needs
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.tags.length,
              itemBuilder: (context, index) {
                final tag = state.tags[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: RawChip(
                    backgroundColor: grey,
                    label: Text(tag),
                    onPressed: () {
                      context.read<CreatePostCubit>().removeTag(tag);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Builds the caption input field
  Widget _buildCaptionInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.translate('description'),
            style: AppTextStyles.titleLargeBlackBold(context),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              cursorColor: couleurBleuClair2,
              style: AppTextStyles.bodyStyle(context),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: AppTextStyles.subtitleLargeGrey(context),
                hintText: AppLocalizations.of(context)!
                    .translate('detaildescription'),
              ),
              onChanged: (value) =>
                  context.read<CreatePostCubit>().captionChanged(value),
              validator: (value) => value!.trim().isEmpty
                  ? AppLocalizations.of(context)!.translate('captionnotempty')
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // Builds the post button
  Widget _buildFloatingActionButton(BuildContext context) {
    final state = context.watch<CreatePostCubit>().state;
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: state.status != CreatePostStatus.submitting
          ? () => _submitForm(context)
          : null,
      label: Text(AppLocalizations.of(context)!.translate('add'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white)),
    );
  }

  // Submits the form
  void _submitForm(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (_formKey.currentState!.validate() && _postImage != null) {
      context.read<CreatePostCubit>().submit();
    }
  }

  // Builds the image section of the form
  Widget _buildImageSection(BuildContext context, CreatePostState state) {
    double reducedHeight = MediaQuery.of(context).size.height * 0.3 * 0.8;
    double reducedWidth = reducedHeight * 0.7; // Maintain aspect ratio

    return GestureDetector(
      onTap: () async => _pickAndCropImage(context),
      child: Center(
        child: SizedBox(
          height: reducedHeight,
          width: reducedWidth,
          child: CreatePostCard(postImage: state.postImage),
        ),
      ),
    );
  }

  // Picks and crops the image
  Future<void> _pickAndCropImage(BuildContext context) async {
    final file = await imageHelper.pickImage();
    if (file != null) {
      final croppedFile = await imageHelper.crop(
        file: file,
        cropStyle: CropStyle.rectangle,
      );
      if (croppedFile != null) {
        setState(() {
          _postImage = File(croppedFile.path);
          context.read<CreatePostCubit>().postImageChanged(_postImage);
        });
      }
    }
  }

  // Handles different state changes
  void _handleCreatePostStateChanges(
      BuildContext context, CreatePostState state) {
    if (state.status == CreatePostStatus.success) {
      _resetForm(context);
      SnackbarUtil.showSuccessSnackbar(context, 'Post Created !');
    } else if (state.status == CreatePostStatus.error) {
      SnackbarUtil.showErrorSnackbar(context, state.failure.message);
    }
  }

  // Resets the form
  void _resetForm(BuildContext context) {
    _formKey.currentState!.reset();
    context.read<CreatePostCubit>().reset();
  }
}
