class CFirebaseAuthExceptions implements Exception {
  // -- constructor that takes an error code --
  CFirebaseAuthExceptions(this.code);

  // -- the error code associated with the exception --
  final String code;

  // -- get the corresponding error message based on the error code --
  String get message {
    switch (code) {
      case 'unknown':
        return 'an unknown database error occurred! please try again';
      case 'invalid-custom-token':
        return 'the custom token format is invalid! please check your custom token and try again.';
      case 'custom-token-mismatch':
        return 'the custom token corresponds to a different audience!';
      case 'email-already-in-use':
        return 'the email address is already registered! please use a different e-mail address.';
      case 'invalid-email':
        return 'the e-mail address provided is invalid. please enter a valid email.';
      case 'weak-password':
        return 'your password is too weak! please choose a stronger password.';
      case 'user-disabled':
        return 'this user account has been disabled! please contact support for assistance.';
      case 'user-not-found':
        return 'invalid login details! user not found.';
      case 'wrong-password':
        return 'incorrect password! please check your password and try again.';
      case 'invalid-verification-code':
        return 'invalid verification code! please enter a valid code.';
      case 'invalid-verification-id':
        return 'invalid verification ID! please request a new verification code.';
      case 'quota-exceeded':
        return 'quota exceeded! please try again later.';
      case 'email-already-exists':
        return 'the email address already exists! please use a different e-mail address.';
      case 'provider-already-linked':
        return 'the account is already linked with another provider.';
      case 'requires-recent-login':
        return 'this operation is sensitive & requires recent authentication! please sign in again.';
      case 'credential-already-in-use':
        return 'this credential is already linked with another provider!';
      case 'user-mismatch':
        return 'the supplied credentials do not correspond with the previously signed in user!';
      case 'account-exists-with-different-credential':
        return 'an account already exists with the same email but different sign-in credentials.';
      case 'operation-not-allowed':
        return 'this operation is not allowed! contact support for assistance.';
      case 'expired-action-code':
        return 'the action code has expired! please request a new action code.';
      case 'invalid-action-code':
        return 'invalid action code! please check the code and try again.';
      case 'missing-action-code':
        return 'the action code is missing! please provide a valid action code.';
      case 'user-token-expired':
        return 'the user\'s token has expired, and re-authentication is required. please sign in again.';
      case 'invalid-credential':
        return 'the supplied credential is malformed or has expired!';
      case 'user-token-revoked':
        return 'the user\'s token has been revoked! please sign in again.';
      case 'invalid-message-payload':
        return 'the email template verification message payload is invalid!';
      case 'invalid-sender':
        return 'the email template sender is invalid! please verify the sender\'s e-mail address.';
      case 'invalid-recipient-email':
        return 'the recipient email address is invalid! please provide a valid recipient e-mail address.';
      case 'missing-iframe-start':
        return 'missing-iframe-start.';

      default:
        return 'an unexpected firebase error occurred! please try again.';
    }
  }
}
