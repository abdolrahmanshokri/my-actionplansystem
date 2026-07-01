import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';
import 'jalali_helper.dart';

class YearsManagementContent extends StatefulWidget {
  const YearsManagementContent({super.key});

  @override
  State<YearsManagementContent> createState() => _YearsManagementContentState();
}

class _YearsManagementContentState extends State<YearsManagementContent> {
  List<YearInfo> _years = [];
  bool _loading = true;
  YearInfo? _openedYear;

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final years = await AuthManager.instance.repository.getAllYears();
    if (!mounted) return;
    setState(() {
      _years = years;
      _loading = false;
    });
  }

  Future<void> _openCreateDialog() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => const _CreateYearDialog(),
    );
    if (created == true) await _load();
  }

  Future<void> _deleteYear(YearInfo y) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف سال'),
        content: Text(
            'سال «${y.title}» و همه‌ی دوره‌هایش حذف شوند؟ (فقط اگر هیچ دوره‌ای باز نباشد)'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('لغو')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B),
                foregroundColor: Colors.white),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await AuthManager.instance.repository.deleteYear(y.id);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('این سال دوره‌ی باز دارد و قابل حذف نیست')));
    } else {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);

    if (_openedYear != null) {
      return _PeriodsView(
        year: _openedYear!,
        onBack: () => setState(() => _openedYear = null),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مدیریت سال و دوره‌ها',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                    const SizedBox(height: 4),
                    Text('${_years.length} سال تعریف شده',
                        style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF777777))),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: _openCreateDialog,
                icon: const Icon(Icons.add),
                label: const Text('تعریف سال جدید'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _primary, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _years.isEmpty
                    ? Center(
                        child: Text('هنوز سالی تعریف نشده است',
                            style: TextStyle(
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF777777))))
                    : ListView.separated(
                        itemCount: _years.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) =>
                            _yearRow(_years[i], isDark, textColor),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _yearRow(YearInfo y, bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: _primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.calendar_month, color: _primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(y.title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
                const SizedBox(height: 2),
                Text(
                    'از ${formatJalali(y.startJy, y.startJm, y.startJd)} تا ${formatJalali(y.endJy, y.endJm, y.endJd)}',
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => setState(() => _openedYear = y),
            icon: const Icon(Icons.visibility, size: 18),
            label: const Text('مشاهده دوره‌ها'),
            style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : _primary,
                side: BorderSide(
                    color: isDark
                        ? Colors.white54
                        : _primary.withOpacity(0.4))),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: const Color(0xFFC0392B),
            tooltip: 'حذف سال',
            onPressed: () => _deleteYear(y),
          ),
        ],
      ),
    );
  }
}

class _CreateYearDialog extends StatefulWidget {
  const _CreateYearDialog();

  @override
  State<_CreateYearDialog> createState() => _CreateYearDialogState();
}

class _CreateYearDialogState extends State<_CreateYearDialog> {
  Jalali? _start;
  Jalali? _end;
  String? _error;
  bool _saving = false;

  Future<void> _pickStart() async {
    final picked = await showPersianDatePicker(
      context: context,
      initialDate: _start ?? Jalali.now(),
      firstDate: Jalali(1380, 1, 1),
      lastDate: Jalali(1450, 12, 29),
    );
    if (picked != null) setState(() => _start = picked);
  }

  Future<void> _pickEnd() async {
    final picked = await showPersianDatePicker(
      context: context,
      initialDate: _end ?? _start ?? Jalali.now(),
      firstDate: Jalali(1380, 1, 1),
      lastDate: Jalali(1450, 12, 29),
    );
    if (picked != null) setState(() => _end = picked);
  }

  Future<void> _save() async {
    setState(() => _error = null);
    if (_start == null || _end == null) {
      setState(() => _error = 'تاریخ شروع و پایان را انتخاب کنید');
      return;
    }
    if (_start!.year != _end!.year) {
      setState(() => _error = 'شروع و پایان باید در یک سال شمسی باشند');
      return;
    }
    if (_end!.compareTo(_start!) < 0) {
      setState(() => _error = 'تاریخ پایان نباید قبل از شروع باشد');
      return;
    }

    final months = monthsBetween(_start!.month, _end!.month);
    setState(() => _saving = true);

    final err =
        await AuthManager.instance.repository.createYearWithPeriods(
      yearValue: _start!.year,
      title: 'سال ${_start!.year}',
      startJy: _start!.year,
      startJm: _start!.month,
      startJd: _start!.day,
      endJy: _end!.year,
      endJm: _end!.month,
      endJd: _end!.day,
      monthNumbers: months,
    );

    if (!mounted) return;
    setState(() => _saving = false);
    if (err != null) {
      setState(() => _error = err);
    } else {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = (_start != null && _end != null && _start!.year == _end!.year)
        ? monthsBetween(_start!.month, _end!.month)
        : <int>[];

    return AlertDialog(
      title: const Text('تعریف سال جدید'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'تاریخ شروع و پایان را انتخاب کنید. دوره‌های ماهانه به‌طور خودکار از روی این بازه ساخته می‌شوند.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF777777))),
              const SizedBox(height: 16),
              _dateField('تاریخ شروع', _start, _pickStart),
              const SizedBox(height: 12),
              _dateField('تاریخ پایان', _end, _pickEnd),
              if (months.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('${months.length} دوره ساخته می‌شود:',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: months
                      .map((m) => Chip(
                            label: Text(monthName(m),
                                style: const TextStyle(fontSize: 12)),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: const TextStyle(
                        color: Color(0xFFC0392B), fontSize: 13)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('لغو')),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('ثبت سال'),
        ),
      ],
    );
  }

  Widget _dateField(String label, Jalali? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(
          value != null
              ? formatJalali(value.year, value.month, value.day)
              : 'انتخاب کنید',
          style: TextStyle(
              color: value != null ? null : Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}

class _PeriodsView extends StatefulWidget {
  final YearInfo year;
  final VoidCallback onBack;
  const _PeriodsView({required this.year, required this.onBack});

  @override
  State<_PeriodsView> createState() => _PeriodsViewState();
}

class _PeriodsViewState extends State<_PeriodsView> {
  List<PeriodInfo> _periods = [];
  bool _loading = true;

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final periods =
        await AuthManager.instance.repository.getPeriodsForYear(widget.year.id);
    if (!mounted) return;
    setState(() {
      _periods = periods;
      _loading = false;
    });
  }

  Future<void> _toggleStatus(PeriodInfo p) async {
    final newStatus = p.isOpen ? 'closed' : 'open';
    await AuthManager.instance.repository.setPeriodStatus(p.id, newStatus);
    await _load();
  }

  Future<void> _deletePeriod(PeriodInfo p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف دوره'),
        content: Text('دوره‌ی «${p.title}» حذف شود؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('لغو')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B),
                foregroundColor: Colors.white),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final ok = await AuthManager.instance.repository.deletePeriod(p.id);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'فقط دوره‌ی ابتدا یا انتهای سال قابل حذف است (نه از وسط)')));
    } else {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);

    final minMonth = _periods.isEmpty
        ? 0
        : _periods.map((p) => p.monthNumber).reduce((a, b) => a < b ? a : b);
    final maxMonth = _periods.isEmpty
        ? 0
        : _periods.map((p) => p.monthNumber).reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_forward),
                tooltip: 'بازگشت',
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('دوره‌های ${widget.year.title}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                    Text('${_periods.length} دوره',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF777777))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: _periods.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final p = _periods[i];
                      final canDelete = p.monthNumber == minMonth ||
                          p.monthNumber == maxMonth;
                      return _periodRow(
                          p, canDelete, isDark, textColor);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _periodRow(
      PeriodInfo p, bool canDelete, bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: p.isOpen
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    p.isOpen ? 'باز (open)' : 'بسته (closed)',
                    style: TextStyle(
                        fontSize: 11,
                        color: p.isOpen
                            ? const Color(0xFF2E7D52)
                            : const Color(0xFF999999)),
                  ),
                ),
              ],
            ),
          ),
          if (p.isOpen)
            OutlinedButton.icon(
              onPressed: () => _toggleStatus(p),
              icon: const Icon(Icons.lock, size: 16),
              label: const Text('بستن'),
              style:
                  OutlinedButton.styleFrom(foregroundColor: const Color(0xFFBA7517)),
            )
          else
            OutlinedButton.icon(
              onPressed: () => _toggleStatus(p),
              icon: const Icon(Icons.lock_open, size: 16),
              label: const Text('بازکردن'),
              style: OutlinedButton.styleFrom(foregroundColor: _primary),
            ),
          if (canDelete)
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              color: const Color(0xFFC0392B),
              tooltip: 'حذف دوره',
              onPressed: () => _deletePeriod(p),
            ),
        ],
      ),
    );
  }
}