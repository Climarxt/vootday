import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/widgets/appbar/appbar_add_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandSearchScreenTest extends StatefulWidget {
  const BrandSearchScreenTest({Key? key}) : super(key: key);

  @override
  _BrandSearchScreenTestState createState() => _BrandSearchScreenTestState();
}

class _BrandSearchScreenTestState extends State<BrandSearchScreenTest> {
  @override
  Widget build(BuildContext context) {
    final createPostCubit = context.read<CreatePostCubit>(); // Integrate here

    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Scaffold(
            appBar: const AppBarAddBrand(title: "Ajout marque"),
            body: Center(
              child: Container(child: Text('Tag Count: ${state.tags.length}')),
            ),
          ),
        );
      },
    );
  }
}
