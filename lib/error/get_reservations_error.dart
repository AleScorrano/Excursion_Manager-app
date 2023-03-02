class GetReservationsError implements Error {
  final Object? error;
  @override
  StackTrace? get stackTrace => throw UnimplementedError();

  GetReservationsError(this.error);
}
