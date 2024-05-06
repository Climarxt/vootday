// ignore_for_file: unused_field

import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/swipe/bloc/swipe_bloc.dart';
import 'package:bootdv2/screens/swipe/widgets/custom_widgets.dart';
import 'package:bootdv2/screens/swipe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';

class SwipeOOTD extends StatefulWidget {
  const SwipeOOTD({super.key});

  @override
  State<SwipeOOTD> createState() => _SwipeOOTDState();
}

class _SwipeOOTDState extends State<SwipeOOTD>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SwipeOOTD> {
  final CardSwiperController controller1 = CardSwiperController();
  final CardSwiperController controller2 = CardSwiperController();
  final List<String> _imageUrls1 = [];
  final List<String> _imageUrls2 = [];
  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimation;
  late double verticalThresholdPercentageSave;
  List<Post> _posts1 = [];
  List<Post> _posts2 = [];
  int _currentIndex1 = 0;
  int _currentIndex2 = 0;
  bool _hasShownBottomSheet = false;

  @override
  void initState() {
    super.initState();
    context.read<SwipeBloc>().add(SwipeFetchPostsOOTD());
    _heartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _heartAnimation = Tween(begin: 65.0, end: 85.0).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.ease,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<SwipeBloc, SwipeState>(
      listener: (context, state) {
        // debugPrint("DEBUG : state : $state - context: $context ");
        if (state.status == SwipeStatus.loaded) {
          _loadImages(state.posts);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Scaffold(
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  Widget _buildBody(SwipeState state) {
    switch (state.status) {
      case SwipeStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SwipeStatus.loaded:
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
                      allowedSwipeDirection: allowedSwipeDirection(),
                      padding: swiperPaddingLeft(),
                      cardBuilder: (context,
                              index,
                              horizontalThresholdPercentage,
                              verticalThresholdPercentage) =>
                          _buildCard(
                              _imageUrls1[_currentIndex1],
                              verticalThresholdPercentage.toDouble(),
                              _posts1[_currentIndex1]),
                      cardsCount: _imageUrls1.length,
                      controller: controller1,
                      onSwipe: (previousIndex, currentIndex, direction) {
                        if (direction == CardSwiperDirection.top ||
                            direction == CardSwiperDirection.bottom) {
                          _changeImage(1);
                          _changeImage(2);
                        }
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
                      allowedSwipeDirection: allowedSwipeDirection(),
                      padding: swiperPaddingRight(),
                      cardBuilder: (context,
                              index,
                              horizontalThresholdPercentage,
                              verticalThresholdPercentage) =>
                          _buildCard(
                              _imageUrls2[_currentIndex2],
                              verticalThresholdPercentage.toDouble(),
                              _posts2[_currentIndex2]),
                      cardsCount: _imageUrls2.length,
                      controller: controller2,
                      onSwipe: (previousIndex, currentIndex, direction) {
                        debugPrint(
                            "previousIndex: $previousIndex, currentIndex: $currentIndex, direction: $direction ");
                        if (direction == CardSwiperDirection.top ||
                            direction == CardSwiperDirection.bottom) {
                          _changeImage(1);
                          _changeImage(2);
                        }

                        return true;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return Container(color: white);
    }
  }

  Widget _buildCard(
      String imageUrl, double verticalSwipePercentage, Post post) {
    bool shouldAnimateUp = verticalSwipePercentage < -150;
    bool shouldAnimatetDown = verticalSwipePercentage > 150;
    // debugPrint("DEBUG : post: $post");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shouldAnimateUp || shouldAnimatetDown) {
        _heartAnimationController.repeat(reverse: true);
        ;
      } else {
        _heartAnimationController.reset();
      }
    });

    return Bounceable(
      onTap: () => _navigateToPostScreen(context, post),
      child: Stack(
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
          /* Container(
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
          ), */
          Positioned(
            top: 10,
            left: 12,
            child: buildUsername(context, post),
          ),
          // Heart Animation
          if (shouldAnimateUp || shouldAnimatetDown)
            Center(
              child: AnimatedBuilder(
                animation: _heartAnimationController,
                builder: (context, _) {
                  return Icon(
                    Icons.favorite,
                    color: couleurBleuClair2,
                    size: _heartAnimation.value,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildUsername(BuildContext context, Post state) {
    return GestureDetector(
      onTap: () => _navigateToUserScreen(context, state),
      child: Row(
        children: [
          UserProfileImage(
            radius: 23,
            outerCircleRadius: 24,
            profileImageUrl: state.author.profileImageUrl,
          ),
          const SizedBox(width: 12),
          Text(
            state.author.username,
            style: AppTextStyles.titlePost(context),
          ),
        ],
      ),
    );
  }

  void _navigateToUserScreen(BuildContext context, Post state) {
    GoRouter.of(context)
        .push('/user/${state.author.id}?username=${state.author.username}');
  }

  void _navigateToPostScreen(BuildContext context, Post state) {
    final username = state.author.username;
    GoRouter.of(context).push('/post/${state.id}?username=$username');
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

  void _loadImages(List<Post> posts) {
    _imageUrls1.clear();
    _imageUrls2.clear();
    _posts1.clear();
    _posts2.clear();

    bool addToFirstList = true;
    for (var post in posts) {
      var imageUrl = post.imageUrl;
      if (addToFirstList) {
        _imageUrls1.add(imageUrl);
        _posts1.add(post);
      } else {
        _imageUrls2.add(imageUrl);
        _posts2.add(post);
      }
      addToFirstList = !addToFirstList;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
