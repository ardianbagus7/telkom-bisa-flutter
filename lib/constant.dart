part of 'main.dart';


//String baseUrl = 'http://192.168.43.27/telkom-bisa-master';
String baseUrl = 'https://project.ardianbagus.com';

//
var userId = '';
String namaUser = '';
String emailUser = '';
String imageUser = '';

// Number Currency
numberCurrency(int number) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
      .format(number);
}

int pastTime(DateTime d) {
  final now = DateTime.now();
  final difference = d.difference(now).inDays;
  return difference;
}

Color mainColor = Color(0xFF09cc7f);
Color backgroundColor = Colors.grey[300];

EdgeInsets mainPadding = EdgeInsets.symmetric(horizontal: 16);
EdgeInsets headerPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 20);

