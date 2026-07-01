// ============================================================
//  رنگ‌های فصل‌ها (season_themes.dart)
// ============================================================
//  این فایل، رنگ هر فصل را تعریف می‌کند.
//  هر فصل یک «رنگ اصلی» دارد (برای نوارها) و یک «رنگ تأکید»
//  (برای دکمه‌ها و چیزهای مهم).
//  main.dart از این فایل رنگ‌ها را می‌گیرد و در تم اعمال می‌کند.
// ============================================================

import 'package:flutter/material.dart';

// یک کلاس ساده که رنگ‌های یک فصل را نگه می‌دارد.
class SeasonColors {
  final Color primary; // رنگ اصلی (نوار بالا، پایین و ...)
  final Color accent; // رنگ تأکید (دکمه‌ها، آیتم انتخاب‌شده)
  final String label; // نام فارسی فصل (برای نمایش)
  final IconData icon; // آیکون فصل

  const SeasonColors({
    required this.primary,
    required this.accent,
    required this.label,
    required this.icon,
  });
}

// ============================================================
//  جدول رنگ همه‌ی فصل‌ها
//  با دادن نام فصل ('spring' و ...)، رنگ‌هایش را می‌گیریم.
// ============================================================
const Map<String, SeasonColors> kSeasonThemes = {
  // 🌸 بهار — سبز با تأکید صورتیِ شکوفه
  'spring': SeasonColors(
    primary: Color(0xFF2E7D52),
    accent: Color(0xFFF06292),
    label: 'بهار',
    icon: Icons.local_florist,
  ),

  // ☀️ تابستان — آبی روشن با تأکید زرد آفتاب
  'summer': SeasonColors(
    primary: Color(0xFF0277BD),
    accent: Color(0xFFFFB300),
    label: 'تابستان',
    icon: Icons.wb_sunny,
  ),

  // 🍂 پاییز — نارنجی/کهربایی با تأکید طلایی
  'autumn': SeasonColors(
    primary: Color(0xFFBF5A1E),
    accent: Color(0xFFF4C430),
    label: 'پاییز',
    icon: Icons.park,
  ),

  // ❄️ زمستان — سرمه‌ای با تأکید آبی یخی (فصل پیش‌فرض)
  'winter': SeasonColors(
    primary: Color(0xFF1A2238),
    accent: Color(0xFFE8B339),
    label: 'زمستان',
    icon: Icons.ac_unit,
  ),
};

// یک تابع کمکی: نام فصل را می‌گیرد و رنگ‌هایش را برمی‌گرداند.
// اگر نام نامعتبر بود، زمستان را برمی‌گرداند (پیش‌فرض امن).
SeasonColors seasonColorsOf(String season) {
  return kSeasonThemes[season] ?? kSeasonThemes['winter']!;
}