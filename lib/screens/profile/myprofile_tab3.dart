import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/profile/widgets/widgets.dart';

import 'package:flutter/material.dart';

class MyProfileTab3 extends StatefulWidget {
  const MyProfileTab3({super.key});

  @override
  State<MyProfileTab3> createState() => _MyProfileTab3State();
}

class _MyProfileTab3State extends State<MyProfileTab3> {
  List<String> imageList = [
    'assets/images/ITG1_1.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/ITG3_1.jpg',
    'assets/images/ITG3_2.jpg',
    'assets/images/postImage.jpg',
    'assets/images/postImage2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: buildCreatenewcollection(context),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          // Ajout du widget Expanded ici
          child: Container(
            color: white,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 0.8,
              ),
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return MosaiqueCollectionCard(
                  context,
                  title: "Titre",
                  imageUrl: imageList[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _openCreateCollectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
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
              // const SizedBox(height: 8),
              _buildPublicButton(context),
              const SizedBox(height: 18),
              buildValidateButton(context),
            ],
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
          // key: _formKey,
          child: TextFormField(
            cursorColor: couleurBleuClair2,
            style: AppTextStyles.bodyStyle(context),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: AppTextStyles.subtitleLargeGrey(context),
              hintText: AppLocalizations.of(context)!
                  .translate('enternamecollection'),
            ),
            // onChanged: (value) => context.read<CreatePostCubit>().captionChanged(value),
            validator: (value) => value!.trim().isEmpty
                ? AppLocalizations.of(context)!.translate('captionnotempty')
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPublicButton(BuildContext context) {
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
            Switch(value: false, onChanged: (bool value) {}),
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

  // Builds the 'Edit Profile' button.
  TextButton buildValidateButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
    return TextButton(
      onPressed: () => _openCreateCollectionSheet(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.add, color: black),
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
          Icon(Icons.arrow_forward, color: black),
        ],
      ),
    );
  }
}
