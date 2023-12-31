import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

part 'recent_post_image_url_state.dart';

class RecentPostImageUrlCubit extends Cubit<RecentPostImageUrlState> {
  RecentPostImageUrlCubit() : super(RecentPostImageUrlInitial());

  Future<void> getMostRecentPostImageUrl(String collectionId) async {
    debugPrint('RecentPostImageUrlCubit: Début de getMostRecentPostImageUrl');
    emit(RecentPostImageUrlLoading());

    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('collections')
          .doc(collectionId)
          .collection('feed_collection');

      debugPrint(
          'RecentPostImageUrlCubit: Requête Firestore commencée pour collectionId: $collectionId');

      final querySnapshot =
          await feedEventRef.orderBy('date', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        debugPrint('RecentPostImageUrlCubit: Document trouvé dans Firestore');
        final data = querySnapshot.docs.first.data();
        final DocumentReference? postRef =
            data['post_ref'] as DocumentReference?;

        if (postRef != null) {
          debugPrint(
              'RecentPostImageUrlCubit: Référence de post trouvée, récupération du document de post');
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            debugPrint(
                'RecentPostImageUrlCubit: Document de post existe, récupération de l\'URL de l\'image');
            final postData = postDoc.data() as Map<String, dynamic>?;
            final imageUrl = postData?['imageUrl'] as String?;
            debugPrint(
                'RecentPostImageUrlCubit: URL de l\'image récupérée: $imageUrl');

            if (imageUrl != null) {
              emit(RecentPostImageUrlSuccess(imageUrl));
            } else {
              emit(RecentPostImageUrlFailure());
            }
          } else {
            debugPrint(
                'RecentPostImageUrlCubit: Document de post n\'existe pas');
            emit(RecentPostImageUrlFailure());
          }
        } else {
          debugPrint(
              'RecentPostImageUrlCubit: Aucune référence de post trouvée');
          emit(RecentPostImageUrlFailure());
        }
      } else {
        debugPrint(
            'RecentPostImageUrlCubit: Aucun document trouvé dans Firestore');
        emit(RecentPostImageUrlFailure());
      }
    } catch (e) {
      debugPrint(
          'RecentPostImageUrlCubit: Erreur lors de la récupération de l\'URL de l\'image - $e');
      emit(RecentPostImageUrlFailure());
    }
  }
}
