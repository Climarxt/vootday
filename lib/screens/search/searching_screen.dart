import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/screens/comment/widgets/widgets.dart';
import 'package:bootdv2/screens/search/cubit/search_cubit.dart';
import 'package:bootdv2/screens/search/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({super.key});

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  bool _isSearching = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state.status == SearchStatus.initial) {
          context.read<SearchCubit>();
        }
      },
      builder: (context, state) {
        return _buildBody(state, context);
      },
    );
  }

  Widget _buildBody(SearchState state, BuildContext context) {
    return Scaffold(
      appBar: AppBarComment(
        title: AppLocalizations.of(context)!.translate('search'),
      ),
      body: _buildBody1(state, context),
    );
  }

  Widget _buildBody1(SearchState state, BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBodySearch(context, size),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    if (_isSearching) {
      return AppBar(
        backgroundColor: mobileBackgroundColor,
        iconTheme: const IconThemeData(color: black),
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: black),
          onPressed: () {
            setState(() {
              _isSearching = false;
            });
            context.read<SearchCubit>().resetSearch();
          },
        ),
        title: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Search for a user',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            context.read<SearchCubit>().searchUsers(value);
          },
        ),
      );
    } else {
      return AppBar(
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        iconTheme: const IconThemeData(color: black),
        elevation: 3,
        leading: IconButton(
          icon: const Icon(Icons.calendar_month_sharp, color: black, size: 30),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              color: black,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          )
        ],
      );
    }
  }

  Widget _buildBodySearch(BuildContext context, Size size) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        switch (state.status) {
          case SearchStatus.error:
            return CenteredText(text: state.failure.message);
          case SearchStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case SearchStatus.loaded:
            return _buildLoadedState(context, state);
          default:
            return _buildDefaultState(size);
        }
      },
    );
  }

  Widget _buildLoadedState(BuildContext context, SearchState state) {
    return state.users.isNotEmpty
        ? ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = state.users[index];
              return ListTile(
                leading: UserProfileImage(
                  radius: 22.0,
                  outerCircleRadius: 23,
                  profileImageUrl: user.profileImageUrl,
                ),
                title: Text(
                  user.username,
                  style: const TextStyle(fontSize: 16.0),
                ),
                onTap: () =>
                    _navigateToUserScreen(context, user.id, user.username),
              );
            },
          )
        : const CenteredText(text: 'No users found');
  }

  void _navigateToUserScreen(
      BuildContext context, String userId, String username) {
    GoRouter.of(context).push('/user/$userId?username=$username');
    ;
  }

  Widget _buildDefaultState(Size size) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(color: white),
        ));
  }
}
