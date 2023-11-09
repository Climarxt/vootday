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
    // S'abonner aux événements dès que le widget est initialisé
    context.read<FeedEventBloc>().add(FeedEventFetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Appel à super.build est nécessaire lorsque vous utilisez AutomaticKeepAliveClientMixin
    return BlocBuilder<FeedEventBloc, FeedEventState>(
      builder: (context, state) {
        if (state.status == FeedEventStatus.loaded) {
          // Assurez-vous d'utiliser state.events.length pour itemCount
          return Scaffold(
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 0.5,
              ),
              itemCount:
                  state.posts.length, // Utilisez state.events.length ici
              itemBuilder: (context, index) {
                final event = state.posts[index];
                return event != null
                    ? MosaiqueEventLongCard(
                        context,
                        imageUrl: event.imageUrl,
                        title: event.title,
                        logoUrl: event.author
                            .logoUrl, // Assurez-vous que cette propriété existe dans votre modèle Event
                      )
                    : const SizedBox.shrink();
              },
            ),
          );
        } else if (state.status == FeedEventStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // Gérer les cas d'erreur
          return Center(child: Text(state.failure.message));
        }
      },
    );
  }

  // Override pour indiquer que vous voulez conserver l'état du widget
  @override
  bool get wantKeepAlive => true;
}
