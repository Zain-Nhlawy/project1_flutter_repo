abstract class RagState {
  const RagState();
}

class RagInitial extends RagState {
  const RagInitial();
}

class RagLoading extends RagState {
  const RagLoading();
}

class RagLoaded extends RagState {
  final dynamic rawResponse;
  const RagLoaded(this.rawResponse);
}

class RagError extends RagState {
  final String message;
  const RagError(this.message);
}
