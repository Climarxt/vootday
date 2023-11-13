import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_coming_soon_event.dart';
part 'calendar_coming_soon_state.dart';

class CalendarComingSoonBloc
    extends Bloc<CalendarComingSoonEvent, CalendarComingSoonState> {
  final PostRepository _postRepository;

  CalendarComingSoonBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        super(CalendarComingSoonState.initial()) {
    on<CalendarComingSoonFetchEvent>(_mapCalendarComingSoonFetchEvent);
  }

  Future<void> _mapCalendarComingSoonFetchEvent(
    CalendarComingSoonFetchEvent event,
    Emitter<CalendarComingSoonState> emit,
  ) async {
    try {
      print(
          'Method _mapCalendarComingSoonFetchEvent: Fetching this week events...');
      final thisComingSoonEvents = await _postRepository
          .getComingSoonEvents(); // This should return List<Event>

      if (thisComingSoonEvents.isNotEmpty) {
        print(
            'Method _mapCalendarComingSoonFetchEvent: This week events fetched successfully.');
        emit(state.copyWith(
            thisComingSoonEvents: thisComingSoonEvents, // Update the state with the list
            status: CalendarComingSoonStatus.loaded));
      } else {
        print(
            'Method _mapCalendarComingSoonFetchEvent: No events found for this week.');
        emit(state.copyWith(
            thisComingSoonEvents: [], // Empty list indicates no events found
            status: CalendarComingSoonStatus.noEvents));
      }
    } catch (err) {
      print(
          'Method _mapCalendarComingSoonFetchEvent: Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarComingSoonStatus.error,
        failure: Failure(message: 'Unable to load the events'),
        thisComingSoonEvents: [],
      ));
    }
  }
}
