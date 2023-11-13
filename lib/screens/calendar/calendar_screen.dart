import 'package:bootdv2/config/configs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/screens/calendar/bloc/latest/calendar_latest_bloc.dart';
import 'package:bootdv2/screens/calendar/bloc/this_week/calendar_this_week_bloc.dart';
import 'package:bootdv2/widgets/cards/event_new_card.dart';
import 'package:bootdv2/widgets/cards/mosaique_event_large_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  @override
  void initState() {
    super.initState();
    context.read<CalendarLatestBloc>().add(CalendarLatestFetchEvent());
    context.read<CalendarThisWeekBloc>().add(CalendarThisWeekFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
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
          buildSectionTitle(AppLocalizations.of(context)!.translate('new')),
          const SizedBox(height: 8),
          BlocBuilder<CalendarLatestBloc, CalendarLatestState>(
            builder: (context, latestState) {
              switch (latestState.status) {
                case CalendarLatestStatus.loaded:
                  final latestEvent = latestState.latestEvent ?? Event.empty;
                  return Expanded(
                    flex: 1,
                    child: EventNewCard(
                      imageUrl: latestEvent.logoUrl,
                      title: latestEvent.title,
                      description: latestEvent.caption,
                    ),
                  );
                case CalendarLatestStatus.loading:
                default:
                  // Shows a loading indicator while the state is not loaded
                  return const Expanded(
                    flex: 1,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.transparent),
                    ),
                  );
              }
            },
          ),
          const SizedBox(height: 8),
          buildSectionTitle(
              AppLocalizations.of(context)!.translate('thisweek')),
          // This Week Events Section
          BlocBuilder<CalendarThisWeekBloc, CalendarThisWeekState>(
            builder: (context, thisWeekState) {
              switch (thisWeekState.status) {
                case CalendarThisWeekStatus.loaded:
                  return buildListViewThisWeek(
                      size, thisWeekState.thisWeekEvents);
                case CalendarThisWeekStatus.loading:
                default:
                  return const Expanded(
                    flex: 1,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.transparent),
                    ),
                  );
              }
            },
          ),
          const SizedBox(height: 8),
          buildSectionTitle(
            AppLocalizations.of(context)!.translate('comingsoon'),
          ),
          BlocBuilder<CalendarThisWeekBloc, CalendarThisWeekState>(
            builder: (context, thisWeekState) {
              switch (thisWeekState.status) {
                case CalendarThisWeekStatus.loaded:
                  return buildListViewThisWeek(
                      size, thisWeekState.thisWeekEvents);
                case CalendarThisWeekStatus.loading:
                default:
                  return const Expanded(
                    flex: 1,
                    child: Center(child: CircularProgressIndicator()),
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildListViewThisWeek(Size size, List<Event?> events) {
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
