import 'package:bootdv2/cubits/brands/brands_cubit.dart';
import 'package:bootdv2/cubits/brands/brands_state.dart';
import 'package:bootdv2/screens/createpost/cubit/create_post_cubit.dart';
import 'package:bootdv2/widgets/appbar/appbar_add_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandSearchScreenOld extends StatefulWidget {
  const BrandSearchScreenOld({Key? key}) : super(key: key);

  @override
  _BrandSearchScreenOldState createState() => _BrandSearchScreenOldState();
}

class _BrandSearchScreenOldState extends State<BrandSearchScreenOld> {
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: ListView.builder(
            itemCount: brandState.brands.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(brandState.brands[index]
                    .name), // Remplacez `name` par l'attribut approprié de votre modèle Brand
              );
            },
          ),
        );
      },
    );
  }
}
