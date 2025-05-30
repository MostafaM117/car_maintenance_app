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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to CarPal`
  String get welcome {
    return Intl.message(
      'Welcome to CarPal',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Your all-in-one solution for car maintenance and spare parts,`
  String get welcomedis {
    return Intl.message(
      'Your all-in-one solution for car maintenance and spare parts,',
      name: 'welcomedis',
      desc: '',
      args: [],
    );
  }

  /// `Let’s get started`
  String get get_started {
    return Intl.message(
      'Let’s get started',
      name: 'get_started',
      desc: '',
      args: [],
    );
  }

  /// `I'm a Car Owner`
  String get car_owner {
    return Intl.message(
      'I\'m a Car Owner',
      name: 'car_owner',
      desc: '',
      args: [],
    );
  }

  /// `I'm a Parts Seller`
  String get parts_seller {
    return Intl.message(
      'I\'m a Parts Seller',
      name: 'parts_seller',
      desc: '',
      args: [],
    );
  }

  /// `Whether you're a car owner looking to stay on top of maintenance, or a seller offering trusted parts, we've got you covered.`
  String get get_starteddis {
    return Intl.message(
      'Whether you\'re a car owner looking to stay on top of maintenance, or a seller offering trusted parts, we\'ve got you covered.',
      name: 'get_starteddis',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message('Sign In', name: 'sign_in', desc: '', args: []);
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message('Sign Up', name: 'sign_up', desc: '', args: []);
  }

  /// `Enter your email`
  String get email_or_phone {
    return Intl.message(
      'Enter your email',
      name: 'email_or_phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get password {
    return Intl.message(
      'Enter your password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password? Reset it`
  String get forgot_password {
    return Intl.message(
      'Forget Password? Reset it',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Your account is ready to use!`
  String get congratulations {
    return Intl.message(
      'Your account is ready to use!',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Now you can add your car details to get started.`
  String get add_car_details {
    return Intl.message(
      'Now you can add your car details to get started.',
      name: 'add_car_details',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Dismiss`
  String get dismiss {
    return Intl.message('Dismiss', name: 'dismiss', desc: '', args: []);
  }

  /// `Mileage (KM)`
  String get mileage {
    return Intl.message('Mileage (KM)', name: 'mileage', desc: '', args: []);
  }

  /// `Car Year`
  String get car_year {
    return Intl.message('Car Year', name: 'car_year', desc: '', args: []);
  }

  /// `Car Model`
  String get car_model {
    return Intl.message('Car Model', name: 'car_model', desc: '', args: []);
  }

  /// `Car Make`
  String get car_make {
    return Intl.message('Car Make', name: 'car_make', desc: '', args: []);
  }

  /// `Next Maintenance`
  String get next_maintenance {
    return Intl.message(
      'Next Maintenance',
      name: 'next_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back, User`
  String get welcome_back {
    return Intl.message(
      'Welcome Back, User',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No notifications at the moment`
  String get no_notifications {
    return Intl.message(
      'No notifications at the moment',
      name: 'no_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Add Maintenance`
  String get add_maintenance {
    return Intl.message(
      'Add Maintenance',
      name: 'add_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Delete Maintenance`
  String get delete_maintenance {
    return Intl.message(
      'Delete Maintenance',
      name: 'delete_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Chat Bot`
  String get chatbot {
    return Intl.message('Chat Bot', name: 'chatbot', desc: '', args: []);
  }

  /// `Market`
  String get market {
    return Intl.message('Market', name: 'market', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Offers`
  String get offers {
    return Intl.message('Offers', name: 'offers', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `My Cars`
  String get my_cars {
    return Intl.message('My Cars', name: 'my_cars', desc: '', args: []);
  }

  /// `Add New Car`
  String get add_new_car {
    return Intl.message('Add New Car', name: 'add_new_car', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Log Out`
  String get logout {
    return Intl.message('Log Out', name: 'logout', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
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
