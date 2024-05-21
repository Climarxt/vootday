// ignore_for_file: unused_field

import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:bootdv2/screens/swipe/bloc/swipeevent/swipe_event_bloc.dart' as bloc;
import 'package:bootdv2/screens/swipe/widgets/custom_widgets.dart';
import 'package:bootdv2/screens/swipe/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';

class SwipeEvent extends StatefulWidget {
  const SwipeEvent({super.key});

  @override
  State<SwipeEvent> createState() => _SwipeEventState();
}

class _SwipeEventState extends State<SwipeEvent>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SwipeEvent> {
  final CardSwiperController controller1 = CardSwiperController();
  final CardSwiperController controller2 = CardSwiperController();
  final List<String> _imageUrls1 = [];
  final List<String> _imageUrls2 = [];
  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimation;
  late double verticalThresholdPercentageSave;
  late final UserRepository _userRepository;
  late Future<User> _userDetailsFuture;
  final List<Post> _posts1 = [];
  final List<Post> _posts2 = [];
  int _currentIndex1 = 0;
  int _currentIndex2 = 0;
  final bool _hasShownBottomSheet = false;

  @override
  void initState() {
    super.initState();
    // context.read<bloc.SwipeBloc>().add(bloc.SwipeFetchPostsOOTDWoman());
    // context.read<bloc.SwipeBloc>().add(bloc.SwipeFetchPostsOOTDMan());
    _userRepository = UserRepository();
    _userDetailsFuture = _userRepository
        .fetchUserDetails(context.read<AuthBloc>().state.user!.uid);
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

    return FutureBuilder<User>(
      future: _userDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(child: Text("Error: ${snapshot.error}")));
          }
          if (snapshot.hasData) {
            String? selectedGender = snapshot.data!.selectedGender;
            return _buildGenderSpecificBloc(selectedGender);
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildGenderSpecificBloc(String? selectedGender) {
    return BlocConsumer<bloc.SwipeEventBloc, bloc.SwipeEventState>(
      listener: (context, state) {
        if (state.status == bloc.SwipeEventStatus.loaded) {
          _loadImages(state.posts);
        }
      },
      builder: (context, state) {
        if (state.status == bloc.SwipeEventStatus.initial) {
          bloc.SwipeEventEvent event = selectedGender == "Masculin"
              ? bloc.SwipeEventManFetchPosts()
              : bloc.SwipeEventWomanFetchPosts();
          context.read<bloc.SwipeEventBloc>().add(event);
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Scaffold(
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  Widget _buildBody(bloc.SwipeEventState state) {
    switch (state.status) {
      case bloc.SwipeEventStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case bloc.SwipeEventStatus.loaded:
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

    return Bounceable(
      onTap: () => _navigateToPostScreen(context, post),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.transparent)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 12,
            child: buildUsername(context, post),
          ),
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
      var imageProvider = CachedNetworkImageProvider(imageUrl);
      precacheImage(imageProvider, context);

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
