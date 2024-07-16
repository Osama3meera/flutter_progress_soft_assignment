import 'package:dio/dio.dart';

sealed class RequestState<T> {
  const RequestState();
}

class Success<T> extends RequestState<T> {
  final T data;

  const Success({required this.data});
}

class Error<T> extends RequestState<T> {
  final DioException exception;

  const Error({required this.exception});
}