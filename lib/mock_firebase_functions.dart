library mock_firebase_functions;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:mocktail/mocktail.dart';

typedef MockedFunction = Future<MockHttpsCallableResult> Function(dynamic parameters);

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {
  final Map<String, MockedFunction> mockedFunctions;
  MockFirebaseFunctions([Map<String, MockedFunction>? mockedFunctions])
      : mockedFunctions = mockedFunctions ?? Map.from({});

  void mock(String suffix, MockedFunction function) {
    mockedFunctions[suffix] = function;
  }

  @override
  HttpsCallable httpsCallable(String suffix, {HttpsCallableOptions? options}) {
    final function = mockedFunctions[suffix];

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
  Future<HttpsCallableResult<T>> call<T>([dynamic parameters]) async =>
      (await function(parameters)) as HttpsCallableResult<T>;
}

class MockHttpsCallableResult implements HttpsCallableResult<dynamic> {
  @override
  final dynamic data;
  MockHttpsCallableResult(this.data);
}
