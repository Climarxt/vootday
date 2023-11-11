import 'package:bootdv2/models/event_model.dart';
import 'package:bootdv2/screens/home/bloc/home_event/home_event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/widgets/cards/mosaique_event_long_card.dart';

class HomeEvent extends StatefulWidget {
  HomeEvent({Key? key}) : super(key: key ?? GlobalKey());

  @override
  // ignore: library_private_types_in_public_api
  _HomeEventState createState() => _HomeEventState();
}

class _HomeEventState extends State<HomeEvent>
    with AutomaticKeepAliveClientMixin<HomeEvent> {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    Future.delayed(Duration.zero, () {
      context.read<HomeEventBloc>().add(HomeEventFetchEvents());
    });
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isFetching &&
        context.read<HomeEventBloc>().state.status !=
            HomeEventStatus.paginating) {
      _isFetching = true;
      context.read<HomeEventBloc>().add(HomeEventPaginateEvents());
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<HomeEventBloc, HomeEventState>(
      listener: (context, state) {
        if (state.status == HomeEventStatus.initial && state.events.isEmpty) {
          context.read<HomeEventBloc>().add(HomeEventFetchEvents());
        }
      },
      builder: (context, state) {
        return Scaffold(body: _buildBody(state));
      },
    );
  }

  Widget _buildBody(HomeEventState state) {
    return Stack(
      children: [
        GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 0.5,
          ),
          itemCount: state.events.length + 1,
          itemBuilder: (context, index) {
            if (index == state.events.length) {
              return state.status == HomeEventStatus.paginating
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            } else {
              final event = state.events[index] ?? Event.empty;
              return MosaiqueEventLongCard(
                imageUrl: event.imageUrl,
                title: event.title,
                logoUrl: event.author.logoUrl,
                eventId: event.id,
              );
            }
          },
        ),
        if (state.status == HomeEventStatus.paginating)
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  // Overridden to retain the state
  @override
  bool get wantKeepAlive => true;
}
