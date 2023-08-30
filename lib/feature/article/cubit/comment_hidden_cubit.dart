import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'comment_hidden_state.dart';

class CommentHiddenCubit extends Cubit<CommentHiddenState> {
  CommentHiddenCubit() : super(const CommentHiddenState());

  bool isHidden(String id) {
    return state.hiddenComments.contains(id);
  }

  void _hide(String id) {
    if (isHidden(id)) {
      return;
    }

    emit(state.copyWith(
      hiddenComments: Set.from({...state.hiddenComments, id}),
    ));
  }

  void _show(String id) {
    if (!isHidden(id)) {
      return;
    }

    final Set<String> newSet = Set.from(state.hiddenComments)..remove(id);

    emit(state.copyWith(hiddenComments: newSet));
  }

  void setIsHidden(String id, bool isHidden) {
    if (isHidden) {
      _hide(id);
    } else {
      _show(id);
    }
  }
}
