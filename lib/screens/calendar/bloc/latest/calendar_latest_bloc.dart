import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'calendar_latest_event.dart';
part 'calendar_latest_state.dart';

class CalendarLatestBloc
    extends Bloc<CalendarLatestEvent, CalendarLatestState> {
  final PostRepository _postRepository;

  CalendarLatestBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        super(CalendarLatestState.initial()) {
    on<CalendarLatestFetchEvent>(_mapCalendarLatestFetchEvent);
  }

  Future<void> _mapCalendarLatestFetchEvent(
    CalendarLatestFetchEvent event,
    Emitter<CalendarLatestState> emit,
  ) async {
    try {
      print(
          'Method _mapCalendarLatestFetchEvent: Fetching latest event...');
      final latestEvent = await _postRepository.getLatestEvent();
      if (latestEvent != null) {
        print(
            'Method _mapCalendarLatestFetchEvent: Latest event fetched successfully.');
        emit(state.copyWith(
            latestEvent: latestEvent,
            status: CalendarLatestStatus.loaded));
      } else {
        print('Method _mapCalendarLatestFetchEvent: No events found.');
        emit(state.copyWith(
            latestEvent: null, status: CalendarLatestStatus.noEvents));
      }
    } catch (err) {
      print(
          'Method _mapCalendarLatestFetchEvent: Error fetching event - $err');
      emit(state.copyWith(
        status: CalendarLatestStatus.error,
        failure: Failure(message: 'Unable to load the event'),
      ));
    }
  }
}
