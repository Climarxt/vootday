import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/post_repository.dart';
import 'package:bootdv2/screens/home/bloc/ootd/feed_ootd_bloc.dart';
import 'package:bootdv2/screens/profile/bloc/profile_bloc.dart';
import 'package:bootdv2/widgets/appbar/appbar_post.dart';
import 'package:bootdv2/widgets/profileimagepost.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class PostScreen extends StatelessWidget {
  final String postId; // Utilisation d'un String pour l'ID du post
  const PostScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Ici, vous utilisez la méthode getPostById pour récupérer les données du post asynchrone.
    return FutureBuilder<Post?>(
        future: context.read<PostRepository>().getPostById(postId),
        builder: (BuildContext context, AsyncSnapshot<Post?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Post not found'));
          }

          final Post post = snapshot.data!;

          // Construisez maintenant votre interface utilisateur avec l'objet Post récupéré.
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: size.height),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Exemple pour afficher l'image de Post (mettez à jour le reste du code en conséquence)
                          Image.network(
                            post.imageUrl,
                            width: size.width,
                            fit: BoxFit.fitWidth,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 18, right: 18),
                            child: Row(
                              children: [
                                ProfileImagePost(
                                  title: "Christian Bastide",
                                  subtitle: 'username',
                                  profileUrl: 'assets/images/profile1.jpg',
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    SizedBox(height: 12),
                                    Icon(Icons.more_vert,
                                        color: Colors.black, size: 24),
                                    SizedBox(height: 32),
                                    Icon(Icons.comment,
                                        color: Colors.black, size: 24),
                                    SizedBox(height: 32),
                                    Icon(Icons.share,
                                        color: Colors.black, size: 24),
                                    SizedBox(height: 32),
                                    Icon(Icons.add_to_photos,
                                        color: Colors.black, size: 24),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // AppBar personnalisée
                  const Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: AppBarPost(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
