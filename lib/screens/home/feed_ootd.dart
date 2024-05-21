import 'package:bootdv2/blocs/auth/auth_bloc.dart';
import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/user/user_repository.dart';
import 'package:bootdv2/screens/home/bloc/blocs.dart';
import 'package:bootdv2/screens/home/bloc/feed_ootd/feed_ootd_bloc.dart';
import 'package:bootdv2/screens/home/widgets/tabbar3items_second.dart';
import 'package:bootdv2/screens/home/widgets/widgets.dart';
import 'package:csc_picker/csc_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedOOTD extends StatefulWidget {
  FeedOOTD({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
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
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    _userRepository = UserRepository();
    _tabController = TabController(length: 3, vsync: this);

    final authState = context.read<AuthBloc>().state;
    final user = authState.user;

    if (user != null) {
      _userDetailsFuture = _userRepository.fetchUserDetails(user.uid);
    } else {
      _userDetailsFuture = null;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_userDetailsFuture == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

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
                child: Tabbar3itemsSecond(
                  tabController: _tabController,
                  context: context,
                  onMapIconPressed: () =>
                      _openSheet(context), // Provide the callback
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildGenderSpecificBloc(selectedGender),
                  Container(color: Colors.blue),
                  Container(color: Colors.red),
                ],
              ),
            );
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
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
                    selectedCountry = country;
                    selectedState = null;
                    selectedCity = null;
                  });
                },
                onStateChanged: (state) {
                  setState(() {
                    selectedState = state;
                    selectedCity = null;
                  });
                },
                onCityChanged: (city) {
                  setState(() {
                    selectedCity = city;
                  });
                },
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  backgroundColor: couleurBleuClair2,
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

  Widget _buildGenderSpecificBloc(String? selectedGender) {
    if (selectedGender == "Masculin") {
      return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
        listener: (context, state) {
          context.read<FeedOOTDBloc>().add(FeedOOTDManFetchPostsOOTD());
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyMasculin(state),
            ),
          );
        },
      );
    } else if (selectedGender == "Féminin") {
      return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
        listener: (context, state) {
          context.read<FeedOOTDBloc>().add(FeedOOTDFemaleFetchPostsOOTD());
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Scaffold(
              body: _buildBodyFeminin(state),
            ),
          );
        },
      );
    } else {
      debugPrint("Executing fallback code");
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildBodyMasculin(FeedOOTDState state) {
    switch (state.status) {
      case FeedOOTDStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            ListView.separated(
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

  Widget _buildBodyFeminin(FeedOOTDState state) {
    switch (state.status) {
      case FeedOOTDStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return Stack(
          children: [
            ListView.separated(
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

  @override
  bool get wantKeepAlive => true;
}
