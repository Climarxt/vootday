import 'package:bootdv2/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandRepository {
  final CollectionReference brandsCollection =
      FirebaseFirestore.instance.collection('brands');

  Future<List<Brand>> getAllBrands() async {
    final QuerySnapshot snap = await brandsCollection.get();
    return snap.docs.map((doc) => Brand.fromDocument(doc)).toList();
  }
}
