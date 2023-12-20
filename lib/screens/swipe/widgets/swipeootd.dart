import 'package:bootdv2/config/configs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class SwipeOOTD extends StatefulWidget {
  const SwipeOOTD({super.key});

  @override
  State<SwipeOOTD> createState() => _SwipeOOTDState();
}

class _SwipeOOTDState extends State<SwipeOOTD> {
  final CardSwiperController controller1 = CardSwiperController();
  final CardSwiperController controller2 = CardSwiperController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<String> _imageUrls1 = [];
  List<String> _imageUrls2 = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      // Récupérer tous les documents de la collection 'posts'
      var postsSnapshot =
          await _firebaseFirestore.collection(Paths.posts).get();

      // Réinitialiser les listes pour éviter les doublons lors du rechargement
      _imageUrls1.clear();
      _imageUrls2.clear();

      // Parcourir chaque document et répartir les URLs d'images entre _imageUrls1 et _imageUrls2
      bool addToFirstList = true;
      for (var doc in postsSnapshot.docs) {
        var imageUrl = doc.data()["imageUrl"] as String?;
        if (imageUrl != null) {
          if (addToFirstList) {
            _imageUrls1.add(imageUrl);
          } else {
            _imageUrls2.add(imageUrl);
          }
          addToFirstList = !addToFirstList; // Alterner entre les listes
          print('Image URL ajoutée: $imageUrl');
        }
      }

      print('Nombre total d\'images dans _imageUrls1: ${_imageUrls1.length}');
      print('Nombre total d\'images dans _imageUrls2: ${_imageUrls2.length}');

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des images: $e');
    }
  }

  int _currentIndex1 = 0;
  int _currentIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.29,
                child: CardSwiper(
                  numberOfCardsDisplayed: 1,
                  padding: const EdgeInsets.only(
                      left: 10, right: 5, bottom: 7.5, top: 7.5),
                  cardBuilder: (context, index, _, __) =>
                      _buildCard(_imageUrls1[_currentIndex1]),
                  cardsCount: _imageUrls1.length,
                  controller: controller1,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    _changeImage(1);
                    _changeImage(2);
                    return true;
                  },
                ),
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.29,
                child: CardSwiper(
                  numberOfCardsDisplayed: 1,
                  padding: const EdgeInsets.only(
                      left: 10, right: 5, bottom: 7.5, top: 7.5),
                  cardBuilder: (context, index, _, __) =>
                      _buildCard(_imageUrls2[_currentIndex2]),
                  cardsCount: _imageUrls2.length,
                  controller: controller2,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    _changeImage(1);
                    _changeImage(2);
                    return true;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String imageUrl) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  void _changeImage(int swiperNumber) {
    setState(() {
      if (swiperNumber == 1) {
        // Mettre à jour l'indice pour le premier swiper
        _currentIndex1 = (_currentIndex1 + 1) % _imageUrls1.length;
      } else if (swiperNumber == 2) {
        // Mettre à jour l'indice pour le deuxième swiper
        _currentIndex2 = (_currentIndex2 + 1) % _imageUrls2.length;
      }
    });
  }
}
