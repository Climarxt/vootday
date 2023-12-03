import 'package:bloc/bloc.dart';
import 'package:bootdv2/blocs/blocs.dart';
import 'package:bootdv2/models/models.dart';
import 'package:bootdv2/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final PostRepository _postRepository;
  // final AuthBloc _authBloc;

  EventBloc({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        // _authBloc = authBloc,
        super(EventState.initial()) {
    on<EventFetchEvent>(_mapEventFetchEvent);
  }

  Future<void> _mapEventFetchEvent(
    EventFetchEvent fetchEvent,
    Emitter<EventState> emit,
  ) async {
    try {
      print('EventBloc: Fetching event ${fetchEvent.eventId}...');
      final Event? eventDetails =
          await _postRepository.getEventById(fetchEvent.eventId);
      if (eventDetails != null) {
        print('EventBloc: Event ${fetchEvent.eventId} fetched successfully.');
        emit(state.copyWith(event: eventDetails, status: EventStatus.loaded));
      } else {
        print('EventBloc: Event ${fetchEvent.eventId} not found.');
        emit(state.copyWith(event: null, status: EventStatus.noEvents));
      }
    } catch (err) {
      print('EventBloc: Error fetching event - $err');
      emit(state.copyWith(
        status: EventStatus.error,
        failure: Failure(message: 'Unable to load the event - $err'),
      ));
    }
  }
}
