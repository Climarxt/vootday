import 'package:bootdv2/models/models.dart';

abstract class FeedStateInterface {
  List<Post?> get posts;
  dynamic get status;
}
