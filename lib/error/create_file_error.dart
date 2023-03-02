class CreateFileError implements Error {
  final Object? error;
  @override
  StackTrace? get stackTrace => throw UnimplementedError();

  CreateFileError(this.error);
}
