import 'package:bootdv2/screens/home/bloc/home_event/home_event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bootdv2/widgets/cards/mosaique_event_long_card.dart';

class HomeEvent extends StatefulWidget {
  const HomeEvent({super.key});

  @override
  _HomeEventState createState() => _HomeEventState();
}

class _HomeEventState extends State<HomeEvent>
    with AutomaticKeepAliveClientMixin<HomeEvent> {
  @override
  void initState() {
    super.initState();
    context.read<HomeEventBloc>().add(HomeEventFetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeEventBloc, HomeEventState>(
      builder: (context, state) {
        if (state.status == HomeEventStatus.loaded) {
          return Scaffold(
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 0.5,
              ),
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
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
        } else if (state.status == HomeEventStatus.loading) {
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
