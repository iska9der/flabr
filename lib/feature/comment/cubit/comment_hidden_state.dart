part of 'comment_hidden_cubit.dart';

class CommentHiddenState extends Equatable {
   const CommentHiddenState({ this.hiddenComments =const {}});

  final Set<String> hiddenComments;


  CommentHiddenState copyWith({Set<String>? hiddenComments}) {
    return CommentHiddenState(
    hiddenComments: hiddenComments ?? this.hiddenComments,
    );
  }

  @override
  List<Object> get props => [hiddenComments];
}
