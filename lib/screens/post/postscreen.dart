import 'package:bootdv2/config/paths.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/post/post_repository.dart';
import 'package:bootdv2/widgets/appbar/appbar_title.dart';
import 'package:bootdv2/widgets/profileimagepost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostScreen extends StatelessWidget {
  final String postId;
  final String username;

  const PostScreen({
    super.key,
    required this.postId,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBarTitle(title: username),
        body: FutureBuilder<Post?>(
          future: context.read<PostRepository>().getPostById(postId),
          builder: (context, postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            if (!postSnapshot.hasData) {
              return const Center(child: Text('Post not found'));
            }
            final Post post = postSnapshot.data!;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection(Paths.users)
                  .doc(post.author.id)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const Center(child: Text('User not found'));
                }
                final User user = User.fromDocument(userSnapshot.data!);

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: size.height),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<void>(
                          future: Future.delayed(
                              const Duration(seconds: 0, milliseconds: 200)),
                          builder: (context, delaySnapshot) {
                            Widget imageWidget;
                            if (delaySnapshot.connectionState ==
                                ConnectionState.done) {
                              imageWidget = Image(
                                key: ValueKey(post.id),
                                image: post.imageProvider,
                                width: size.width,
                                height: size.height / 1.5,
                                fit: BoxFit.cover,
                              );
                            } else {
                              imageWidget = Container(
                                key: const ValueKey('placeholder'),
                                width: size.width,
                                height: size.height / 1.5,
                                color: Colors.white,
                              );
                            }
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: imageWidget,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: Row(
                            children: [
                              FutureBuilder<void>(
                                future: Future.delayed(
                                    const Duration(milliseconds: 200)),
                                builder: (context, delaySnapshot) {
                                  Widget profileImageWidget;
                                  if (delaySnapshot.connectionState ==
                                      ConnectionState.done) {
                                    profileImageWidget = ProfileImagePost(
                                      title:
                                          '${user.firstName} ${user.lastName}',
                                      profileImageProvider:
                                          user.profileImageProvider,
                                      description: post.caption,
                                      tags: post.tags,
                                    );
                                  } else {
                                    profileImageWidget = Container(
                                      width: 48,
                                      height: 48,
                                      color: Colors.white,
                                    );
                                  }
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: profileImageWidget,
                                  );
                                },
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
