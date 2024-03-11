import 'package:endless_runner/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseApp extends Mock implements FirebaseApp {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

void main() {
  final mockFirebaseAuth = MockFirebaseAuth();
  final mockFirebaseApp = MockFirebaseApp();
  final mockUserCredential = MockUserCredential();
  final mockUser = MockUser();

  late final AuthService authService;

  // Initialize Firebase App
  setupFirebaseAuthMocks();
  setUp(() async {
    await Firebase.initializeApp();

    authService = AuthService(app: mockFirebaseApp, auth: mockFirebaseAuth);

    when(() => mockFirebaseApp.name).thenReturn('testApp');
    when(() => mockFirebaseAuth.signInAnonymously())
        .thenAnswer((_) => Future.value(mockUserCredential));
    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockUser.uid).thenReturn('testUser');
  });

  group('AuthService', () {
    test('signInAnonymously signs in', () async {
      await authService.signInAnonymously();

      verify(() => mockFirebaseAuth.signInAnonymously()).called(1);
      verify(() => mockUserCredential.user).called(1);
      verify(() => mockUser.uid).called(1);
    });
  });
}
