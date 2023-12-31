import 'package:bootdv2/screens/follow_users/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:go_router/go_router.dart';

class FollowUsersTile extends StatefulWidget {
  final User user;
  final bool isFollowing;

  const FollowUsersTile({
    super.key,
    required this.user,
    required this.isFollowing,
  });

  @override
  State<FollowUsersTile> createState() => _FollowUsersTileState();
}

class _FollowUsersTileState extends State<FollowUsersTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          _buildAvatar(context),
          const SizedBox(width: 10),
          _buildUserInfo(context),
          FollowButton(
            isFollowing: widget.isFollowing,
            userId: widget.user.id,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context)
            .push('/user/${widget.user.id}?username=${widget.user.username}');
      },
      child: CircleAvatar(
        radius: 27,
        backgroundImage: NetworkImage(widget.user.profileImageUrl.isNotEmpty
            ? widget.user.profileImageUrl
            : 'assets/image/white_placeholder.png'),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.user.username,
            style: AppTextStyles.titleLargeBlackBold(context),
          ),
          Text(
            '${widget.user.firstName} ${widget.user.lastName}',
            style: AppTextStyles.subtitleLargeGrey(context),
          ),
        ],
      ),
    );
  }
}
