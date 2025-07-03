import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'logging_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LoggingService _logger = LoggingService();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    _logger.logInfo('Starting Google sign-in process');

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _logger.logWarning('Google sign-in cancelled by user');
        return null;
      }

      _logger.logInfo(
        'Google user obtained',
        data: {
          'email': googleUser.email,
          'displayName': googleUser.displayName,
        },
      );

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      _logger.logAuthEvent(
        'sign_in_success',
        userId: userCredential.user?.uid,
        details: {
          'method': 'google',
          'email': userCredential.user?.email,
          'displayName': userCredential.user?.displayName,
        },
      );

      return userCredential;
    } catch (e, stackTrace) {
      _logger.logError(
        'Google sign-in failed',
        error: e,
        stackTrace: stackTrace,
      );
      _logger.logAuthEvent(
        'sign_in_failed',
        details: {'method': 'google', 'error': e.toString()},
      );
      return null;
    }
  }

  Future<void> signOut() async {
    final currentUserId = _auth.currentUser?.uid;

    _logger.logInfo(
      'Starting sign-out process',
      data: {'userId': currentUserId},
    );

    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      _logger.logAuthEvent(
        'sign_out_success',
        userId: currentUserId,
        details: {'method': 'google'},
      );
    } catch (e, stackTrace) {
      _logger.logError('Sign-out failed', error: e, stackTrace: stackTrace);
      _logger.logAuthEvent(
        'sign_out_failed',
        userId: currentUserId,
        details: {'method': 'google', 'error': e.toString()},
      );
    }
  }
}
