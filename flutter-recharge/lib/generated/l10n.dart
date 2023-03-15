// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Recharge App`
  String get app_name {
    return Intl.message(
      'Recharge App',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `لنبدأ`
  String get lets_begin {
    return Intl.message(
      'لنبدأ',
      name: 'lets_begin',
      desc: '',
      args: [],
    );
  }

  /// `مستعد !`
  String get ready {
    return Intl.message(
      'مستعد !',
      name: 'ready',
      desc: '',
      args: [],
    );
  }

  /// `ارتاح`
  String get relax {
    return Intl.message(
      'ارتاح',
      name: 'relax',
      desc: '',
      args: [],
    );
  }

  /// `تخطى`
  String get skip {
    return Intl.message(
      'تخطى',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `اهتم`
  String get care {
    return Intl.message(
      'اهتم',
      name: 'care',
      desc: '',
      args: [],
    );
  }

  /// `غير مزاجك`
  String get mood {
    return Intl.message(
      'غير مزاجك',
      name: 'mood',
      desc: '',
      args: [],
    );
  }

  /// `مرحبا`
  String get welcome {
    return Intl.message(
      'مرحبا',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `ابق منظمًا وعش خاليًا من الإجهاد باستخدام تطبيق Rechare App`
  String get welcome_text {
    return Intl.message(
      'ابق منظمًا وعش خاليًا من الإجهاد باستخدام تطبيق Rechare App',
      name: 'welcome_text',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل`
  String get sign_up {
    return Intl.message(
      'تسجيل',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول`
  String get login {
    return Intl.message(
      'تسجيل الدخول',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `هل لديك حساب؟`
  String get have_account {
    return Intl.message(
      'هل لديك حساب؟',
      name: 'have_account',
      desc: '',
      args: [],
    );
  }

  /// `الاسم`
  String get your_name {
    return Intl.message(
      'الاسم',
      name: 'your_name',
      desc: '',
      args: [],
    );
  }

  /// `الهاتف`
  String get your_phone {
    return Intl.message(
      'الهاتف',
      name: 'your_phone',
      desc: '',
      args: [],
    );
  }

  /// `البريد الالكتروني`
  String get your_email {
    return Intl.message(
      'البريد الالكتروني',
      name: 'your_email',
      desc: '',
      args: [],
    );
  }

  /// `كلمة السر`
  String get your_password {
    return Intl.message(
      'كلمة السر',
      name: 'your_password',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك حساب !`
  String get dont_have_account {
    return Intl.message(
      'ليس لديك حساب !',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `الرصيد`
  String get balance {
    return Intl.message(
      'الرصيد',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `اليوم 8:26`
  String get today {
    return Intl.message(
      'اليوم 8:26',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get home {
    return Intl.message(
      'الرئيسية',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `مساعدة`
  String get help {
    return Intl.message(
      'مساعدة',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `تعليق`
  String get feedback {
    return Intl.message(
      'تعليق',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `دعوة صديق`
  String get invite_friend {
    return Intl.message(
      'دعوة صديق',
      name: 'invite_friend',
      desc: '',
      args: [],
    );
  }

  /// `قيم التطبيق`
  String get rate_the_app {
    return Intl.message(
      'قيم التطبيق',
      name: 'rate_the_app',
      desc: '',
      args: [],
    );
  }

  /// `معلومات عنا`
  String get about_us {
    return Intl.message(
      'معلومات عنا',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الخروج`
  String get sign_out {
    return Intl.message(
      'تسجيل الخروج',
      name: 'sign_out',
      desc: '',
      args: [],
    );
  }

  /// `شحن توكنز جواكر`
  String get token_shipping {
    return Intl.message(
      'شحن توكنز جواكر',
      name: 'token_shipping',
      desc: '',
      args: [],
    );
  }

  /// `شحن مسرعات الجواكر`
  String get jawaker_accelerator_shipping {
    return Intl.message(
      'شحن مسرعات الجواكر',
      name: 'jawaker_accelerator_shipping',
      desc: '',
      args: [],
    );
  }

  /// `تسوق`
  String get shop {
    return Intl.message(
      'تسوق',
      name: 'shop',
      desc: '',
      args: [],
    );
  }

  /// `اشعارات`
  String get notifications {
    return Intl.message(
      'اشعارات',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `تفاصيل`
  String get details {
    return Intl.message(
      'تفاصيل',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `معاملات`
  String get transactions {
    return Intl.message(
      'معاملات',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `معاملات سابقة`
  String get history {
    return Intl.message(
      'معاملات سابقة',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `مسرع النقاط`
  String get point_accelerator {
    return Intl.message(
      'مسرع النقاط',
      name: 'point_accelerator',
      desc: '',
      args: [],
    );
  }

  /// `موصى به لك`
  String get recommended {
    return Intl.message(
      'موصى به لك',
      name: 'recommended',
      desc: '',
      args: [],
    );
  }

  /// `الرئيسية`
  String get my_dashboard {
    return Intl.message(
      'الرئيسية',
      name: 'my_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `اشعاراتي`
  String get my_notifications {
    return Intl.message(
      'اشعاراتي',
      name: 'my_notifications',
      desc: '',
      args: [],
    );
  }

  /// `معاملاتي`
  String get my_transactions {
    return Intl.message(
      'معاملاتي',
      name: 'my_transactions',
      desc: '',
      args: [],
    );
  }

  /// `تاريخ معاملاتي`
  String get my_history {
    return Intl.message(
      'تاريخ معاملاتي',
      name: 'my_history',
      desc: '',
      args: [],
    );
  }

  /// `شحن مسرعات الجواكر`
  String get add_jawaker_accelaration {
    return Intl.message(
      'شحن مسرعات الجواكر',
      name: 'add_jawaker_accelaration',
      desc: '',
      args: [],
    );
  }

  /// `الكمية`
  String get your_quantity {
    return Intl.message(
      'الكمية',
      name: 'your_quantity',
      desc: '',
      args: [],
    );
  }

  /// `المعرف (ID)`
  String get your_id {
    return Intl.message(
      'المعرف (ID)',
      name: 'your_id',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد الطلب`
  String get confirm {
    return Intl.message(
      'تأكيد الطلب',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `الكلفة : `
  String get cost {
    return Intl.message(
      'الكلفة : ',
      name: 'cost',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
