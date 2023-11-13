import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_this_week_event.dart';
part 'calendar_this_week_state.dart';

class CalendarThisWeekEventBloc
    extends Bloc<CalendarThisWeekEvent, CalendarThisWeekEventState> {
  final PostRepository _postRepository;

  CalendarThisWeekEventBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        super(CalendarThisWeekEventState.initial()) {
    on<CalendarThisWeekEventFetchEvent>(_mapCalendarThisWeekEventFetchEvent);
  }

  Future<void> _mapCalendarThisWeekEventFetchEvent(
    CalendarThisWeekEventFetchEvent event,
    Emitter<CalendarThisWeekEventState> emit,
  ) async {
    try {
      print(
          'Method _mapCalendarThisWeekEventFetchEvent: Fetching latest event...');
      final latestEvent = await _postRepository.getThisWeekEvent();
      if (latestEvent != null) {
        print(
            'Method _mapCalendarThisWeekEventFetchEvent: Latest event fetched successfully.');
        emit(state.copyWith(
            latestEvent: latestEvent,
            status: CalendarThisWeekStatus.loaded));
      } else {
        print('Method _mapCalendarThisWeekEventFetchEvent: No events found.');
        emit(state.copyWith(
            latestEvent: null, status: CalendarThisWeekStatus.noEvents));
      }
    } catch (err) {
      print(
          'Method _mapCalendarThisWeekEventFetchEvent: Error fetching event - $err');
      emit(state.copyWith(
        status: CalendarThisWeekStatus.error,
        failure: Failure(message: 'Unable to load the event'),
      ));
    }
  }
}
