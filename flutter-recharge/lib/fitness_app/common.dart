import 'package:intl/intl.dart';

class Common {
  static String  formatNumber(var value) {
    
    return NumberFormat.simpleCurrency(decimalDigits: 0, name: ''
            // locale: 'en_IN',
            // symbol: ''
            )
        .format(value);
  }
}