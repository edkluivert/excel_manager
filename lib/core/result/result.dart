sealed class Result<T> {
  const Result();
  bool get isSuccess => this is Success<T>;
  T get data => (this as Success<T>).value;
  Object get error => (this as Failure<T>).error;
}
class Success<T> extends Result<T> { const Success(this.value); final T value; }
class Failure<T> extends Result<T> {
  const Failure(this.error); @override
  final Object error; }
