import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_this_week_event.dart';
part 'calendar_this_week_state.dart';

class CalendarThisWeekBloc
    extends Bloc<CalendarThisWeekEvent, CalendarThisWeekState> {
  final PostRepository _postRepository;

  CalendarThisWeekBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        super(CalendarThisWeekState.initial()) {
    on<CalendarThisWeekFetchEvent>(_mapCalendarThisWeekFetchEvent);
  }

  Future<void> _mapCalendarThisWeekFetchEvent(
    CalendarThisWeekFetchEvent event,
    Emitter<CalendarThisWeekState> emit,
  ) async {
    try {
      print(
          'Method _mapCalendarThisWeekFetchEvent: Fetching this week events...');
      final thisWeekEvents = await _postRepository
          .getThisWeekEvents(); // This should return List<Event>

      if (thisWeekEvents.isNotEmpty) {
        print(
            'Method _mapCalendarThisWeekFetchEvent: This week events fetched successfully.');
        emit(state.copyWith(
            thisWeekEvents: thisWeekEvents, // Update the state with the list
            status: CalendarThisWeekStatus.loaded));
      } else {
        print(
            'Method _mapCalendarThisWeekFetchEvent: No events found for this week.');
        emit(state.copyWith(
            thisWeekEvents: [], // Empty list indicates no events found
            status: CalendarThisWeekStatus.noEvents));
      }
    } catch (err) {
      print(
          'Method _mapCalendarThisWeekFetchEvent: Error fetching events - $err');
      emit(state.copyWith(
        status: CalendarThisWeekStatus.error,
        failure: Failure(message: 'Unable to load the events'),
        thisWeekEvents: [],
      ));
    }
  }
}
