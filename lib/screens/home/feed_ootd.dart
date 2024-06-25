import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/config/logger/logger.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/feed/feed_repository.dart';
import 'package:bootdv2/repositories/user/user_repository.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_bloc.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_state_base.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd_city/feed_ootd_city_bloc.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd_country/feed_ootd_country_bloc.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd_state/feed_ootd_state_bloc.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedOOTD extends StatefulWidget {
  FeedOOTD({Key? key}) : super(key: key ?? GlobalKey());

  @override
  _FeedOOTDState createState() => _FeedOOTDState();
}

class _FeedOOTDState extends State<FeedOOTD>
    with
        AutomaticKeepAliveClientMixin<FeedOOTD>,
        SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late final String? currentUserId;
  late final UserRepository _userRepository;
  late Future<User>? _userDetailsFuture;
  late TabController _tabController;
  final Map<int, ScrollController> _scrollControllers = {};

  late FeedOOTDCityBloc _cityBloc;
  late FeedOOTDStateBloc _stateBloc;
  late FeedOOTDCountryBloc _countryBloc;

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String tabCity = '';
  String tabState = '';
  String tabCountry = '';
  String? userGender;

  String? tempSelectedCountry;
  String? tempSelectedState;
  String? tempSelectedCity;

  final ContextualLogger logger = ContextualLogger('FeedOOTD');

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();
    _tabController = TabController(length: 3, vsync: this);

    final authState = context.read<AuthBloc>().state;
    final user = authState.user;

    if (user != null) {
      _userDetailsFuture = _userRepository.fetchUserDetails(user.uid);
      _userDetailsFuture!.then((user) {
        setState(() {
          tabCity = user.locationCity;
          tabState = user.locationState;
          tabCountry = user.locationCountry;
          userGender = user.selectedGender;
        });
      });
    } else {
      _userDetailsFuture = null;
    }

    _cityBloc = FeedOOTDCityBloc(
      feedRepository: context.read<FeedRepository>(),
      authBloc: context.read<AuthBloc>(),
    );
    _stateBloc = FeedOOTDStateBloc(
      feedRepository: context.read<FeedRepository>(),
      authBloc: context.read<AuthBloc>(),
    );
    _countryBloc = FeedOOTDCountryBloc(
      feedRepository: context.read<FeedRepository>(),
      authBloc: context.read<AuthBloc>(),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _tabController.dispose();
    _scrollControllers.values.forEach((controller) => controller.dispose());
    _cityBloc.close();
    _stateBloc.close();
    _countryBloc.close();
    super.dispose();
  }

  ScrollController _getScrollController(int tabIndex) {
    return _scrollControllers.putIfAbsent(tabIndex,
        () => ScrollController()..addListener(() => _onScroll(tabIndex)));
  }

  void _onScroll(int tabIndex) {
    final ScrollController controller = _scrollControllers[tabIndex]!;
    if (controller.position.atEdge) {
      if (controller.position.pixels != 0) {
        // At bottom of list
        if (tabIndex == 0) {
          final state = _cityBloc.state;
          if (state.status != FeedOOTDCityStatus.paginating) {
            _cityBloc.add(FeedOOTDCityManFetchMorePosts(
              locationCountry: tabCountry,
              locationState: tabState,
              locationCity: tabCity,
            ));
          }
        } else if (tabIndex == 1) {
          final state = _stateBloc.state;
          if (state.status != FeedOOTDStateStatus.paginating) {
            _stateBloc.add(FeedOOTDStateManFetchMorePosts(
              locationCountry: tabCountry,
              locationState: tabState,
            ));
          }
        } else if (tabIndex == 2) {
          final state = _countryBloc.state;
          if (state.status != FeedOOTDCountryStatus.paginating) {
            _countryBloc.add(FeedOOTDCountryManFetchMorePosts(
              locationCountry: tabCountry,
            ));
          }
        }
      }
    }
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
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(62),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TabBar(
                          padding: EdgeInsets.zero,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: const BoxDecoration(),
                          controller: _tabController,
                          labelStyle: AppTextStyles.labelSelectedStyle(context),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          unselectedLabelStyle:
                              AppTextStyles.labelUnselectedStyle(context),
                          tabs: [
                            Tab(
                                child: Text(tabCity,
                                    style: const TextStyle(fontSize: 14.0))),
                            Tab(
                                child: Text(tabState,
                                    style: const TextStyle(fontSize: 14.0))),
                            Tab(
                                child: Text(tabCountry,
                                    style: const TextStyle(fontSize: 14.0))),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _openSheet(context),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(Icons.map),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  BlocProvider.value(
                    value: _cityBloc,
                    child: _buildGenderSpecificBlocCity(selectedGender, 0),
                  ),
                  BlocProvider.value(
                    value: _stateBloc,
                    child: _buildGenderSpecificBlocState(selectedGender, 1),
                  ),
                  BlocProvider.value(
                    value: _countryBloc,
                    child: _buildGenderSpecificBlocCountry(selectedGender, 2),
                  ),
                ],
              ),
            );
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildGenderSpecificBlocCity(String? selectedGender, int tabIndex) {
    const String functionName = '_buildGenderSpecificBlocCity';
    logger.logInfo(functionName, 'Building gender-specific bloc for city',
        {'selectedGender': selectedGender});

    _cityBloc.add(FeedOOTDCityManFetchPostsByCity(
      locationCountry: tabCountry,
      locationState: tabState,
      locationCity: tabCity,
    ));

    if (selectedGender == "Masculin") {
      return BlocConsumer<FeedOOTDCityBloc, FeedOOTDCityState>(
        listener: (context, state) {
          if (state.status == FeedOOTDCityStatus.loaded) {
          } else if (state.status == FeedOOTDCityStatus.error) {
            logger.logError(
                functionName, 'Error loading posts for city (Masculin)');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyMasculin(state, tabIndex),
            ),
          );
        },
      );
    } else if (selectedGender == "Féminin") {
      return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
        listener: (context, state) {
          if (state.status == FeedOOTDStatus.loaded) {
          } else if (state.status == FeedOOTDStatus.error) {
            logger.logError(
                functionName, 'Error loading posts for city (Féminin)');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyFeminin(state, tabIndex),
            ),
          );
        },
      );
    } else {
      logger.logError(functionName, 'Invalid gender selected',
          {'selectedGender': selectedGender});
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildBodyMasculin<T extends FeedStateInterface>(
      T state, int tabIndex) {
    if (state.status == FeedOOTDCountryStatus.loading ||
        state.status == FeedOOTDStateStatus.loading ||
        state.status == FeedOOTDCityStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Stack(
        children: [
          ListView.separated(
            controller: _getScrollController(tabIndex),
            physics: const BouncingScrollPhysics(),
            cacheExtent: 10000,
            itemCount: state.posts.length + 1,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              if (index == state.posts.length) {
                return state.status == FeedOOTDStatus.paginating
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink();
              } else {
                final Post post = state.posts[index] ?? Post.empty;
                return PostView(
                  post: post,
                );
              }
            },
          ),
          if (state.status == FeedOOTDStatus.paginating)
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      );
    }
  }

  Widget _buildGenderSpecificBlocState(String? selectedGender, int tabIndex) {
    const String functionName = '_buildGenderSpecificBlocState';
    _stateBloc.add(FeedOOTDStateManFetchPostsByState(
      locationCountry: tabCountry,
      locationState: tabState,
    ));

    if (selectedGender == "Masculin") {
      return BlocConsumer<FeedOOTDStateBloc, FeedOOTDStateState>(
        listener: (context, state) {
          if (state.status == FeedOOTDStateStatus.loaded) {
          } else if (state.status == FeedOOTDStateStatus.error) {
            logger.logError(
                functionName, 'Error loading posts for state (Masculin)');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyMasculin(state, tabIndex),
            ),
          );
        },
      );
    } else if (selectedGender == "Féminin") {
      return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
        listener: (context, state) {
          if (state.status == FeedOOTDStatus.loaded) {
          } else if (state.status == FeedOOTDStatus.error) {
            logger.logError(
                functionName, 'Error loading posts for state (Féminin)');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyFeminin(state, tabIndex),
            ),
          );
        },
      );
    } else {
      logger.logError(functionName, 'Invalid gender selected',
          {'selectedGender': selectedGender});
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildGenderSpecificBlocCountry(String? selectedGender, int tabIndex) {
    const String functionName = '_buildGenderSpecificBlocCountry';
    _countryBloc.add(FeedOOTDCountryManFetchPostsByCountry(
      locationCountry: tabCountry,
    ));

    if (selectedGender == "Masculin") {
      return BlocConsumer<FeedOOTDCountryBloc, FeedOOTDCountryState>(
        listener: (context, state) {
          if (state.status == FeedOOTDCountryStatus.loaded) {
          } else if (state.status == FeedOOTDCountryStatus.error) {
            logger.logError(
                functionName, 'Error loading posts for country (Masculin)');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyMasculin(state, tabIndex),
            ),
          );
        },
      );
    } else if (selectedGender == "Féminin") {
      return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
        listener: (context, state) {
          if (state.status == FeedOOTDStatus.loaded) {
          } else if (state.status == FeedOOTDStatus.error) {
            logger.logError(
                functionName, 'Error loading posts for country (Féminin)');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyFeminin(state, tabIndex),
            ),
          );
        },
      );
    } else {
      logger.logError(functionName, 'Invalid gender selected',
          {'selectedGender': selectedGender});
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildBodyFeminin(FeedOOTDState state, int tabIndex) {
    switch (state.status) {
      case FeedOOTDStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            ListView.separated(
              controller: _getScrollController(tabIndex),
              physics: const BouncingScrollPhysics(),
              cacheExtent: 10000,
              itemCount: state.posts.length + 1,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                if (index == state.posts.length) {
                  return state.status == FeedOOTDStatus.paginating
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                } else {
                  final Post post = state.posts[index] ?? Post.empty;
                  return PostView(
                    post: post,
                  );
                }
              },
            ),
            if (state.status == FeedOOTDStatus.paginating)
              const Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
    }
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.translate('location'),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.black),
              ),
              const SizedBox(height: 10),
              CSCPicker(
                flagState: CountryFlag.DISABLE,
                onCountryChanged: (country) {
                  setState(() {
                    tempSelectedCountry = country;
                  });
                },
                onStateChanged: (state) {
                  setState(() {
                    tempSelectedState = state;
                  });
                },
                onCityChanged: (city) {
                  setState(() {
                    tempSelectedCity = city;
                  });
                },
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () {
                  setState(() {
                    tabCountry = tempSelectedCountry ?? tabCountry;
                    tabState = tempSelectedState ?? tabState;
                    tabCity = tempSelectedCity ?? tabCity;
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    AppLocalizations.of(context)!.translate('validate'),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
