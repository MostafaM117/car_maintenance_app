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

  /// `Welcome Back ,Seller`
  String get welcome_seller {
    return Intl.message(
      'Welcome Back ,Seller',
      name: 'welcome_seller',
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
  String get email {
    return Intl.message('Enter your email', name: 'email', desc: '', args: []);
  }

  /// `Enter your business  email`
  String get emailS {
    return Intl.message(
      'Enter your business  email',
      name: 'emailS',
      desc: '',
      args: [],
    );
  }

  /// `Enter your national id number`
  String get enter_national_id {
    return Intl.message(
      'Enter your national id number',
      name: 'enter_national_id',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to CarPal`
  String get Sign_carPal {
    return Intl.message(
      'Sign in to CarPal',
      name: 'Sign_carPal',
      desc: '',
      args: [],
    );
  }

  /// `sign up to CarPal`
  String get Sigup_carPal {
    return Intl.message(
      'sign up to CarPal',
      name: 'Sigup_carPal',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account?`
  String get Donot_account {
    return Intl.message(
      'Don’t have an account?',
      name: 'Donot_account',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back! Please enter your details!`
  String get welcome_back {
    return Intl.message(
      'Welcome back! Please enter your details!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message('or', name: 'or', desc: '', args: []);
  }

  /// `username`
  String get user_name {
    return Intl.message('username', name: 'user_name', desc: '', args: []);
  }

  /// `Continue with Google`
  String get with_Google {
    return Intl.message(
      'Continue with Google',
      name: 'with_Google',
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
  String get welcome_home {
    return Intl.message(
      'Welcome Back, User',
      name: 'welcome_home',
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

  /// `Create your business account now`
  String get create_business_account {
    return Intl.message(
      'Create your business account now',
      name: 'create_business_account',
      desc: '',
      args: [],
    );
  }

  /// `Enter your business name`
  String get enter_business_name {
    return Intl.message(
      'Enter your business name',
      name: 'enter_business_name',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirm_password {
    return Intl.message(
      'Confirm your password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get already_have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a businessname`
  String get error_enter_businessname {
    return Intl.message(
      'Please enter a businessname',
      name: 'error_enter_businessname',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your national id`
  String get error_enter_national_id {
    return Intl.message(
      'Please enter your national id',
      name: 'error_enter_national_id',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid national id`
  String get error_invalid_national_id {
    return Intl.message(
      'Please enter a valid national id',
      name: 'error_invalid_national_id',
      desc: '',
      args: [],
    );
  }

  /// `An email address is required`
  String get error_enter_email {
    return Intl.message(
      'An email address is required',
      name: 'error_enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get error_invalid_email {
    return Intl.message(
      'Please enter a valid email address',
      name: 'error_invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password to sign up`
  String get error_enter_password {
    return Intl.message(
      'Please enter a password to sign up',
      name: 'error_enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Your password should be at least 6 characters`
  String get error_short_password {
    return Intl.message(
      'Your password should be at least 6 characters',
      name: 'error_short_password',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get error_passwords_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'error_passwords_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a username`
  String get please_enter_username {
    return Intl.message(
      'Please enter a username',
      name: 'please_enter_username',
      desc: '',
      args: [],
    );
  }

  /// `Registered Successfully, Complete Your First time setup`
  String get registered_successfully {
    return Intl.message(
      'Registered Successfully, Complete Your First time setup',
      name: 'registered_successfully',
      desc: '',
      args: [],
    );
  }

  /// `This email is already registered`
  String get email_already_registered {
    return Intl.message(
      'This email is already registered',
      name: 'email_already_registered',
      desc: '',
      args: [],
    );
  }

  /// `Error:`
  String get error_generic {
    return Intl.message('Error:', name: 'error_generic', desc: '', args: []);
  }

  /// `By signing up, you agree to our `
  String get agree_terms_text {
    return Intl.message(
      'By signing up, you agree to our ',
      name: 'agree_terms_text',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service and Privacy Policy.`
  String get terms_and_privacy {
    return Intl.message(
      'Terms of Service and Privacy Policy.',
      name: 'terms_and_privacy',
      desc: '',
      args: [],
    );
  }

  /// `Check terms to continue`
  String get check_terms_warning {
    return Intl.message(
      'Check terms to continue',
      name: 'check_terms_warning',
      desc: '',
      args: [],
    );
  }

  /// `Complete your business account details`
  String get title {
    return Intl.message(
      'Complete your business account details',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your tax registration number`
  String get tax_number {
    return Intl.message(
      'Enter your tax registration number',
      name: 'tax_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter your business phone number`
  String get phone_number {
    return Intl.message(
      'Enter your business phone number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Get your current location`
  String get location {
    return Intl.message(
      'Get your current location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Upload Your Images`
  String get upload_images {
    return Intl.message(
      'Upload Your Images',
      name: 'upload_images',
      desc: '',
      args: [],
    );
  }

  /// `Finish Signing up`
  String get finish_signup {
    return Intl.message(
      'Finish Signing up',
      name: 'finish_signup',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your tax registration number`
  String get error_tax_empty {
    return Intl.message(
      'Please enter your tax registration number',
      name: 'error_tax_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid tax registration number`
  String get error_tax_invalid {
    return Intl.message(
      'Please enter a valid tax registration number',
      name: 'error_tax_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get error_phone_empty {
    return Intl.message(
      'Please enter your phone number',
      name: 'error_phone_empty',
      desc: '',
      args: [],
    );
  }

  /// `Please a valid phone number`
  String get error_phone_invalid {
    return Intl.message(
      'Please a valid phone number',
      name: 'error_phone_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your location`
  String get error_location {
    return Intl.message(
      'Please enter your location',
      name: 'error_location',
      desc: '',
      args: [],
    );
  }

  /// `Please upload the front and back sides of your national ID`
  String get error_id_images {
    return Intl.message(
      'Please upload the front and back sides of your national ID',
      name: 'error_id_images',
      desc: '',
      args: [],
    );
  }

  /// `You can't upload more than 2 images`
  String get error_more_than_two {
    return Intl.message(
      'You can\'t upload more than 2 images',
      name: 'error_more_than_two',
      desc: '',
      args: [],
    );
  }

  /// `Please select the front and back sides of your national ID`
  String get error_select_two {
    return Intl.message(
      'Please select the front and back sides of your national ID',
      name: 'error_select_two',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service must be checked`
  String get error_terms {
    return Intl.message(
      'Terms of Service must be checked',
      name: 'error_terms',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error_general {
    return Intl.message('Error', name: 'error_general', desc: '', args: []);
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
