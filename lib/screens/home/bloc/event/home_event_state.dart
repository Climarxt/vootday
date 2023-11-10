part of 'home_event_bloc.dart';

enum FeedEventStatus { initial, loading, loaded, paginating, error }

class FeedEventState extends Equatable {
  final List<Event?> events;
  final FeedEventStatus status;
  final Failure failure;

  const FeedEventState({
    required this.events,
    required this.status,
    required this.failure,
  });

  factory FeedEventState.initial() {
    return const FeedEventState(
      events: [],
      status: FeedEventStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [events, status, failure];

  FeedEventState copyWith({
    List<Event?>? events,
    FeedEventStatus? status,
    Failure? failure
  }) {
    return FeedEventState(
      events: events ?? this.events,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
