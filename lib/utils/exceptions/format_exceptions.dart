class CFormatExceptions implements Exception {
  // -- default constructor with a generic error message --
  CFormatExceptions(
      [this.message =
          'an unexpected format error occurred! please check your input.']);

  // -- the error message associated with the exception --
  final String message;

  // -- create a format exception from a specific error message --
  factory CFormatExceptions.fromMessage(String message) {
    return CFormatExceptions(message);
  }

  // -- get the corresponding error message --
  String get formattedMessage => message;

  // -- create a format exception from a specific error message --
  factory CFormatExceptions.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return CFormatExceptions(
            'the email address is invalid! please enter a valid email address.');
      case 'invalid-phone-number-format':
        return CFormatExceptions(
            'the provided phone number format is invalid! please enter a valid phone number.');
      case 'invalid-date-format':
        return CFormatExceptions(
            'the date format is invalid! please enter a valid date.');
      case 'invalid-url-format':
        return CFormatExceptions(
            'the URL format is invalid! please enter a valid URL.');
      case 'invalid-credit-card-format':
        return CFormatExceptions(
            'the credit card format is invalid! please enter a valid credit card.');
      case 'invalid-numeric-format':
        return CFormatExceptions('the input should be a valid numeric format!');
      default:
        return CFormatExceptions(
            'an unexpected firebase error occurred! please try again.');
    }
  }
}
