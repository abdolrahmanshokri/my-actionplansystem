// ============================================================
//  سامانه اکشن‌پلن پتروشیمی جم
//  فایل اصلی برنامه (main.dart) - نسخه ۱: اسکلت ظاهری
// ============================================================
//  این فایل قلب برنامه است. هر چیزی که می‌بینید از اینجا شروع می‌شود.
//  در فلاتر همه چیز یک «ویجت» (Widget) است؛ مثل آجرهای لِگو که
//  کنار هم می‌چینیم تا برنامه ساخته شود.
// ============================================================

// این خط، کتابخانه‌ی آماده‌ی فلاتر را وارد می‌کند.
// «material» مجموعه‌ای از آجرهای آماده است (دکمه، نوار، متن و ...).
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

// این دو خط برای کار با متن و بایت لازم‌اند (برای ساختن فایل).
import 'dart:convert'; // برای تبدیل متن به بایت (utf8)
import 'dart:html' as html;
import 'dart:typed_data'; // برای نوع Uint8List (بایت‌ها)

// ابزار ذخیره/دانلود فایل روی همه‌ی پلتفرم‌ها (وب، اندروید و ...).
import 'package:file_saver/file_saver.dart';

// ابزار انتخاب/آپلود فایل از دستگاه روی همه‌ی پلتفرم‌ها.
import 'package:file_picker/file_picker.dart';

import 'settings_manager.dart';
import 'season_themes.dart';
import 'auth_manager.dart';
import 'login_screen.dart';
import 'admin_tools_content.dart';
import 'users_management_content.dart';
import 'connection_settings_content.dart';
import 'years_management_content.dart';
import 'units_management_content.dart';
import 'activities_management_content.dart';
import 'targets_management_content.dart';
import 'progress_entry_content.dart';
import 'status_bar_widget.dart';
import 'dashboard_content.dart';
import 'reports_content.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsManager.instance.init();
  await AuthManager.instance.init();
  await _handleSsoReturn();
  _applyFaviconIfSet();
  // هر بار که تنظیمات عوض شد (مثلاً بعد از لاگین API یا تغییر آیکون)،
  // favicon را دوباره اعمال کن تا با رفرش/لاگین برنگردد به حالت قبل.
  SettingsManager.instance.addListener(_applyFaviconIfSet);
  runApp(const AppRoot());
}

// اگر از SSO با بلیت برگشتیم، آن را به توکن تبدیل کن و URL را پاک کن.
Future<void> _handleSsoReturn() async {
  final uri = Uri.parse(html.window.location.href);
  final ticket = uri.queryParameters['ssoTicket'];
  if (ticket != null && ticket.isNotEmpty) {
    await AuthManager.instance.exchangeSsoTicket(ticket);
  }
  // پاک‌کردن پارامترهای SSO از URL (چه موفق چه ناموفق)
  if (uri.queryParameters.containsKey('ssoTicket') ||
      uri.queryParameters.containsKey('ssoError')) {
    final clean = '${uri.origin}${uri.path}';
    html.window.history.replaceState(null, '', clean);
  }
}

// اگر favicon سفارشی ذخیره شده، روی تب مرورگر اعمال کن.
String _lastAppliedFavicon = '';
void _applyFaviconIfSet() {
  final fav = SettingsManager.instance.browserFavicon;
  if (fav.isEmpty) return;
  if (fav == _lastAppliedFavicon) return; // جلوگیری از اعمال تکراری
  _lastAppliedFavicon = fav;
  final existing = html.document.querySelectorAll("link[rel*='icon']");
  for (final e in existing) {
    e.remove();
  }
  final link = html.LinkElement()
    ..rel = 'icon'
    ..type = 'image/png'
    ..href = fav;
  html.document.head?.append(link);
}

// ============================================================
//  ویجت ریشه‌ای برنامه (AppRoot)
//  این بیرونی‌ترین لایه است. اینجا تنظیمات کلی (مثل رنگ، راست‌چین بودن،
//  زبان فارسی) را مشخص می‌کنیم.
// ============================================================
class AppRoot extends StatelessWidget {
  // این یک «سازنده» است. فعلاً فقط بدانید لازم است و دست نزنید.
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder به مغز تنظیمات «گوش می‌دهد».
    // هر وقت تنظیمات عوض شود (مثلاً کاربر دکمه‌ی شب/روز را بزند)،
    // این قسمت خودش را دوباره می‌سازد تا تم جدید اعمال شود.
    return AnimatedBuilder(
      animation: Listenable.merge(
          [SettingsManager.instance, AuthManager.instance]),
      builder: (context, _) {
        // هر بار که تنظیمات تغییر کند (init، لاگین، آپلود favicon)،
        // آیکون تب مرورگر را به‌روز می‌کنیم تا همیشه هماهنگ بماند.
        _applyFaviconIfSet();
        // آیا الان حالت شب (تاریک) فعال است؟ از مغز می‌پرسیم.
        final bool isDark = SettingsManager.instance.isDarkMode;

        // رنگ‌های فصل فعلی را می‌گیریم.
        final SeasonColors sc =
            seasonColorsOf(SettingsManager.instance.season);

        // MaterialApp ظرف اصلی برنامه است که همه‌ی تنظیمات کلی را نگه می‌دارد.
        return MaterialApp(
          // عنوان برنامه (در تب مرورگر دیده می‌شود).
          title: SettingsManager.instance.browserTitle,

          // این خط، نوار قرمز «DEBUG» گوشه‌ی صفحه را پنهان می‌کند.
          debugShowCheckedModeBanner: false,

          locale: const Locale('fa', 'IR'),
          supportedLocales: const [
            Locale('fa', 'IR'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            PersianMaterialLocalizations.delegate,
            PersianCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ----- تم روشن (حالت روز) -----
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: sc.primary,
            fontFamily: 'sans-serif',
            colorScheme: ColorScheme.fromSeed(
              seedColor: sc.primary,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),

          // ----- تم تاریک (حالت شب) -----
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: sc.primary,
            fontFamily: 'sans-serif',
            colorScheme: ColorScheme.fromSeed(
              seedColor: sc.primary,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          // ----- انتخاب تم بر اساس تنظیمات کاربر -----
          // اگر isDark درست باشد، تم تاریک؛ وگرنه تم روشن.
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          // ----- راست‌چین کردن کل برنامه (برای فارسی) -----
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },

          // صفحه‌ی اصلی که اول نشان داده می‌شود: HomeShell (قاب اصلی ما).
          home: AuthManager.instance.isLoggedIn
              ? const HomeShell()
              : const LoginScreen(),
        );
      },
    );
  }
}

// ============================================================
//  قاب اصلی برنامه (HomeShell)
//  این همان «اسکلت» است: نوار بالا + پنل راست + محتوای وسط + نوار پایین.
//  چون قرار است حالتش تغییر کند (مثلاً منو باز/بسته شود)، از نوع
//  StatefulWidget است؛ یعنی «ویجتی که حالت/وضعیت دارد».
// ============================================================
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

// این کلاس، حالت (State) قاب اصلی را نگه می‌دارد.
class _HomeShellState extends State<HomeShell> {
  // این «کلید» برای کنترل کشوی کناری (Drawer) در حالت موبایل است.
  // با آن می‌توانیم منوی همبرگری را باز کنیم.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ----- متغیر بخش فعلی -----
  // این متغیر نگه می‌دارد که کاربر الان در کدام بخش است.
  // مقدار '' (خالی) یعنی صفحه‌ی خوش‌آمد اصلی.
  // وقتی کاربر روی یک کلید پنل کلیک می‌کند، این عوض می‌شود و
  // محتوای وسط هم بر اساس آن تغییر می‌کند.
  String _currentSection = '';

  // تابعی برای عوض کردن بخش فعلی.
  // وقتی صدا زده شود، بخش را عوض می‌کند و صفحه را دوباره می‌سازد.
  void _goToSection(String section) {
    // setState یعنی «حالت عوض شد، صفحه را از نو بساز».
    setState(() {
      _currentSection = section;
    });
    // اگر در حالت موبایل کشو باز است، آن را ببند.
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  // ----- میانبرهای رنگ فصل فعلی -----
  // این دو میانبر، رنگ فصلی که الان انتخاب شده را برمی‌گردانند.
  // به‌جای نوشتن رنگ ثابت سرمه‌ای، از این‌ها استفاده می‌کنیم تا
  // وقتی فصل عوض شد، همه‌ی رنگ‌ها خودکار عوض شوند.

  // رنگ اصلی فصل فعلی (برای نوارها).
  Color get _primaryColor =>
      seasonColorsOf(SettingsManager.instance.season).primary;

  // رنگ تأکید فصل فعلی (برای دکمه‌ها و آیتم انتخاب‌شده).
  Color get _accentColor =>
      seasonColorsOf(SettingsManager.instance.season).accent;

  @override
  Widget build(BuildContext context) {
    // عرض صفحه را اندازه می‌گیریم تا بفهمیم کامپیوتر است یا موبایل.
    // MediaQuery.of(context).size.width یعنی «عرض صفحه چقدر است».
    final double screenWidth = MediaQuery.of(context).size.width;

    // اگر عرض صفحه کمتر از ۸۰۰ پیکسل باشد، آن را موبایل در نظر می‌گیریم.
    final bool isMobile = screenWidth < 800;

    // Scaffold اسکلت آماده‌ی یک صفحه است: جای نوار بالا، بدنه، کشو و ... دارد.
    return Scaffold(
      key: _scaffoldKey,

      // رنگ پس‌زمینه را حذف کردیم تا Scaffold خودش از تم (روز/شب) بگیرد.
      // در حالت روز روشن و در حالت شب تیره می‌شود.

      // ----- (۱) نوار بالایی: تاپ‌منو -----
      appBar: _buildTopBar(isMobile),

      // ----- پنل راست در حالت موبایل: کشوی کناری (Drawer) -----
      // endDrawer یعنی کشویی که از سمت «انتها» (در فارسی: راست) باز می‌شود.
      // فقط در حالت موبایل آن را می‌گذاریم؛ در کامپیوتر پنل همیشه دیده می‌شود.
      endDrawer: isMobile ? _buildSidePanel() : null,

      // ----- بدنه‌ی اصلی صفحه -----
      body: Column(
        children: [
          // قسمت میانی صفحه که باید بقیه‌ی فضا را پر کند.
          // Expanded یعنی «تا جایی که جا هست، کش بیا».
          Expanded(
            child: Row(
              children: [
                // (۳) محتوای اصلی وسط — شامل نویگیشن‌بار و محتوای بخش فعلی.
                Expanded(
                  child: Column(
                    children: [
                      // نویگیشن‌بار: مسیری که کاربر در آن است را نشان می‌دهد.
                      _buildNavigationBar(),
                      // محتوای بخش فعلی (بقیه‌ی فضا را پر می‌کند).
                      Expanded(child: _buildMainContent()),
                    ],
                  ),
                ),

                // (۲) پنل کناری راست — فقط در حالت کامپیوتر اینجا نشان داده می‌شود.
                // در موبایل، این پنل داخل کشو (endDrawer) می‌رود.
                if (!isMobile) _buildSidePanel(),
              ],
            ),
          ),

          // ----- (۴) نوار ثابت پایینی: استتوس‌بار -----
          _buildStatusBar(),
        ],
      ),
    );
  }

  // ============================================================
  //  نویگیشن‌بار (نوار مسیر)
  //  نشان می‌دهد کاربر کجاست. مثلاً: اکشن‌پلن › تنظیمات
  // ============================================================
  Widget _buildNavigationBar() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // نام بخش فعلی را برای نمایش آماده می‌کنیم.
    // اگر بخشی انتخاب نشده، فقط «خانه» را نشان می‌دهیم.
    final List<String> path = ['خانه'];
    if (_currentSection.isNotEmpty) {
      path.add(_currentSection);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: isDark ? const Color(0xFF2D3552) : const Color(0xFFE9EBF0),
      child: Row(
        children: [
          Icon(Icons.home,
              size: 16,
              color: isDark ? Colors.white70 : _primaryColor),
          const SizedBox(width: 8),
          // مسیر را با جداکننده‌ی › نشان می‌دهیم.
          Text(
            path.join('  ›  '),
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  //  (۱) ساخت نوار بالایی (تاپ‌منو)
  // ============================================================
  // PreferredSizeWidget نوعی است که appBar انتظارش را دارد.
  PreferredSizeWidget _buildTopBar(bool isMobile) {
    return AppBar(
      // رنگ پس‌زمینه‌ی نوار: همان سرمه‌ای تیره.
      backgroundColor: _primaryColor,

      // ارتفاع نوار.
      toolbarHeight: 64,

      // در فلاتر، automaticallyImplyLeading را خاموش می‌کنیم تا فلاتر
      // خودش دکمه‌ی اضافه نگذارد و خودمان چیدمان را کنترل کنیم.
      automaticallyImplyLeading: false,

      // مشکل دو همبرگری: وقتی Scaffold یک endDrawer دارد، فلاتر خودش
      // یک دکمه‌ی ☰ خودکار در قسمت actions (انتهای نوار) می‌سازد.
      // با گذاشتن یک actions خالی، جلوی این دکمه‌ی خودکار را می‌گیریم
      // تا فقط همان یک دکمه‌ی ☰ که خودمان ساخته‌ایم باقی بماند.
      actions: const [SizedBox.shrink()],

      // محتوای داخل نوار. یک ردیف (Row) که سه بخش دارد.
      title: Row(
        children: [
          // --- سمت راست در فارسی: نام کاربر (چون title از راست شروع می‌شود) ---
          // یک دکمه‌ی گرد با نام کاربر که به پروفایل می‌رود.
          _buildUserButton(),

          // فاصله.
          const SizedBox(width: 12),

          // --- دکمه‌ی شب/روز ---
          // این دکمه تم را بین حالت روز و شب عوض می‌کند.
          _buildThemeToggle(),

          const SizedBox(width: 16),

          // --- وسط: شعار سال ---
          // Expanded یعنی این بخش وسط، فضای باقی‌مانده را پر کند تا شعار وسط بماند.
          Expanded(
            child: Text(
              SettingsManager.instance.appSlogan,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              // اگر متن بلند بود و جا نشد، با سه‌نقطه کوتاهش کن.
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 16),

          // --- سمت چپ در فارسی: اسم سیستم و آیکون ---
          // (در چینش راست‌چین، آخرین آیتم ردیف، سمت چپ قرار می‌گیرد.)
          Row(
            children: [
              Text(
                SettingsManager.instance.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              // لوگوی هدر: اگر آپلود شده، تصویر؛ وگرنه آیکون پیش‌فرض.
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: SettingsManager.instance.hasHeaderLogo
                    ? _headerLogoImage(SettingsManager.instance.headerLogo)
                    : const Icon(Icons.dashboard_rounded,
                        color: Colors.white, size: 20),
              ),
            ],
          ),

          // --- دکمه‌ی همبرگری (فقط در حالت موبایل) ---
          // اگر موبایل بود، یک دکمه‌ی ☰ اضافه می‌کنیم که پنل راست را باز کند.
          if (isMobile) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // کشوی سمت راست (endDrawer) را باز کن.
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  //  دکمه‌ی نام کاربر (گرد، با رنگ متضاد، می‌رود به پروفایل)
  // ============================================================
  Widget _buildUserButton() {
    final user = AuthManager.instance.currentUser;
    final name = user?.fullName ?? 'کاربر';

    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        tooltip: 'منوی کاربر',
        offset: const Offset(0, 48),
        onSelected: (value) async {
          if (value == 'logout') {
            await AuthManager.instance.logout();
          } else if (value == 'roles') {
            _showRolesDialog();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'profile',
            child: Row(children: [
              const Icon(Icons.account_circle, size: 18),
              const SizedBox(width: 8),
              Text(name),
            ]),
          ),
          const PopupMenuItem(
            value: 'roles',
            child: Row(children: [
              Icon(Icons.verified_user, size: 18),
              SizedBox(width: 8),
              Text('دسترسی‌های من'),
            ]),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'logout',
            child: Row(children: [
              Icon(Icons.logout, size: 18, color: Color(0xFFC0392B)),
              SizedBox(width: 8),
              Text('خروج', style: TextStyle(color: Color(0xFFC0392B))),
            ]),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _accentColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(Icons.person, size: 18, color: _primaryColor),
              const SizedBox(width: 6),
              Text(
                name,
                style: TextStyle(
                  color: _primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 18, color: _primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  void _showRolesDialog() {
    final user = AuthManager.instance.currentUser;
    final roles = user?.roleCodes ?? [];
    final roleNames = {
      'super_admin': 'سوپر ادمین',
      'admin': 'ادمین ارشد',
      'admin2': 'ادمین سطح ۲ اکشن‌پلن',
      'action_user': 'کاربر اکشن‌پلن',
    };
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('دسترسی‌های من'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('کاربر: ${user?.fullName ?? ''}'),
            Text('نام کاربری: ${user?.username ?? ''}'),
            const SizedBox(height: 12),
            const Text('نقش‌ها:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            if (roles.isEmpty)
              const Text('بدون نقش')
            else
              ...roles.map((r) => Row(children: [
                    const Icon(Icons.check_circle,
                        size: 16, color: Color(0xFF2E7D52)),
                    const SizedBox(width: 6),
                    Text(roleNames[r] ?? r),
                  ])),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('بستن')),
        ],
      ),
    );
  }

  // ============================================================
  //  دکمه‌ی شب/روز
  //  یک دکمه‌ی گرد که آیکونش بسته به حالت فعلی، خورشید یا ماه است.
  //  وقتی زده شود، تم را عوض می‌کند و خودکار ذخیره می‌شود.
  // ============================================================
  // لوگوی هدر از dataURL base64
  Widget _headerLogoImage(String dataUrl) {
    try {
      final base64Part =
          dataUrl.contains(',') ? dataUrl.split(',').last : dataUrl;
      final bytes = base64Decode(base64Part);
      return Image.memory(bytes, fit: BoxFit.contain);
    } catch (_) {
      return const Icon(Icons.dashboard_rounded,
          color: Colors.white, size: 20);
    }
  }

  Widget _buildThemeToggle() {
    // از مغز تنظیمات می‌پرسیم الان حالت شب است یا روز.
    final bool isDark = SettingsManager.instance.isDarkMode;

    return IconButton(
      // راهنمای کوچکی که وقتی موس را نگه می‌داری نشان داده می‌شود.
      tooltip: isDark ? 'تغییر به حالت روز' : 'تغییر به حالت شب',

      // آیکون: اگر شب است، خورشید نشان بده (یعنی بزن تا روز شود)؛
      // اگر روز است، ماه نشان بده (یعنی بزن تا شب شود).
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: _accentColor, // رنگ طلایی، هماهنگ با دکمه‌ی کاربر
      ),

      // وقتی دکمه زده شد، به مغز می‌گوییم تم را عوض کن.
      // مغز خودش ذخیره می‌کند و به برنامه خبر می‌دهد تا تم جدید اعمال شود.
      onPressed: () {
        SettingsManager.instance.toggleDarkMode();
      },
    );
  }
  Widget _buildSidePanel() {
    // آیا حالت شب است؟ برای انتخاب رنگ‌های مناسب.
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 240,
      // در حالت روز سفید، در حالت شب یک سرمه‌ای تیره‌تر.
      color: isDark ? const Color(0xFF252D45) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان بالای پنل.
          Container(
            padding: const EdgeInsets.all(16),
            color: _primaryColor,
            child: const Text(
              'منوی اصلی',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // لیست کلیدها. هر کدام یک ردیف با آیکون و نام است.
          // (بعداً بسته به نقش کاربر، بعضی‌ها را نشان می‌دهیم یا پنهان می‌کنیم.)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _buildMenuItemsForRole(),
            ),
          ),
        ],
      ),
    );
  }

  // ساخت یک کلید (آیتم) از منوی کناری.
  List<Widget> _buildMenuItemsForRole() {
    final user = AuthManager.instance.currentUser;
    final bool isAdmin = user?.isAdmin ?? false;
    final bool isAdmin2 = user?.isAdmin2 ?? false;
    final bool isActionUser = user?.isActionUser ?? false;

    final bool canManage = isAdmin || isAdmin2;
    final bool canDashboard = isAdmin || isAdmin2 || isActionUser;
    final bool canProgress = isAdmin || isAdmin2 || isActionUser;

    final items = <Widget>[];

    if (canProgress) {
      items.add(_buildMenuItem(Icons.add_chart, 'ثبت پیشرفت اکشن‌پلن'));
    }
    if (isAdmin) {
      items.add(
          _buildMenuItem(Icons.admin_panel_settings, 'ابزارهای ادمین'));
      items.add(_buildMenuItem(Icons.manage_accounts, 'مدیریت کاربران'));
      items.add(_buildMenuItem(Icons.cable, 'تنظیمات اتصال'));
    }
    if (canManage) {
      items.add(_buildMenuItem(Icons.calendar_month, 'مدیریت سال و دوره‌ها'));
      items.add(_buildMenuItem(Icons.account_tree, 'مدیریت واحدها'));
      items.add(_buildMenuItem(Icons.task_alt, 'مدیریت فعالیت‌ها'));
      items.add(_buildMenuItem(Icons.flag, 'مدیریت تارگت'));
    }
    if (canDashboard) {
      items.add(_buildMenuItem(Icons.dashboard, 'داشبورد'));
    }
    if (canManage) {
      items.add(_buildMenuItem(Icons.bar_chart, 'گزارش‌گیری'));
    }
    items.add(_buildMenuItem(Icons.settings, 'تنظیمات'));

    return items;
  }

  Widget _buildMenuItem(IconData icon, String label) {
    // آیا حالت شب است؟
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // آیا این آیتم همان بخشی است که الان باز است؟ (برای برجسته کردن)
    final bool isSelected = _currentSection == label;

    // رنگ آیکون و متن: در حالت شب روشن، در حالت روز تیره.
    // اگر این آیتم انتخاب شده باشد، رنگ طلایی می‌گیرد.
    final Color itemColor = isSelected
        ? _accentColor
        : (isDark ? Colors.white70 : _primaryColor);

    return Material(
      color: isSelected
          ? (isDark ? const Color(0xFF323C5E) : const Color(0xFFF0E6CC))
          : (isDark ? const Color(0xFF252D45) : Colors.white),
      child: ListTile(
        leading: Icon(icon, color: itemColor, size: 22),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: itemColor,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        onTap: () {
          _goToSection(label);
        },
      ),
    );
  }

  // ============================================================
  //  (۳) ساخت محتوای اصلی وسط
  //  بر اساس بخش فعلی، محتوای مناسب را نشان می‌دهد.
  // ============================================================
  Widget _buildMainContent() {
    // بر اساس بخشی که کاربر انتخاب کرده، محتوای مناسب را برمی‌گردانیم.
    switch (_currentSection) {
      case 'ثبت پیشرفت اکشن‌پلن':
        final up = AuthManager.instance.currentUser;
        if ((up?.isAdmin ?? false) ||
            (up?.isAdmin2 ?? false) ||
            (up?.isActionUser ?? false)) {
          return const ProgressEntryContent();
        }
        return _buildWelcomeContent();
      case 'داشبورد':
        return const DashboardContent();
      case 'گزارش‌گیری':
        return const ReportsContent();
      case 'تنظیمات':
        // اگر بخش تنظیمات باز است، صفحه‌ی تنظیمات را نشان بده.
        return _buildSettingsContent();
      case 'ابزارهای ادمین':
        if (AuthManager.instance.currentUser?.isAdmin ?? false) {
          return const AdminToolsContent();
        }
        return _buildWelcomeContent();
      case 'مدیریت کاربران':
        if (AuthManager.instance.currentUser?.isAdmin ?? false) {
          return const UsersManagementContent();
        }
        return _buildWelcomeContent();
      case 'تنظیمات اتصال':
        if (AuthManager.instance.currentUser?.isAdmin ?? false) {
          return const ConnectionSettingsContent();
        }
        return _buildWelcomeContent();
      case 'مدیریت سال و دوره‌ها':
        final u = AuthManager.instance.currentUser;
        if ((u?.isAdmin ?? false) || (u?.isAdmin2 ?? false)) {
          return const YearsManagementContent();
        }
        return _buildWelcomeContent();
      case 'مدیریت واحدها':
        final u2 = AuthManager.instance.currentUser;
        if ((u2?.isAdmin ?? false) || (u2?.isAdmin2 ?? false)) {
          return const UnitsManagementContent();
        }
        return _buildWelcomeContent();
      case 'مدیریت فعالیت‌ها':
        final u3 = AuthManager.instance.currentUser;
        if ((u3?.isAdmin ?? false) || (u3?.isAdmin2 ?? false)) {
          return const ActivitiesManagementContent();
        }
        return _buildWelcomeContent();
      case 'مدیریت تارگت':
        final u4 = AuthManager.instance.currentUser;
        if ((u4?.isAdmin ?? false) || (u4?.isAdmin2 ?? false)) {
          return const TargetsManagementContent();
        }
        return _buildWelcomeContent();
      default:
        // در غیر این صورت، صفحه‌ی خوش‌آمد را نشان بده.
        return _buildWelcomeContent();
    }
  }

  // ----- محتوای صفحه‌ی خوش‌آمد (وقتی هیچ بخشی باز نیست) -----
  Widget _buildWelcomeContent() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color titleColor =
        isDark ? Colors.white : _primaryColor;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard_customize,
                size: 64, color: titleColor.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'به ${SettingsManager.instance.systemName} خوش آمدید',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'برای شروع، یکی از گزینه‌های منوی کناری را انتخاب کنید',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : const Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  //  محتوای صفحه‌ی تنظیمات
  //  گزینه‌ها + دکمه‌های خروجی و ورودی.
  // ============================================================
  Widget _buildSettingsContent() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor =
        isDark ? Colors.white : _primaryColor;
    final Color cardColor =
        isDark ? const Color(0xFF252D45) : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان صفحه.
          Text(
            'تنظیمات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'تغییراتی که اینجا می‌دهید خودکار ذخیره می‌شود',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : const Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 20),

          // ----- کارت گزینه‌ی ظاهر (شب/روز) -----
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: SwitchListTile(
              // عنوان گزینه.
              title: Text(
                'حالت شب (تاریک)',
                style: TextStyle(fontSize: 15, color: textColor),
              ),
              subtitle: Text(
                SettingsManager.instance.isDarkMode ? 'روشن' : 'خاموش',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : const Color(0xFF999999),
                ),
              ),
              // مقدار فعلی کلید (از مغز تنظیمات).
              value: SettingsManager.instance.isDarkMode,
              activeColor: _accentColor,
              // وقتی کاربر کلید را زد، تم را عوض کن.
              onChanged: (_) {
                SettingsManager.instance.toggleDarkMode();
                setState(() {}); // صفحه را به‌روز کن تا متن «روشن/خاموش» عوض شود.
              },
            ),
          ),

          const SizedBox(height: 24),

          // ----- بخش انتخاب فصل (استایل) -----
          Text(
            'استایل فصلی',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'رنگ‌بندی برنامه را بر اساس فصل دلخواه انتخاب کنید',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : const Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 12),

          // چهار کارت فصل، کنار هم (با Wrap که اگر جا نشد به خط بعد برود).
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: kSeasonThemes.entries.map((entry) {
              // entry.key نام فصل ('spring' و ...)، entry.value رنگ‌هایش.
              return _buildSeasonCard(entry.key, entry.value, isDark);
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ----- بخش خروجی و ورودی تنظیمات -----
          Text(
            'انتقال تنظیمات',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'می‌توانید تنظیمات خود را دانلود کنید و برای دیگران بفرستید، یا تنظیمات دیگران را وارد کنید',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white60 : const Color(0xFF777777),
            ),
          ),
          const SizedBox(height: 16),

          // دکمه‌های خروجی و ورودی، کنار هم.
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // دکمه‌ی خروجی (دانلود فایل).
              ElevatedButton.icon(
                onPressed: _exportSettingsToFile,
                icon: const Icon(Icons.download),
                label: const Text('دانلود تنظیمات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                ),
              ),

              // دکمه‌ی ورودی (وارد کردن).
              OutlinedButton.icon(
                onPressed: _importSettingsFromText,
                icon: const Icon(Icons.upload),
                label: const Text('وارد کردن تنظیمات'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  side: BorderSide(
                    color: isDark
                        ? const Color(0xFF3A4468)
                        : _primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  //  (۴) ساخت نوار ثابت پایینی (استتوس‌بار)
  //  ساعت، تاریخ و آخرین ورود. فعلاً متن نمونه؛ بعداً واقعی‌اش می‌کنیم.
  // ============================================================
  Widget _buildStatusBar() {
    return StatusBarWidget(backgroundColor: _primaryColor);
  }

  // ============================================================
  //  ساخت یک کارت فصل
  //  هر کارت یک فصل را نشان می‌دهد. با کلیک، آن فصل انتخاب می‌شود.
  // ============================================================
  Widget _buildSeasonCard(String key, SeasonColors sc, bool isDark) {
    // آیا این فصل، همان فصلی است که الان انتخاب شده؟
    final bool isSelected = SettingsManager.instance.season == key;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      // وقتی روی کارت کلیک شد، این فصل را انتخاب کن.
      onTap: () {
        SettingsManager.instance.setSeason(key);
        setState(() {}); // صفحه را به‌روز کن.
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: sc.primary,
          borderRadius: BorderRadius.circular(12),
          // اگر این فصل انتخاب شده، یک قاب روشن دورش بکش.
          border: Border.all(
            color: isSelected ? sc.accent : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            // آیکون فصل.
            Icon(sc.icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            // نام فصل.
            Text(
              sc.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // یک نوار کوچک با رنگ تأکید فصل (برای نمونه).
            Container(
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                color: sc.accent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            // اگر انتخاب شده، یک تیک نشان بده.
            if (isSelected) ...[
              const SizedBox(height: 8),
              Icon(Icons.check_circle, color: sc.accent, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  //  خروجی گرفتن تنظیمات و دانلود به صورت فایل
  // ============================================================
  Future<void> _exportSettingsToFile() async {
    // متن تنظیمات را از مغز می‌گیریم.
    final String settingsText = SettingsManager.instance.exportSettings();

    // متن را به بایت تبدیل می‌کنیم (فایل‌ها از بایت ساخته می‌شوند).
    final Uint8List bytes = Uint8List.fromList(utf8.encode(settingsText));

    try {
      // فایل را با نام مشخص ذخیره/دانلود می‌کنیم.
      await FileSaver.instance.saveFile(
        name: 'actionplan_settings',
        bytes: bytes,
        fileExtension: 'json',
        mimeType: MimeType.json,
      );

      // پیغام موفقیت نشان می‌دهیم.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فایل تنظیمات دانلود شد ✓')),
        );
      }
    } catch (e) {
      // اگر مشکلی پیش آمد، پیغام خطا نشان می‌دهیم.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در دانلود: $e')),
        );
      }
    }
  }

  // ============================================================
  //  وارد کردن تنظیمات با آپلود فایل
  //  یک پنجره‌ی انتخاب فایل باز می‌کند، فایل json را می‌خواند
  //  و تنظیمات را اعمال می‌کند.
  // ============================================================
  Future<void> _importSettingsFromText() async {
    try {
      // پنجره‌ی انتخاب فایل را باز می‌کنیم.
      // فقط فایل‌های json را می‌توان انتخاب کرد.
      // withData: true یعنی محتوای فایل را هم برایمان بخوان (لازم برای وب).
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      // اگر کاربر فایلی انتخاب نکرد (لغو کرد)، کاری نمی‌کنیم.
      if (result == null || result.files.isEmpty) {
        return;
      }

      // محتوای فایل را به صورت بایت می‌گیریم.
      final Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('نمی‌توان فایل را خواند ✗')),
          );
        }
        return;
      }

      // بایت‌ها را به متن تبدیل می‌کنیم.
      final String jsonText = utf8.decode(fileBytes);

      // متن را به مغز می‌دهیم تا تنظیمات را وارد کند.
      final bool success =
          await SettingsManager.instance.importSettings(jsonText);

      // نتیجه را به کاربر نشان می‌دهیم.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'تنظیمات با موفقیت از فایل وارد شد ✓'
                : 'فایل تنظیمات معتبر نیست ✗'),
          ),
        );
        // صفحه را به‌روز می‌کنیم تا تغییرات دیده شود.
        setState(() {});
      }
    } catch (e) {
      // اگر مشکلی پیش آمد، پیغام خطا نشان می‌دهیم.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در وارد کردن فایل: $e')),
        );
      }
    }
  }
}