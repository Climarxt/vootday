class UserWIP {
  final String id;
  final String username;
  final String profileImageUrl;

  UserWIP({
    required this.id,
    required this.username,
    required this.profileImageUrl,
  });
}

class PostWIP {
  final String id;
  final String imageUrl;

  PostWIP({
    required this.id,
    required this.imageUrl,
  });
}

enum NotifTypeWIP {
  like,
  comment,
  follow,
}

class NotifWIP {
  final UserWIP fromUser;
  final NotifTypeWIP type;
  final DateTime date;
  final PostWIP? post;

  NotifWIP({
    required this.fromUser,
    required this.type,
    required this.date,
    this.post,
  });
}
