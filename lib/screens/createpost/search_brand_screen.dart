import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/localizations.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/widgets/appbar/appbar_add_brand.dart';
import 'package:bootdv2/widgets/appbar/appbar_title_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandSearchScreen extends StatefulWidget {
  BrandSearchScreen({
    super.key,
  });

  @override
  _BrandSearchScreenState createState() => _BrandSearchScreenState();
}

class _BrandSearchScreenState extends State<BrandSearchScreen> {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Scaffold(
        appBar: const AppBarAddBrand(title: "Ajout marque"),
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
          );
        }),
      ),
    );
  }
}
