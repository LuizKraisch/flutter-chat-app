import 'package:intl/intl.dart';

class DateHelper {
  String formatDatetime(DateTime dateTime) {
    final now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat('h:mm a').format(dateTime);
    } else {
      return DateFormat('MMMM d, y h:mm a').format(dateTime);
    }
  }
}
