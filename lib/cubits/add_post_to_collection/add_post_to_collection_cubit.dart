import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_post_to_collection_state.dart';

class AddPostToCollectionCubit extends Cubit<AddPostToCollectionState> {
  AddPostToCollectionCubit() : super(AddPostToCollectionInitial());
}
