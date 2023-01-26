# Mock Firebase Functions

## Features

This can be used to mock FirebaseFunctions calls. It is best used in conjunction with dependency injection.

## Getting started

Run ```flutter pub add mock_firebase_functions``` and you are good to go.

## Usage

```dart
final functions = MockFirebaseFunctions();
functions.mock('function1', (body) {
    return 'Hello World';
});
final response = await functions.httpsCallable('function1').call({});
// response.result is 'Hello World'
```
