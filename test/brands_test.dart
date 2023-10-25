import 'package:bootdv2/models/brand.dart';
import 'package:bootdv2/repositories/brand/brand_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDMGQuIZjr3oNgVVShxf_PKD7YKWm5WzaQ',
        appId: '1:920926023285:ios:470c3463fc6ec059e3d23c',
        messagingSenderId: '920926023285',
        projectId: 'bootdv2',
        databaseURL:
            'https://bootdv2-default-rtdb.europe-west1.firebasedatabase.app',
        storageBucket: 'bootdv2.appspot.com',
        iosClientId:
            '920926023285-o0inbcdu1dqvhsk9rd5kcfo3lh43upuo.apps.googleusercontent.com',
        iosBundleId: 'com.example.bootdv2',
      ),
      name: '[DEFAULT]',
    );
  });
  group('BrandRepository', () {
    late BrandRepository brandRepository;
    late MockFirebaseFirestore mockFirebaseFirestore;
    late MockCollectionReference mockCollectionReference;
    late MockQuerySnapshot mockQuerySnapshot;

    setUp(() {
      mockFirebaseFirestore = MockFirebaseFirestore();
      mockCollectionReference = MockCollectionReference();
      mockQuerySnapshot = MockQuerySnapshot();
      brandRepository = BrandRepository();

      when(mockFirebaseFirestore.collection('brands')).thenReturn(
          mockCollectionReference as CollectionReference<Map<String, dynamic>>);

      when(mockCollectionReference.get())
          .thenAnswer((_) async => mockQuerySnapshot);
    });

    test('getAllBrands returns list of brands', () async {
      // Mock the data
      when(mockQuerySnapshot.docs).thenReturn([
        // Add some mocked documents here
      ]);

      final brands = await brandRepository.getAllBrands();

      // Validate the result
      expect(brands, isA<List<Brand>>());
    });
  });
}
