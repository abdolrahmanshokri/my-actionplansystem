import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';
import 'searchable_picker.dart';

class ReportsContent extends StatefulWidget {
  const ReportsContent({super.key});

  @override
  State<ReportsContent> createState() => _ReportsContentState();
}

class _ReportsContentState extends State<ReportsContent> {
  List<YearInfo> _years = [];
  List<PeriodInfo> _periods = [];
  List<UnitInfo> _units = [];
  int? _yearId;
  int? _periodId; // null = کل سال
  int? _filterUnitId;
  String _typeFilter = 'all';
  bool _includeInactive = false;
  List<ReportRow> _rows = [];
  bool _loading = true;
  bool _loadingReport = false;

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  bool get _isManager {
    final u = AuthManager.instance.currentUser;
    return (u?.isAdmin ?? false) || (u?.isAdmin2 ?? false);
  }

  @override
  void initState() {
    super.initState();
    _loadBase();
  }

  Future<void> _loadBase() async {
    final repo = AuthManager.instance.repository;
    final years = await repo.getAllYears();
    final units =
        await repo.getAccessibleUnits(AuthManager.instance.currentUser!.id);
    if (!mounted) return;
    int? presetYear;
    if (years.isNotEmpty) {
      final sorted = [...years]
        ..sort((a, b) => b.yearValue.compareTo(a.yearValue));
      presetYear = sorted.first.id;
    }
    setState(() {
      _years = years;
      _units = units;
      _yearId = presetYear;
      _loading = false;
    });
    if (presetYear != null) {
      final periods = await repo.getPeriodsForYear(presetYear);
      if (!mounted) return;
      setState(() => _periods = periods);
      await _loadReport();
    }
  }

  Future<void> _onYearChanged(int? v) async {
    setState(() {
      _yearId = v;
      _periodId = null;
      _periods = [];
      _rows = [];
    });
    if (v != null) {
      final periods =
          await AuthManager.instance.repository.getPeriodsForYear(v);
      if (!mounted) return;
      setState(() => _periods = periods);
      await _loadReport();
    }
  }

  Future<void> _loadReport() async {
    if (_yearId == null) return;
    setState(() => _loadingReport = true);
    final userId = AuthManager.instance.currentUser!.id;
    final rows = await AuthManager.instance.repository.getReportRows(
      yearId: _yearId!,
      periodId: _periodId,
      ownerUserId: _isManager ? null : userId,
      filterUnitId: _filterUnitId,
      includeInactive: _includeInactive,
      typeFilter: _typeFilter,
    );
    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loadingReport = false;
    });
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'draft':
        return 'پیش‌نویس';
      case 'submitted':
        return 'در جریان تأیید';
      case 'final':
        return 'تأیید نهایی';
      case 'kpi':
        return '—';
      default:
        return 'ثبت‌نشده';
    }
  }

  String get _periodLabel {
    if (_periodId == null) return 'کل سال';
    final p = _periods.where((x) => x.id == _periodId);
    return p.isEmpty ? '' : p.first.title;
  }

  Future<void> _exportCsv() async {
    final buf = StringBuffer();
    final showStatusCol = _includeInactive;
    buf.writeln(
        '\u200Fشماره,نام فعالیت,واحد اصلی,واحد,زیرواحد,نوع,وزن,تارگت,پیشرفت,درصد دستیابی,وضعیت${showStatusCol ? ',فعال/غیرفعال' : ''}');
    for (final r in _rows) {
      String esc(String v) =>
          '"${v.replaceAll('"', '""')}"';
      buf.writeln([
        esc(r.activityNumber),
        esc(r.activityName),
        esc(r.unitRoot),
        esc(r.unitMid),
        esc(r.unitLeaf),
        esc(r.type),
        r.weight.toStringAsFixed(1),
        r.target.toStringAsFixed(1),
        r.progress.toStringAsFixed(1),
        r.achievement.toStringAsFixed(0),
        esc(_statusLabel(r.status)),
        if (showStatusCol) esc(r.isActive ? 'فعال' : 'غیرفعال'),
      ].join(','));
    }
    // BOM برای نمایش درست فارسی در اکسل
    final bytes = utf8.encode('﻿${buf.toString()}');
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    await FileSaver.instance.saveFile(
      name: 'report_$stamp',
      bytes: bytes,
      fileExtension: 'csv',
      mimeType: MimeType.csv,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فایل CSV دانلود شد')));
  }

  void _exportPdf() {
    final yearTitle =
        _years.where((y) => y.id == _yearId).map((y) => y.title).join();
    final sb = StringBuffer();
    sb.write('''
<!DOCTYPE html><html dir="rtl" lang="fa"><head><meta charset="utf-8">
<title>گزارش اکشن‌پلان</title>
<style>
body{font-family:Tahoma,Arial,sans-serif;direction:rtl;padding:20px;color:#222}
h2{text-align:center}
.meta{text-align:center;color:#666;margin-bottom:16px;font-size:13px}
table{width:100%;border-collapse:collapse;font-size:12px}
th,td{border:1px solid #bbb;padding:6px 8px;text-align:center}
th{background:#1A2238;color:#fff}
tr:nth-child(even){background:#f4f6f9}
@media print{button{display:none}}
</style></head><body>
<h2>گزارش پیشرفت اکشن پلن</h2>
<div class="meta">سال: $yearTitle  —  دوره: $_periodLabel</div>
<table><thead><tr>
<th>شماره</th><th>نام فعالیت</th><th>واحد اصلی</th><th>واحد</th><th>زیرواحد</th><th>نوع</th>
<th>وزن</th><th>تارگت</th><th>پیشرفت</th><th>دستیابی</th><th>وضعیت</th>${_includeInactive ? '<th>فعال/غیرفعال</th>' : ''}
</tr></thead><tbody>
''');
    for (final r in _rows) {
      sb.write('<tr>'
          '<td>${r.activityNumber}</td>'
          '<td style="text-align:right">${r.activityName}</td>'
          '<td>${r.unitRoot}</td>'
          '<td>${r.unitMid}</td>'
          '<td>${r.unitLeaf}</td>'
          '<td>${r.type}</td>'
          '<td>${r.weight.toStringAsFixed(1)}</td>'
          '<td>${r.target.toStringAsFixed(1)}٪</td>'
          '<td>${r.progress.toStringAsFixed(1)}٪</td>'
          '<td>${r.achievement.toStringAsFixed(0)}٪</td>'
          '<td>${_statusLabel(r.status)}</td>'
          '${_includeInactive ? '<td>${r.isActive ? 'فعال' : 'غیرفعال'}</td>' : ''}'
          '</tr>');
    }
    sb.write('''
</tbody></table>
<p style="text-align:center;margin-top:20px">
<button onclick="window.print()" style="padding:8px 24px;font-size:14px">چاپ / ذخیره PDF</button></p>
<script>window.onload=function(){setTimeout(function(){window.print();},400);};</script>
</body></html>
''');
    final blob = html.Blob([sb.toString()], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('گزارش‌گیری',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textColor)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 180,
                child: SearchablePicker(
                  labelText: 'سال',
                  dense: true,
                  selectedId: _yearId,
                  options: _years
                      .map((y) => SearchableOption(id: y.id, label: y.title))
                      .toList(),
                  onChanged: _onYearChanged,
                ),
              ),
              SizedBox(
                width: 200,
                child: SearchablePicker(
                  labelText: 'دوره (خالی = کل سال)',
                  dense: true,
                  selectedId: _periodId,
                  options: _periods
                      .map((p) => SearchableOption(id: p.id, label: p.title))
                      .toList(),
                  onChanged: (v) async {
                    setState(() => _periodId = v);
                    await _loadReport();
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: SearchablePicker(
                  labelText: 'واحد (اختیاری)',
                  dense: true,
                  selectedId: _filterUnitId,
                  options: _units
                      .map((u) => SearchableOption(id: u.id, label: u.name))
                      .toList(),
                  onChanged: (v) async {
                    setState(() => _filterUnitId = v);
                    await _loadReport();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'all', label: Text('همه')),
                  ButtonSegment(value: 'project', label: Text('پروژه')),
                  ButtonSegment(value: 'kpi', label: Text('KPI')),
                ],
                selected: {_typeFilter},
                onSelectionChanged: (s) async {
                  setState(() => _typeFilter = s.first);
                  await _loadReport();
                },
                style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStateProperty.all(
                        const TextStyle(fontSize: 12))),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _includeInactive,
                    onChanged: (v) async {
                      setState(() => _includeInactive = v ?? false);
                      await _loadReport();
                    },
                  ),
                  Text('شامل غیرفعال‌ها',
                      style: TextStyle(fontSize: 12, color: textColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _rows.isEmpty ? null : _exportCsv,
                icon: const Icon(Icons.table_view, size: 18),
                label: const Text('خروجی اکسل (CSV)'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D52),
                    foregroundColor: Colors.white),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _rows.isEmpty ? null : _exportPdf,
                icon: const Icon(Icons.picture_as_pdf, size: 18),
                label: const Text('خروجی PDF (چاپ)'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC0392B),
                    foregroundColor: Colors.white),
              ),
              const Spacer(),
              Text('${_rows.length} ردیف',
                  style: TextStyle(
                      fontSize: 13,
                      color:
                          isDark ? Colors.white60 : const Color(0xFF777777))),
            ],
          ),
          const SizedBox(height: 16),
          if (_loadingReport)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_rows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text('داده‌ای برای نمایش نیست',
                    style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
              ),
            )
          else
            _buildTable(isDark, textColor),
        ],
      ),
    );
  }

  Widget _buildTable(bool isDark, Color textColor) {
    final showStatusCol = _includeInactive;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
              isDark ? const Color(0xFF2D3552) : const Color(0xFFEFF2F6)),
          columns: [
            const DataColumn(label: Text('شماره')),
            const DataColumn(label: Text('نام فعالیت')),
            const DataColumn(label: Text('واحد اصلی')),
            const DataColumn(label: Text('واحد')),
            const DataColumn(label: Text('زیرواحد')),
            const DataColumn(label: Text('نوع')),
            const DataColumn(label: Text('وزن')),
            const DataColumn(label: Text('تارگت')),
            const DataColumn(label: Text('پیشرفت')),
            const DataColumn(label: Text('دستیابی')),
            const DataColumn(label: Text('وضعیت')),
            if (showStatusCol) const DataColumn(label: Text('فعال/غیرفعال')),
          ],
          rows: _rows.map((r) {
            final dim = !r.isActive;
            final tc = dim
                ? (isDark ? Colors.white38 : const Color(0xFFAAAAAA))
                : textColor;
            return DataRow(cells: [
              DataCell(Text(r.activityNumber, style: TextStyle(color: tc))),
              DataCell(Text(r.activityName, style: TextStyle(color: tc))),
              DataCell(Text(r.unitRoot, style: TextStyle(color: tc))),
              DataCell(Text(r.unitMid, style: TextStyle(color: tc))),
              DataCell(Text(r.unitLeaf, style: TextStyle(color: tc))),
              DataCell(Text(r.type, style: TextStyle(color: tc))),
              DataCell(Text(r.weight.toStringAsFixed(1),
                  style: TextStyle(color: tc))),
              DataCell(Text('${r.target.toStringAsFixed(1)}٪',
                  style: TextStyle(color: tc))),
              DataCell(Text('${r.progress.toStringAsFixed(1)}٪',
                  style: TextStyle(
                      color: dim ? tc : _primary,
                      fontWeight: FontWeight.w500))),
              DataCell(Text('${r.achievement.toStringAsFixed(0)}٪',
                  style: TextStyle(color: tc))),
              DataCell(Text(_statusLabel(r.status),
                  style: TextStyle(color: tc, fontSize: 12))),
              if (showStatusCol)
                DataCell(Text(r.isActive ? 'فعال' : 'غیرفعال',
                    style: TextStyle(
                        color: r.isActive
                            ? const Color(0xFF2E7D52)
                            : const Color(0xFF999999),
                        fontSize: 12))),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}