import 'package:bootdv2/screens/follow_users/widgets/follow_users_tile.dart';
import 'package:bootdv2/models/wip/model.dart';

import 'package:flutter/material.dart';

class FollowUsersList extends StatelessWidget {
  const FollowUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        body: _buildFollowUsersList(),
      ),
    );
  }

  Widget _buildFollowUsersList() {
    List<NotifWIP> dummyNotifications = List<NotifWIP>.generate(
        10,
        (index) => NotifWIP(
              fromUser: UserWIP(
                profileImageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_dfd48067-cdc9-4443-ab4f-7e309cde9217.jpg?alt=media&token=b077a41c-adb5-4de6-b24f-f0cc24dceebb",
                username: "User ${index + 1}",
                id: '1',
              ),
              type: index % 2 == 0 ? NotifTypeWIP.like : NotifTypeWIP.comment,
              date: DateTime.now(),
              post: PostWIP(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fposts%2Fpost_39bfbded-e18f-49f7-8b05-c771afddf964.jpg?alt=media&token=3c76f75e-217c-4518-b06c-766316c6ffb0",
                  id: '1'),
            ));

    return ListView.builder(
      itemCount: dummyNotifications.length,
      itemBuilder: (BuildContext context, int index) {
        return FollowUsersTile(
          notification: dummyNotifications[index],
        );
      },
    );
  }
}
