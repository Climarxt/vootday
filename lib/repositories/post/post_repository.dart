// ignore_for_file: unused_field

import 'package:bootdv2/config/logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final FirebaseFirestore _firebaseFirestore;
  final ContextualLogger logger;

  PostRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        logger = ContextualLogger('PostRepository');
}
