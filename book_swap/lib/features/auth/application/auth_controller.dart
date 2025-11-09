import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

// This provider will be watched by the UI to show loading states
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncData(null));

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _authRepository.signUp(email, password),
    );
  }

  Future<void> logIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _authRepository.logIn(email, password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _authRepository.signOut(),
    );
  }
}
