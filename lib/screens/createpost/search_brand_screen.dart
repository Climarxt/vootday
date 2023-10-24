import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/localizations.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/widgets/appbar/appbar_title_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandSearchScreenSave extends StatefulWidget {
  final List<String> predefinedTags;

  BrandSearchScreenSave({required this.predefinedTags});

  @override
  _BrandSearchScreenSaveState createState() => _BrandSearchScreenSaveState();
}

class _BrandSearchScreenSaveState extends State<BrandSearchScreenSave> {
  TextEditingController _tagAutocompleteController = TextEditingController();

  List<String> _selectedTags = [];

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Scaffold(
        appBar: const AppBarProfile(title: "Ajout marque"),
        body: BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (context, state) {
            return Column(
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
                      matchingTags =
                          matchingTags.followedBy([textEditingValue.text]);
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
                        hintText:
                            AppLocalizations.of(context)!.translate('addbrand'),
                      ),
                      onSubmitted: (String value) {
                        onFieldSubmitted();
                      },
                    );
                  },
                ),
                const SizedBox(height: 6.0),
                Wrap(
                  spacing: 8.0, // espace entre les chips
                  runSpacing: 4.0, // espace entre les lignes
                  children: _selectedTags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        // Supprimez le tag lorsque l'utilisateur clique sur l'icône de suppression du chip
                        setState(() {
                          _selectedTags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
