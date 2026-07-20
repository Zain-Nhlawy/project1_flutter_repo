import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/domain/use_case/get_tags_usecase.dart';
import 'package:project1/features/course/presentation/cubit/tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  final GetTagsUseCase getTagsUseCase;

  TagsCubit({required this.getTagsUseCase}) : super(const TagsInitial());

  Future<void> fetchTags() async {
    emit(const TagsLoading());
    final result = await getTagsUseCase();
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(TagsError(failure.errors ?? [failure.message]));
        }
      },
      (tags) {
        if (!isClosed) {
          emit(TagsLoaded(tags));
        }
      },
    );
  }
}
