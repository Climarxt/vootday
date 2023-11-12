import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_latest_event.dart';
part 'calendar_latest_state.dart';

class CalendarLatestEventBloc
    extends Bloc<CalendarLatestEventEvent, CalendarLatestEventState> {
  final PostRepository _postRepository;

  CalendarLatestEventBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        super(CalendarLatestEventState.initial()) {
    on<CalendarLatestEventFetchEvent>(_mapCalendarLatestEventFetchEvent);
  }

  Future<void> _mapCalendarLatestEventFetchEvent(
    CalendarLatestEventFetchEvent event,
    Emitter<CalendarLatestEventState> emit,
  ) async {
    try {
      print(
          'Method _mapCalendarLatestEventFetchEvent: Fetching latest event...');
      final latestEvent = await _postRepository.getLatestEvent();
      if (latestEvent != null) {
        print(
            'Method _mapCalendarLatestEventFetchEvent: Latest event fetched successfully.');
        emit(state.copyWith(
            latestEvent: latestEvent,
            status: CalendarLatestEventStatus.loaded));
      } else {
        print('Method _mapCalendarLatestEventFetchEvent: No events found.');
        emit(state.copyWith(
            latestEvent: null, status: CalendarLatestEventStatus.noEvents));
      }
    } catch (err) {
      print(
          'Method _mapCalendarLatestEventFetchEvent: Error fetching event - $err');
      emit(state.copyWith(
        status: CalendarLatestEventStatus.error,
        failure: Failure(message: 'Unable to load the event'),
      ));
    }
  }
}
