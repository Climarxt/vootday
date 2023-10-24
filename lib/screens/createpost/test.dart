import 'package:bootdv2/widgets/appbar/appbar_add_brand.dart';
import 'package:bootdv2/widgets/appbar/appbar_title_profile.dart';
import 'package:flutter/material.dart';

class BrandSearchScreen extends StatefulWidget {
  const BrandSearchScreen({super.key, });

  @override
  _BrandSearchScreenState createState() => _BrandSearchScreenState();
}

class _BrandSearchScreenState extends State<BrandSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Scaffold(
          appBar: const AppBarAddBrand(title: "Ajout marque"),
          body: Center(
            child: Container(child: Text('Test')),
          )),
    );
  }
}
