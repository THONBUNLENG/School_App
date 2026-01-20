import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:school_app/extension/navigator_extension.dart';
import 'package:school_app/localization/locale_cn.dart';
import 'package:school_app/localization/locale_en.dart';
import 'package:school_app/localization/locale_km.dart';
import 'package:school_app/screen/home/home_screen/change_notifier.dart';
import 'package:school_app/screen/splash_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    _localization.init(
      mapLocales: [
        MapLocale('en', english, fontFamily: 'Roboto'),
        MapLocale('km', khmer, fontFamily: 'Battambang'),
        MapLocale('zh', chinese, fontFamily: 'ZCOOL_XiaoWei'),
      ],
      initLanguageCode: 'en',
    );

    _localization.onTranslatedLanguage = (locale) {
      if (mounted) setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          navigatorKey: Go.navigatorKey,
          debugShowCheckedModeBanner: false,
          locale: _localization.currentLocale,
          supportedLocales: _localization.supportedLocales,
          localizationsDelegates: _localization.localizationsDelegates,

          themeMode: themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
          darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
          home: const SplashScreen(),
        );
      },
    );
  }
}