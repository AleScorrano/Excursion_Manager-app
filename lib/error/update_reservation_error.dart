class UpdateReservationError implements Error {
  final Object? error;
  @override
  StackTrace? get stackTrace => throw UnimplementedError();

  UpdateReservationError(this.error);
}
