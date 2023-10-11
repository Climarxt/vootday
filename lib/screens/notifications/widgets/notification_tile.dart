import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bootdv2/models/wip/model.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final NotifWIP notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18.0,
        backgroundImage: NetworkImage(notification.fromUser.profileImageUrl),
      ),
      title: buildNotificationText(),
      subtitle: buildDateText(),
      trailing: buildTrailing(context),
    );
  }

  // Builds the text for the notification.
  Text buildNotificationText() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: notification.fromUser.username,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(text: getNotificationMessage()),
        ],
      ),
    );
  }

  // Gets the appropriate message for the notification type.
  String getNotificationMessage() {
    switch (notification.type) {
      case NotifTypeWIP.like:
        return 'a aimé votre post.';
      case NotifTypeWIP.comment:
        return 'a commenté votre post.';
      case NotifTypeWIP.follow:
        return 'vous a suivi.';
      default:
        return '';
    }
  }

  // Builds the date text for the notification.
  Text buildDateText() {
    return Text(
      DateFormat.yMd('fr_FR').add_jm().format(notification.date),
      style: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Builds the trailing widget for the notification.
  Widget buildTrailing(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: 60.0,
      child: CachedNetworkImage(
        height: 60.0,
        width: 60.0,
        imageUrl: notification.post!.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
