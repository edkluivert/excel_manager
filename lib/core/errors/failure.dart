class Failure implements Exception {
  const Failure(this.message, {this.cause, this.stackTrace});
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;
  @override String toString() => 'Failure($message)';
}
