class CDateTimeComputations {
  static int timeRangeFromNow(String comparison) {
    final currentTime = DateTime.now();
    final endTime = DateTime.parse(comparison);

    var differenceInHrs = (endTime.difference(currentTime).inHours / 24)
        .round();

    return differenceInHrs;
  }

  static String timeRangeTillNow(String comparison) {
    final currentTime = DateTime.now();
    var formattedRange = '';

    final startTime = DateTime.parse(comparison);

    var differenceInDays = currentTime.difference(startTime).inDays.abs();

    var differenceInHrs = (currentTime.difference(startTime).inHours / 24)
        .abs();
    var differenceInMinutes = (currentTime.difference(startTime).inMinutes / 60)
        .abs();

    if (differenceInDays > 0) {
      formattedRange = '$differenceInDays day(s) ago';
    } else if (differenceInHrs > 0 && differenceInDays < 1) {
      formattedRange = '$differenceInHrs hour(s) ago';
    } else if (differenceInMinutes > 0 && differenceInHrs < 1) {
      formattedRange = '$differenceInMinutes minute(s) ago';
    } else if (differenceInMinutes > 0 && differenceInMinutes < 1) {
      formattedRange = 'just now';
    } else {
      formattedRange = '';
    }

    return formattedRange;
  }
}
