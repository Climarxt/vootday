import 'package:bootdv2/screens/home/bloc/event/feed_event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/widgets/cards/mosaique_event_long_card.dart';

class FeedCalendar extends StatefulWidget {
  const FeedCalendar({super.key});

  @override
  _FeedCalendarState createState() => _FeedCalendarState();
}

class _FeedCalendarState extends State<FeedCalendar>
    with AutomaticKeepAliveClientMixin<FeedCalendar> {
  @override
  void initState() {
    super.initState();
    context.read<FeedEventBloc>().add(FeedEventFetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FeedEventBloc, FeedEventState>(
      builder: (context, state) {
        if (state.status == FeedEventStatus.loaded) {
          return Scaffold(
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 0.5,
              ),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final event = state.posts[index];
                return event != null
                    ? MosaiqueEventLongCard(
                        imageUrl: event.imageUrl,
                        title: event.title,
                        logoUrl: event.author.logoUrl,
                      )
                    : const SizedBox.shrink();
              },
            ),
          );
        } else if (state.status == FeedEventStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text(state.failure.message));
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
