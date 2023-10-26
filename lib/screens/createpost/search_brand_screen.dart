import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/cubits/brands/brands_cubit.dart';
import 'package:bootdv2/cubits/brands/brands_state.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/widgets/appbar/appbar_add_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BrandSearchScreen extends StatefulWidget {
  const BrandSearchScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BrandSearchScreenState createState() => _BrandSearchScreenState();
}

class _BrandSearchScreenState extends State<BrandSearchScreen> {
  TextEditingController _tagAutocompleteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<BrandCubit>()
        .fetchBrands(); // Appel de la méthode pour obtenir toutes les marques
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandCubit, BrandState>(
      builder: (context, brandState) {
        return Scaffold(
          appBar: AppBarAddBrand(
              title: AppLocalizations.of(context)!.translate('brand')),
          floatingActionButton: _buildFloatingActionButton(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: BlocBuilder<CreatePostCubit, CreatePostState>(
            builder: (context, createPostState) {
              return _buildBody(
                  context,
                  createPostState,
                  brandState.brands
                      .map((brand) => brand.name)
                      .toList()); // Utilisez `name` ou l'attribut approprié de votre modèle Brand
            },
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CreatePostState createPostState,
      List<String> brandTags) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAutoComplete(context, brandTags), // Passez brandTags ici
          const SizedBox(height: 6.0),
          _buildTagList(context, createPostState),
        ],
      ),
    );
  }

  Widget _buildAutoComplete(BuildContext context, List<String> brandTags) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return _buildMatchingTags(textEditingValue, brandTags);
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return _buildOptionsView(
            context, onSelected, options, brandTags); // Passez brandTags ici
      },
      onSelected: (tag) => _handleTagSelected(context, tag),
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return _buildTextField(
            context, textEditingController, focusNode, onFieldSubmitted);
      },
    );
  }

  Iterable<String> _buildMatchingTags(
      TextEditingValue textEditingValue, List<String> brandTags) {
    if (textEditingValue.text == '') {
      return const Iterable.empty();
    }
    var matchingTags =
        brandTags.where((tag) => tag.contains(textEditingValue.text));
    if (!matchingTags.contains(textEditingValue.text)) {
      matchingTags = matchingTags.followedBy([textEditingValue.text]);
    }
    return matchingTags;
  }

  Widget _buildOptionsView(
      BuildContext context,
      AutocompleteOnSelected<String> onSelected,
      Iterable<String> options,
      List<String> brandTags) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 0,
        child: Container(
          color: white,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: options
                .map((String option) =>
                    _buildOption(context, onSelected, option, brandTags))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context,
      AutocompleteOnSelected<String> onSelected,
      String option,
      List<String> brandTags) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(brandTags.contains(option)
              ? 'assets/images/profile1.jpg'
              : 'assets/images/profile2.jpg'), // remplacez par brandTags
          radius: 24,
        ),
        title: Text(option),
        onTap: () => onSelected(option),
      ),
    );
  }

  void _handleTagSelected(BuildContext context, String tag) {
    context.read<CreatePostCubit>().addTag(tag);
    _tagAutocompleteController.clear();
  }

  Widget _buildTextField(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted) {
    _tagAutocompleteController = textEditingController;
    return TextField(
      cursorColor: couleurBleuClair2,
      controller: _tagAutocompleteController,
      focusNode: focusNode,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: black),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle:
            Theme.of(context).textTheme.headlineMedium!.copyWith(color: grey),
        hintText: AppLocalizations.of(context)!.translate('searchbrands'),
      ),
      onSubmitted: (String value) => onFieldSubmitted(),
    );
  }

  Widget _buildTagList(BuildContext context, CreatePostState state) {
    return SizedBox(
      height: 32.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.tags.length,
        itemBuilder: (context, index) =>
            _buildTagChip(context, state.tags[index]),
      ),
    );
  }

  Widget _buildTagChip(BuildContext context, String tag) {
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
        onPressed: () => context.read<CreatePostCubit>().removeTag(tag),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () => _handlePostButtonPressed(context),
      label: Text(
        AppLocalizations.of(context)!.translate('validate'),
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white),
      ),
    );
  }

  void _handlePostButtonPressed(BuildContext context) {
    final goRouter = GoRouter.of(context);
    goRouter.go('/profile/create');
  }
}
