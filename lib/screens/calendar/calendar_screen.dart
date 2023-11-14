import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/calendar/bloc/coming_soon/calendar_coming_soon_bloc.dart';
import 'package:bootdv2/screens/calendar/bloc/latest/calendar_latest_bloc.dart';
import 'package:bootdv2/screens/calendar/bloc/this_week/calendar_this_week_bloc.dart';
import 'package:bootdv2/screens/event/widgets/event_new_card.dart';
import 'package:bootdv2/screens/event/widgets/mosaique_event_large_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarLatestBloc>().add(CalendarLatestFetchEvent());
    context.read<CalendarThisWeekBloc>().add(CalendarThisWeekFetchEvent());
    context.read<CalendarComingSoonBloc>().add(CalendarComingSoonFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrlnull =
        'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fred_placeholder_logo.svg?alt=media&token=4fa5d78e-eb9b-4ac9-840f-5def6929c38d';

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 62,
        title: Text(
          AppLocalizations.of(context)!.translate('event'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: black),
        ),
        backgroundColor: white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This New Event Section
          buildSectionTitle(AppLocalizations.of(context)!.translate('new')),
          const SizedBox(height: 8),
          BlocBuilder<CalendarLatestBloc, CalendarLatestState>(
            builder: (context, latestState) {
              switch (latestState.status) {
                case CalendarLatestStatus.loaded:
                  final latestEvent = latestState.latestEvent ?? Event.empty;
                  String authorName = latestEvent.author.author;
                  return Expanded(
                    flex: 1,
                    child: EventNewCard(
                      imageUrl: latestEvent.logoUrl,
                      title: latestEvent.title,
                      description: latestEvent.caption,
                      eventId: latestEvent.id,
                      author: authorName,
                    ),
                  );
                case CalendarLatestStatus.loading:
                default:
                  return Expanded(
                    flex: 1,
                    child: Container(color: white)
                  );
              }
            },
          ),
          const SizedBox(height: 8),
          // This Week Events Section
          buildSectionTitle(
              AppLocalizations.of(context)!.translate('thisweek')),
          BlocBuilder<CalendarThisWeekBloc, CalendarThisWeekState>(
            builder: (context, thisWeekState) {
              switch (thisWeekState.status) {
                case CalendarThisWeekStatus.loaded:
                  return buildListViewEvents(
                      size, thisWeekState.thisWeekEvents);
                case CalendarThisWeekStatus.loading:
                default:
                  return buildListViewEventsLoading(size);
              }
            },
          ),
          const SizedBox(height: 8),
          // This Coming Soon Events Section
          buildSectionTitle(
            AppLocalizations.of(context)!.translate('comingsoon'),
          ),
          BlocBuilder<CalendarComingSoonBloc, CalendarComingSoonState>(
            builder: (context, thisWeekState) {
              switch (thisWeekState.status) {
                case CalendarComingSoonStatus.loaded:
                  return buildListViewEvents(
                      size, thisWeekState.thisComingSoonEvents);
                case CalendarComingSoonStatus.loading:
                default:
                  return buildListViewEventsLoading(size);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildListViewEvents(Size size, List<Event?> events) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SizedBox(
        height: size.height * 0.2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) {
            Event event = events[index] ?? Event.empty;
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: MosaiqueEventLargeCard(
                imageUrl: event.logoUrl,
                title: event.title,
                description: event.caption,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildListViewEventsLoading(Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SizedBox(
        height: size.height * 0.2,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Container(color: white)
            );
          },
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 5.0, top: 5.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.black),
      ),
    );
  }
}
