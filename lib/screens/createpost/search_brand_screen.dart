import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/localizations.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/widgets/appbar/appbar_add_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      appBar: AppBarAddBrand(
          title: AppLocalizations.of(context)!.translate('brand')),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocBuilder<CreatePostCubit, CreatePostState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<String> onSelected,
                      Iterable<String> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 0,
                        child: Container(
                          color: white,
                          child: ListView(
                            padding: const EdgeInsets.all(8.0),
                            children: options.map((String option) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom:
                                          8.0), // Ajouter un padding en bas pour chaque élément
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          predefinedTags.contains(option)
                                              ? 'assets/images/profile1.jpg'
                                              : 'assets/images/profile2.jpg' // Remplacez ceci par le chemin vers votre autre image
                                          ),
                                      radius:
                                          24, // Ajustez la taille selon vos besoins
                                    ),
                                    title: Text(option),
                                    onTap: () {
                                      onSelected(option);
                                    },
                                  ));
                            }).toList(),
                          ),
                        ),
                      ),
                    );
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: grey),
                          hintText: AppLocalizations.of(context)!
                              .translate('searchbrands')),
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
                          label: Text(
                            tag,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: black),
                          ),
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
        },
      ),
    );
  }

  // Builds the post button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () {
        final goRouter = GoRouter.of(context);
        goRouter.go('/profile/create');
      },
      label: Text(AppLocalizations.of(context)!.translate('validate'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white)),
    );
  }
}
