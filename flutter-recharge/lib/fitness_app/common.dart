import 'package:intl/intl.dart';

class Common {
  static String  formatNumber(var value) {
    if(value is Null){
      value = 0.0;
    }
    if(value is String){
      value = double.parse(value);
    }


    return NumberFormat.simpleCurrency(decimalDigits: 0, name: ''
            // locale: 'en_IN',
            // symbol: ''
            )
        .format(value);
  }
}
