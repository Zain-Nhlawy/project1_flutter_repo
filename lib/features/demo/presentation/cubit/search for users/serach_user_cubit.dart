import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/domain/use%20case/demo_users_usecase.dart';
import 'search_user_state.dart';

class SearchUserCubit extends Cubit<SearchUserState> {
  final DemoUsersUsecase usecase;

  SearchUserCubit(this.usecase) : super(SearchUserInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchUserInitial());
      return;
    }

    emit(SearchUserLoading());

    try {
      final result = await usecase.search(query);

      result.fold((error) => emit(SearchUserError(error)), (users) {
        if (users.isEmpty) {
          emit(SearchUserEmpty());
        } else {
          emit(SearchUserLoaded(users));
        }
      });
    } catch (e) {
      emit(SearchUserError(e.toString()));
    }
  }
}
