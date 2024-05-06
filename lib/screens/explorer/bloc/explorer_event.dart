part of 'explorer_bloc.dart';

abstract class ExplorerEvent extends Equatable {
  const ExplorerEvent();

  @override
  List<Object?> get props => [];
}

class ExplorerFetchPostsMan extends ExplorerEvent {}

class ExplorerFetchPostsWoman extends ExplorerEvent {}