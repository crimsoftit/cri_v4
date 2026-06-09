class CExceptions implements Exception {
  // {@macro log_in_with_email_and_password_failure}
  const CExceptions([
    this.message = 'an unknown exception occurred! please try again later',
  ]);

  final String message;

  // -- create an authentication message from a firebase auth exception code
  factory CExceptions.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return const CExceptions('email address already exists!');

      case 'invalid-email':
        return const CExceptions(
            'email is either invalid or wrongly formatted!');

      case 'weak-password':
        return const CExceptions('please enter a stronger password!');

      case 'user-disabled':
        return const CExceptions(
            'this user has been disabled! please contact support for help.');

      case 'user-not-found':
        return const CExceptions(
            'invalid credentials! please create an account.');

      case 'wrong-password':
        return const CExceptions('wrong password! please try again.');

      case 'too-many-requests':
        return const CExceptions(
            'too many requests! service temporarily blocked.');

      case 'invalid-argument':
        return const CExceptions(
            'an invalid argument was provided to an authentication method!');

      case 'invalid-password':
        return const CExceptions('invalid password! please try again.');

      case 'invalid-phone-number':
        return const CExceptions('invalid phone number provided!');

      case 'operation-not-allowed':
        return const CExceptions(
            'the provided sign-in/sign-up provider is disabled!');

      case 'session-cookie-expired':
        return const CExceptions('your session has expired!');

      case 'uid-already-exists':
        return const CExceptions('user id (uid) is aleady in use!');

      default:
        return const CExceptions();
    }
  }
}
