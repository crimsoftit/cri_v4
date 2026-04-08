class CFirebaseExceptions implements Exception {
  // -- constructor that takes an error code --
  CFirebaseExceptions(this.code);

  // -- the error code associated with the exception --
  final String code;

  // -- get the corresponding error message based on the error code --
  String get message {
    switch (code) {
      case 'unknown':
        return 'an unknown firebase error occurred! please try again.';
      case 'invalid-custom-token':
        return 'the custom token format is incorrect! please check your custom token.';
      case 'custom-token-mismatch':
        return 'the custom token corresponds to a different audience!';
      case 'user-disabled':
        return 'the user account has been disabled';
      case 'user-not-found':
        return 'no user found for the supplied email or uID.';
      case 'invalid-email':
        return 'the e-mail address provided is invalid. please enter a valid email.';
      case 'email-already-in-use':
        return 'the email address is already registered! please use a different e-mail address.';
      case 'wrong-password':
        return 'incorrect password! please check your password and try again.';
      case 'weak-password':
        return 'your password is too weak! please choose a stronger password.';
      case 'provider-already-linked':
        return 'the account is already linked with another provider.';
      case 'operation-not-allowed':
        return 'this operation is not allowed! contact support for assistance.';
      case 'invalid-verification-code':
        return 'invalid verification code! please enter a valid code.';
      case 'invalid-verification-id':
        return 'invalid verification ID! please request a new verification code.';
      case 'captcha-check-failed':
        return 'the reCAPTCHA response is invalid! please try again.';
      case 'app-not-authorized':
        return 'the app is not authorized to use Firebase Authentication with the supplied API key!';
      case 'keychain-error':
        return 'a keychain error occurred! please check the keychain and try again.';
      case 'internal-error':
        return 'an internal authentication error occurred! please try again later.';
      case 'invalid-app-credential':
        return 'invalid-app-credential.';
      case 'quota-exceeded':
        return 'quota exceeded! please try again later.';
      case 'account-exists-with-different-credential':
        return 'an account already exists with the same email but different sign-in credentials.';
      case 'app-deleted':
        return 'the app\'s Firebase instance has been deleted.';
      case 'email-already-exists':
        return 'the email address already exists! please use a different e-mail address.';
      case 'requires-recent-login':
        return 'this operation is sensitive & requires recent authentication! please sign in again.';
      case 'uid-already-exists':
        return 'the provided user ID is already in use by another user!';
      case 'credential-already-in-use':
        return 'this credential is already linked with another provider!';
      case 'user-mismatch':
        return 'the supplied credentials do not correspond with the previously signed in user!';
      case 'expired-action-code':
        return 'the action code has expired! please request a new action code.';
      case 'invalid-action-code':
        return 'invalid action code! please check the code and try again.';
      case 'missing-action-code':
        return 'the action code is missing! please provide a valid action code.';
      case 'missing-app-credential':
        return 'the app credential is missing! please provide a valid app credential.';
      case 'user-token-mismatch':
        return 'the user\'s token has a mismatch with the authenticated user\'s ID!';
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
        return 'the email template is missing the iframe start tag!';
      case 'missing-iframe-end':
        return 'the email template is missing the iframe end tag!';
      case 'missing-iframe-src':
        return 'the email template is missing the iframe src attribute!';
      case 'web-storage-unsupported':
        return 'web storage is either not supported or disabled!';
      case 'auth-domain-config-required':
        return 'the authDomain configuration is required for the action code verification link!';
      default:
        return 'an unexpected firebase error occurred! please try again later.';
    }
  }
}
