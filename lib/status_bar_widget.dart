import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'jalali_helper.dart';

String toFa(String s) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (int i = 0; i < 10; i++) {
    s = s.replaceAll(en[i], fa[i]);
  }
  return s;
}

class StatusBarWidget extends StatefulWidget {
  final Color backgroundColor;
  const StatusBarWidget({super.key, required this.backgroundColor});

  @override
  State<StatusBarWidget> createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget> {
  Timer? _timer;
  DateTime _now = DateTime.now();
  List<PeriodInfo> _openPeriods = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
    _loadOpenPeriods();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadOpenPeriods() async {
    try {
      final open = await AuthManager.instance.repository.getOpenPeriods();
      if (!mounted) return;
      setState(() => _openPeriods = open);
    } catch (_) {}
  }

  String get _openPeriodsText {
    if (_openPeriods.isEmpty) return '';
    final names = _openPeriods.map((p) => p.title).join('، ');
    return '${toFa(_openPeriods.length.toString())} دوره: $names';
  }

  void _openConverter() {
    showDialog(context: context, builder: (_) => const _DateConverterDialog());
  }

  @override
  Widget build(BuildContext context) {
    final j = Jalali.fromDateTime(_now);
    final weekDay = j.formatter.wN;
    final shamsiStr =
        '$weekDay ${toFa(j.day.toString())} ${monthName(j.month)} ${toFa(j.year.toString())}';
    final miladiStr = toFa(
        '${_now.year}/${_now.month.toString().padLeft(2, '0')}/${_now.day.toString().padLeft(2, '0')}');
    final timeStr = toFa(
        '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}:${_now.second.toString().padLeft(2, '0')}');

    return Material(
      color: widget.backgroundColor,
      child: InkWell(
        onTap: _openConverter,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(timeStr,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
              const SizedBox(width: 12),
              const Text('•',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(width: 12),
              Text(shamsiStr,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 10),
              Text('(میلادی: $miladiStr)',
                  style: const TextStyle(color: Colors.white38, fontSize: 11)),
              const SizedBox(width: 12),
              const Icon(Icons.swap_horiz, color: Colors.white38, size: 14),
              const Spacer(),
              if (_openPeriodsText.isNotEmpty) ...[
                const Icon(Icons.event_available,
                    color: Colors.white70, size: 15),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(_openPeriodsText,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ] else
                const Text('دوره‌ی بازی نیست',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateConverterDialog extends StatefulWidget {
  const _DateConverterDialog();

  @override
  State<_DateConverterDialog> createState() => _DateConverterDialogState();
}

class _DateConverterDialogState extends State<_DateConverterDialog> {
  Jalali? _shamsi;
  DateTime? _miladi;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _miladi = now;
    _shamsi = Jalali.fromDateTime(now);
  }

  Future<void> _pickShamsi() async {
    final picked = await showPersianDatePicker(
      context: context,
      initialDate: _shamsi ?? Jalali.now(),
      firstDate: Jalali(1300, 1, 1),
      lastDate: Jalali(1500, 12, 29),
    );
    if (picked != null) {
      setState(() {
        _shamsi = picked;
        _miladi = picked.toDateTime();
      });
    }
  }

  Future<void> _pickMiladi() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _miladi ?? DateTime.now(),
      firstDate: DateTime(1921, 1, 1),
      lastDate: DateTime(2121, 12, 31),
      locale: const Locale('en'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _miladi = picked;
        _shamsi = Jalali.fromDateTime(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final j = _shamsi;
    final m = _miladi;
    final shamsiStr = j != null
        ? '${j.formatter.wN} ${toFa(j.day.toString())} ${monthName(j.month)} ${toFa(j.year.toString())}'
        : '—';
    final miladiStr = m != null
        ? toFa('${m.year}/${m.month.toString().padLeft(2, '0')}/${m.day.toString().padLeft(2, '0')}')
        : '—';

    return AlertDialog(
      title: const Text('مبدل تاریخ'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _box(
                'تاریخ شمسی',
                shamsiStr,
                Icons.calendar_today,
                _pickShamsi),
            const SizedBox(height: 12),
            const Center(
                child: Icon(Icons.swap_vert, color: Color(0xFF999999))),
            const SizedBox(height: 12),
            _box(
                'تاریخ میلادی',
                miladiStr,
                Icons.event,
                _pickMiladi),
            const SizedBox(height: 8),
            const Text(
                'روی هر کدام کلیک کنید تا تاریخ را عوض کنید؛ دیگری خودکار تبدیل می‌شود.',
                style: TextStyle(fontSize: 11, color: Color(0xFF999999))),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('بستن')),
      ],
    );
  }

  Widget _box(String label, String value, IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D3552) : const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isDark
                  ? const Color(0xFF3A4468)
                  : const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF777777)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF999999))),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF1A2238))),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.copy, size: 16),
              color: const Color(0xFF777777),
              tooltip: 'کپی',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('کپی شد'),
                      duration: Duration(seconds: 1)),
                );
              },
            ),
            const Icon(Icons.edit, size: 16, color: Color(0xFF999999)),
          ],
        ),
      ),
    );
  }
}