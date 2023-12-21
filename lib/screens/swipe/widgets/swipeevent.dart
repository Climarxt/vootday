import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/swipe/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';

class SwipeEvent extends StatefulWidget {
  const SwipeEvent({super.key});

  @override
  State<SwipeEvent> createState() => _SwipeEventState();
}

class _SwipeEventState extends State<SwipeEvent> with TickerProviderStateMixin {
  final CardSwiperController controller1 = CardSwiperController();
  final CardSwiperController controller2 = CardSwiperController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimation;
  List<String> _imageUrls1 = [];
  List<String> _imageUrls2 = [];
  bool _isLoading = true;
  bool useFirstUrl = true;

  @override
  void initState() {
    super.initState();
    _loadImages();

    _heartAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat(reverse: true); // Répète l'animation indéfiniment avec reverse

    _heartAnimation = Tween(begin: 150.0, end: 170.0).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.bounceOut,
      ),
    );
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.29,
                child: CardSwiper(
                  numberOfCardsDisplayed: 1,
                  allowedSwipeDirection: AllowedSwipeDirection.only(
                    up: true,
                    left: true,
                    down: true,
                    right: false,
                  ),
                  padding: const EdgeInsets.only(
                      left: 10, right: 7.5, bottom: 7.5, top: 7.5),
                  cardBuilder: (context, index, horizontalThresholdPercentage,
                          verticalThresholdPercentage) =>
                      _buildCard(
                          _imageUrls1[_currentIndex1],
                          horizontalThresholdPercentage.toDouble(),
                          verticalThresholdPercentage.toDouble()),
                  cardsCount: _imageUrls1.length,
                  controller: controller1,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    _animateCard(1);
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
                  allowedSwipeDirection: AllowedSwipeDirection.only(
                    up: true,
                    left: false,
                    down: true,
                    right: true,
                  ),
                  padding: const EdgeInsets.only(
                      left: 7.5, right: 10, bottom: 7.5, top: 7.5),
                  cardBuilder: (context, index, horizontalThresholdPercentage,
                          verticalThresholdPercentage) =>
                      _buildCard(
                          _imageUrls2[_currentIndex2],
                          horizontalThresholdPercentage.toDouble(),
                          verticalThresholdPercentage.toDouble()),
                  cardsCount: _imageUrls2.length,
                  controller: controller2,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    _animateCard(2);
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

  Widget _buildCard(String imageUrl, double horizontalSwipePercentage,
      double verticalSwipePercentage) {
    bool shouldShowHeart = horizontalSwipePercentage.abs() > 60 ||
        verticalSwipePercentage.abs() > 60;

    if (shouldShowHeart) {
      _heartAnimationController.forward();
    } else {
      _heartAnimationController.reset();
    }

    return Stack(
      children: [
        // Image
        Positioned.fill(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 12,
          child: buildUsername(context),
        ),
        // Heart Animation
        if (shouldShowHeart)
          Center(
            child: AnimatedBuilder(
              animation: _heartAnimationController,
              builder: (context, _) {
                return Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: _heartAnimation.value,
                );
              },
            ),
          ),
      ],
    );
  }

  Widget buildText(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 10,
          left: 12,
          child: buildUsername(context),
        ),
      ],
    );
  }

  Widget buildUsername(BuildContext context) {
    // Déterminez quelle URL utiliser
    final String profileImageUrl = useFirstUrl
        ? 'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fthumbnails%2F1693252778675.jpg?alt=media&token=1dbd3f28-152b-4112-9ef4-13c9d745a083'
        : 'https://firebasestorage.googleapis.com/v0/b/app6-f1b21.appspot.com/o/images%2Fusers%2FuserProfile_b37d34b8-4557-4a4e-812f-688a46a72471.jpg?alt=media&token=f19bf10c-5d85-4301-be66-bb022b473502'; // Remplacez ceci par votre deuxième URL

    // Basculez l'état pour la prochaine utilisation
    useFirstUrl = !useFirstUrl;

    return GestureDetector(
      onTap: () => _navigateToUserScreen(context),
      child: Row(
        children: [
          UserProfileImage(
            radius: 27,
            outerCircleRadius: 28,
            profileImageUrl: profileImageUrl,
          ),
          const SizedBox(width: 12),
          Text(
            'username',
            style: AppTextStyles.titlePost(context),
          ),
        ],
      ),
    );
  }

  void _navigateToUserScreen(BuildContext context) {
    GoRouter.of(context)
        .push('/user/9ZY3ogMKr6RvRm3PvHIq7hTBgKD2?username=userman1');
    ;
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

  Future<void> _animateCard(int swiperNumber) async {
    if (swiperNumber == 1) {
    } else {}

    // Réduire le délai pour un effet plus rapide
    await Future.delayed(Duration(milliseconds: 500)); // 500 millisecondes

    // Réinitialiser la couleur
    setState(() {
      if (swiperNumber == 1) {
      } else {}
    });
  }
}
