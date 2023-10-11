import 'package:bootdv2/config/configs.dart';
import 'package:flutter/material.dart';

bool _isLoading = false;

class SwipeOOTD extends StatelessWidget {
  const SwipeOOTD({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return _buildDefaultState(size);
  }

  // Création d'une fonction pour l'état par défaut
  Widget _buildDefaultState(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPost(
              size,
              'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_e5af98f9-7adb-478f-8a18-71d897d3e68b.jpg?alt=media&token=ace3779f-cc7d-4f0f-a23c-35719ab4c3d2',
              'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_e5af98f9-7adb-478f-8a18-71d897d3e68b.jpg?alt=media&token=ace3779f-cc7d-4f0f-a23c-35719ab4c3d2'),
          const Divider(),
          _buildPost(
              size,
              'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_4def9ea3-d748-41c4-9a4d-5e042e386616.jpg?alt=media&token=433cc76c-6c47-4218-aad1-e5ebf63a943e',
              'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_4def9ea3-d748-41c4-9a4d-5e042e386616.jpg?alt=media&token=433cc76c-6c47-4218-aad1-e5ebf63a943e'),
        ],
      ),
    );
  }

  // Création d'une fonction pour construire chaque post
  Widget _buildPost(Size size, String imageUrl, String profileImageUrl) {
    // <-- Add profileImageUrl parameter
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: AspectRatio(
        aspectRatio: 1.18,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // <-- White border color
                                width: 2.0, // <-- Border width
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(profileImageUrl),
                              radius: 15,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "NomUtilisateur",
                            style: TextStyle(
                              fontSize: 20,
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
