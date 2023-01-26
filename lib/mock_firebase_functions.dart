library mock_firebase_functions;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:mocktail/mocktail.dart';

typedef MockedFunction = Future<dynamic> Function(dynamic parameters);

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {
  final Map<String, MockedFunction> _mockedFunctions;
  MockFirebaseFunctions([Map<String, MockedFunction>? mockedFunctions])
      : _mockedFunctions = mockedFunctions ?? Map.from({});

  void mock(String suffix, MockedFunction function) {
    _mockedFunctions[suffix] = function;
  }

  @override
  HttpsCallable httpsCallable(String suffix, {HttpsCallableOptions? options}) {
    final function = _mockedFunctions[suffix];

    if (function == null) {
      return MockHttpsCallable((_) => throw UnimplementedError());
    }

    return MockHttpsCallable(function);
  }

  @override
  void useFunctionsEmulator(String host, int port) {}
}

class MockHttpsCallable extends Mock implements HttpsCallable {
  final MockedFunction function;
  MockHttpsCallable(this.function);

  @override
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async {
    final response = await function(parameters);
    return MockHttpsCallableResult<T>(response);
  }
}

class MockHttpsCallableResult<T> implements HttpsCallableResult<T> {
  @override
  final T data;
  MockHttpsCallableResult(this.data);
}
