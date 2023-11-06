import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/widgets/cards/mosaique_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async'; // Importez dart:async pour utiliser Timer

class ProfileTab1 extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;
  const ProfileTab1({super.key, required this.state, required this.context});

  @override
  State<ProfileTab1> createState() => _ProfileTab1State();
}

class _ProfileTab1State extends State<ProfileTab1> {
  bool _isShimmering = true;

  @override
  void initState() {
    super.initState();
    // Commencer un timer pour l'effet shimmer
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isShimmering = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utilisez _isShimmering pour contrôler l'affichage
    return _buildGridView(widget.context, widget.state, _isShimmering);
  }

  Widget _buildGridView(
      BuildContext context, ProfileState state, bool isShimmering) {
    return Container(
      color: Colors.white,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 0.8,
        ),
        itemCount: isShimmering ? 12 : state.posts.length,
        itemBuilder: (context, index) {
          if (isShimmering) {
            // Afficher l'effet shimmer pour chaque élément
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else {
            // Afficher le contenu réel
            final post = state.posts[index];
            return MosaiqueProfileCard(
              context,
              imageUrl: post!.thumbnailUrl,
            );
          }
        },
      ),
    );
  }
}
