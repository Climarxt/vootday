import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/comment/bloc/comments_post/comments_bloc.dart';
import 'package:bootdv2/screens/comment/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({super.key, required this.postId});

  @override
  // ignore: library_private_types_in_public_api
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String formatDuration(DateTime commentDate) {
    final now = DateTime.now();
    final difference = now.difference(commentDate);

    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'Maintenant';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            // Fermer le clavier lorsque l'utilisateur tape en dehors du TextField
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: white,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: white,
                appBar: AppBarComment(
                  title: AppLocalizations.of(context)!.translate('comments'),
                ),
                body: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  itemCount: state.comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final comment = state.comments[index];
                    return ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(
                              '/user/${comment.author.id}?username=${comment.author.username}');
                        },
                        child: UserProfileImage(
                          outerCircleRadius: 23,
                          radius: 22.0,
                          profileImageUrl: comment!.author.profileImageUrl,
                        ),
                      ),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: comment.author.username,
                              style: AppTextStyles.titleLargeBlackBold(context),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 5),
                            ),
                            TextSpan(
                              text: comment.content,
                              style: AppTextStyles.bodyStyle(context),
                            ),
                            const WidgetSpan(
                              child: SizedBox(width: 5),
                            ),
                            TextSpan(
                              text: formatDuration(comment.date),
                              style: AppTextStyles.bodySmallStyleGrey(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                bottomSheet: Container(
                  color: white,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 3.0,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _commentController,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: 'Ecrire un commentaire...'),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                final content = _commentController.text.trim();
                                if (content.isNotEmpty) {
                                  context
                                      .read<CommentsBloc>()
                                      .add(CommentsPostComment(
                                        content: content,
                                        postId: widget.postId,
                                      ));
                                  _commentController.clear();
              
                                  FocusScope.of(context).unfocus();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
