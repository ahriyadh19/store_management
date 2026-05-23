import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/auth_repository.dart';

void main() {
  group('AuthController registration gating', () {
    test('defaults to sign up when public registration is still open', () async {
      final controller = AuthController(
        authRepository: FakeAuthRepository(initialPublicRegistrationOpen: true),
        appPreferencesController: AppPreferencesController(),
      );

      addTearDown(controller.close);

      await controller.stream.firstWhere((state) => state.registrationAvailabilityResolved);

      expect(controller.state.publicRegistrationEnabled, isTrue);
      expect(controller.state.screen, AuthScreen.signUp);
      expect(controller.state.isAuthenticated, isFalse);
    });

    test('keeps public registration closed once an owner exists', () async {
      final controller = AuthController(
        authRepository: FakeAuthRepository(initialPublicRegistrationOpen: false),
        appPreferencesController: AppPreferencesController(),
      );

      addTearDown(controller.close);

      await controller.stream.firstWhere((state) => state.registrationAvailabilityResolved);

      expect(controller.state.publicRegistrationEnabled, isFalse);
      expect(controller.state.screen, AuthScreen.signIn);

      controller.add(const AuthScreenChanged(AuthScreen.signUp));
      await Future<void>.delayed(Duration.zero);

      expect(controller.state.screen, AuthScreen.signIn);
      expect(controller.state.status, AuthStatus.initial);
    });
  });
}