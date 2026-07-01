import 'package:shamsi_date/shamsi_date.dart';

const List<String> persianMonths = [
  'فروردین',
  'اردیبهشت',
  'خرداد',
  'تیر',
  'مرداد',
  'شهریور',
  'مهر',
  'آبان',
  'آذر',
  'دی',
  'بهمن',
  'اسفند',
];

const List<String> persianWeekDays = [
  'شنبه',
  'یکشنبه',
  'دوشنبه',
  'سه‌شنبه',
  'چهارشنبه',
  'پنجشنبه',
  'جمعه',
];

String monthName(int month) {
  if (month < 1 || month > 12) return '';
  return persianMonths[month - 1];
}

bool isLeapJalaliYear(int year) {
  return Jalali(year, 1, 1).isLeapYear();
}

int monthLengthJalali(int year, int month) {
  return Jalali(year, month, 1).monthLength;
}

String formatJalali(int y, int m, int d) {
  final mm = m.toString().padLeft(2, '0');
  final dd = d.toString().padLeft(2, '0');
  return '$y/$mm/$dd';
}

List<int> monthsBetween(int startMonth, int endMonth) {
  final result = <int>[];
  for (int i = startMonth; i <= endMonth; i++) {
    result.add(i);
  }
  return result;
}