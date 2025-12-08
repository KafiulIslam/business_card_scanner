import 'package:firebase_auth/firebase_auth.dart' as fb;

class FirebaseAuthService {
  final fb.FirebaseAuth _auth;

  FirebaseAuthService({fb.FirebaseAuth? auth})
      : _auth = auth ?? fb.FirebaseAuth.instance;

  Future<fb.User> createUserWithEmail(
      {required String email, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = credential.user;
    if (user == null) {
      throw Exception('Signup failed: user is null');
    }
    return user;
  }

  Future<fb.User> signInWithEmail(
      {required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = credential.user;
    if (user == null) {
      throw Exception('Login failed: user is null');
    }
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }
    await user.delete();
  }

}
