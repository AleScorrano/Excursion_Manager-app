class AddReservationError implements Error {
  @override
  StackTrace? get stackTrace => throw UnimplementedError();
  final Object? error;
  AddReservationError(this.error);
}
