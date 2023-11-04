// ignore_for_file: avoid_print

import 'package:bootdv2/config/colors.dart';
import 'package:bootdv2/screens/home/bloc/ootd/feed_ootd_bloc.dart';
import 'package:bootdv2/widgets/cards/mosaique_event_large_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FeedOOTD extends StatefulWidget {
  FeedOOTD({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _FeedOOTDState createState() => _FeedOOTDState();
}

class _FeedOOTDState extends State<FeedOOTD>
    with AutomaticKeepAliveClientMixin<FeedOOTD> {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();
  bool _isFetching = false;

  List<String> imageList = [
    'assets/images/Stussy.png',
    'assets/images/postImage2.jpg',
    'assets/images/ITG1_2.jpg',
    'assets/images/Carhartt.png',
    'assets/images/Obey.png',
    'assets/images/Sandro.png',
  ];

  @override
  void initState() {
    super.initState();
    print('FeedOOTD initState()');
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    print('FeedOOTD is scrolling');
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isFetching &&
        context.read<FeedOOTDBloc>().state.status !=
            FeedOOTDStatus.paginating) {
      _isFetching = true;
      context.read<FeedOOTDBloc>().add(FeedOOTDPaginatePosts());
    }
  }

  @override
  void dispose() {
    print('FeedOOTD dispose()');
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    super.build(context);
    return BlocConsumer<FeedOOTDBloc, FeedOOTDState>(
      listener: (context, state) {
        if (state.status == FeedOOTDStatus.initial && state.posts.isEmpty) {
          context.read<FeedOOTDBloc>().add(FeedOOTDFetchPostsOOTD());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: buildListview(size),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => GoRouter.of(context).push('/event'),
            label: Text(
              "eventTest",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: white),
            ),
            backgroundColor: couleurJauneOrange,
          ),
        );
      },
    );
  }

  Widget buildListview(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SizedBox(
        height: size.height * 0.2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: MosaiqueEventLargeCard(
                imageUrl: imageList[index],
                title: 'Title',
                description: 'Description',
              ),
            );
          },
        ),
      ),
    );
  }

// Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
