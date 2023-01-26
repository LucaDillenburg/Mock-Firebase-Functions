import 'package:flutter_test/flutter_test.dart';
import 'package:mock_firebase_functions/mock_firebase_functions.dart';

void main() {
  test('MockFirebaseFunctions.httpsCallable without definition will not fail', () {
    final functions = MockFirebaseFunctions();
    functions.httpsCallable('function1');
  });

  test('MockFirebaseFunctions.httpsCallable.call without definition should fail', () {
    final functions = MockFirebaseFunctions();
    expect(
      () => functions.httpsCallable('function1').call(),
      throwsA(isA<UnimplementedError>()),
    );
  });

  test('MockFirebaseFunctions.httpsCallable.call with definition by mock should resolve', () async {
    final functions = MockFirebaseFunctions();
    functions.mock(
      'function1',
      (body) async => MockHttpsCallableResult('Hello World'),
    );
    expect(
      (await functions.httpsCallable('function1').call()).data,
      'Hello World',
    );
  });

  test('MockFirebaseFunctions.httpsCallable.call with definition by constructor should resolve', () async {
    final functions = MockFirebaseFunctions({'function1': (body) async => MockHttpsCallableResult('Hello World')});

    expect(
      (await functions.httpsCallable('function1').call()).data,
      'Hello World',
    );
  });
}
