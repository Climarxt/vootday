import 'package:bootdv2/config/paths.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/post_repository.dart';
import 'package:bootdv2/widgets/appbar/appbar_post.dart';
import 'package:bootdv2/widgets/profileimagepost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreen extends StatelessWidget {
  final String postId; // Utilisation d'un String pour l'ID du post
  const PostScreen({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return FutureBuilder<Post?>(
        future: context.read<PostRepository>().getPostById(postId),
        builder: (BuildContext context, AsyncSnapshot<Post?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Post not found'));
          }

          final Post post = snapshot.data!;

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection(Paths.users)
                .doc(post.author.id)
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.transparent),
                  ),
                );
              }

              if (userSnapshot.hasError) {
                return Center(child: Text('Error: ${userSnapshot.error}'));
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const Center(child: Text('User not found'));
              }

              final User user = User.fromDocument(userSnapshot.data!);
              {
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
                                Image(
                                  image: post.imageProvider,
                                  width: size.width,
                                  fit: BoxFit.fitWidth,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 18, right: 18),
                                  child: Row(
                                    children: [
                                      ProfileImagePost(
                                        title:
                                            '${user.firstName} ${user.lastName}',
                                        subtitle: user.username,
                                        profileImageProvider:
                                            user.profileImageProvider,
                                      ),
                                      const Spacer(),
                                      const Column(
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
              }
            },
          );
        });
  }
}
