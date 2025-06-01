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

  /// `Your all-in-one solution for car maintenance and spare parts`
  String get welcomedis {
    return Intl.message(
      'Your all-in-one solution for car maintenance and spare parts',
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

  /// `Welcome Back, {name}!`
  String welcome_home(Object name) {
    return Intl.message(
      'Welcome Back, $name!',
      name: 'welcome_home',
      desc: '',
      args: [name],
    );
  }

  /// `Tap here and we’ll help you out!`
  String get support_text {
    return Intl.message(
      'Tap here and we’ll help you out!',
      name: 'support_text',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get explore {
    return Intl.message('Explore', name: 'explore', desc: '', args: []);
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

  /// `ADD \nMaintenance`
  String get add_maintenanceh {
    return Intl.message(
      'ADD \nMaintenance',
      name: 'add_maintenanceh',
      desc: '',
      args: [],
    );
  }

  /// `ASK \nCHAT BOT`
  String get ask_chatbot {
    return Intl.message(
      'ASK \nCHAT BOT',
      name: 'ask_chatbot',
      desc: '',
      args: [],
    );
  }

  /// `CHECKOUT\nOFFERS`
  String get checkout_offers {
    return Intl.message(
      'CHECKOUT\nOFFERS',
      name: 'checkout_offers',
      desc: '',
      args: [],
    );
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

  /// `View All`
  String get view_all {
    return Intl.message('View All', name: 'view_all', desc: '', args: []);
  }

  /// `No maintenance records available.`
  String get no_maintenance_records {
    return Intl.message(
      'No maintenance records available.',
      name: 'no_maintenance_records',
      desc: '',
      args: [],
    );
  }

  /// `No upcoming maintenance needed.`
  String get no_upcoming_maintenance {
    return Intl.message(
      'No upcoming maintenance needed.',
      name: 'no_upcoming_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Please add a car to see maintenance items`
  String get please_add_car_to_see_maintenance {
    return Intl.message(
      'Please add a car to see maintenance items',
      name: 'please_add_car_to_see_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `All Upcoming Maintenance`
  String get all_upcoming_maintenance {
    return Intl.message(
      'All Upcoming Maintenance',
      name: 'all_upcoming_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `Add maintenance`
  String get add_maintenance {
    return Intl.message(
      'Add maintenance',
      name: 'add_maintenance',
      desc: '',
      args: [],
    );
  }

  /// `No cars found. Add a car to see it here.`
  String get no_cars_found {
    return Intl.message(
      'No cars found. Add a car to see it here.',
      name: 'no_cars_found',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your car?`
  String get confirm_delete_car {
    return Intl.message(
      'Are you sure you want to delete your car?',
      name: 'confirm_delete_car',
      desc: '',
      args: [],
    );
  }

  /// `This action is permanent and cannot be undone. All your data will be permanently removed.`
  String get delete_warning {
    return Intl.message(
      'This action is permanent and cannot be undone. All your data will be permanently removed.',
      name: 'delete_warning',
      desc: '',
      args: [],
    );
  }

  /// `Car deleted successfully`
  String get car_deleted_successfully {
    return Intl.message(
      'Car deleted successfully',
      name: 'car_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Average monthly usage (KM)`
  String get average_monthly_usage_km {
    return Intl.message(
      'Average monthly usage (KM)',
      name: 'average_monthly_usage_km',
      desc: '',
      args: [],
    );
  }

  /// `Average (KM)`
  String get average_km {
    return Intl.message('Average (KM)', name: 'average_km', desc: '', args: []);
  }

  /// `Please enter average usage`
  String get please_enter_average_usage {
    return Intl.message(
      'Please enter average usage',
      name: 'please_enter_average_usage',
      desc: '',
      args: [],
    );
  }

  /// `Current car mileage (Approx.)`
  String get current_car_mileage {
    return Intl.message(
      'Current car mileage (Approx.)',
      name: 'current_car_mileage',
      desc: '',
      args: [],
    );
  }

  /// `Mileage (KM)`
  String get mileage_hint {
    return Intl.message(
      'Mileage (KM)',
      name: 'mileage_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter mileage`
  String get please_enter_mileage {
    return Intl.message(
      'Please enter mileage',
      name: 'please_enter_mileage',
      desc: '',
      args: [],
    );
  }

  /// `Used`
  String get used {
    return Intl.message('Used', name: 'used', desc: '', args: []);
  }

  /// `Unused`
  String get Unused {
    return Intl.message('Unused', name: 'Unused', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Maintain`
  String get maintain {
    return Intl.message('Maintain', name: 'maintain', desc: '', args: []);
  }

  /// `maintenance`
  String get maintenance {
    return Intl.message('maintenance', name: 'maintenance', desc: '', args: []);
  }

  /// `Terms & Conditions`
  String get terms_conditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Maintenance Details`
  String get maintenanceDetails {
    return Intl.message(
      'Maintenance Details',
      name: 'maintenanceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance Type`
  String get maintenanceType {
    return Intl.message(
      'Maintenance Type',
      name: 'maintenanceType',
      desc: '',
      args: [],
    );
  }

  /// `Current mileage`
  String get currentMileage {
    return Intl.message(
      'Current mileage',
      name: 'currentMileage',
      desc: '',
      args: [],
    );
  }

  /// `Expected Date`
  String get expectedDate {
    return Intl.message(
      'Expected Date',
      name: 'expectedDate',
      desc: '',
      args: [],
    );
  }

  /// `Maintenance Status`
  String get maintenanceStatus {
    return Intl.message(
      'Maintenance Status',
      name: 'maintenanceStatus',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Upcoming`
  String get Upcoming {
    return Intl.message('Upcoming', name: 'Upcoming', desc: '', args: []);
  }

  /// `Completed`
  String get Completed {
    return Intl.message('Completed', name: 'Completed', desc: '', args: []);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `This is the home page`
  String get tutorialHome {
    return Intl.message(
      'This is the home page',
      name: 'tutorialHome',
      desc: '',
      args: [],
    );
  }

  /// `This is maintenance`
  String get tutorialMaintain {
    return Intl.message(
      'This is maintenance',
      name: 'tutorialMaintain',
      desc: '',
      args: [],
    );
  }

  /// `This is the chatbot`
  String get tutorialChatbot {
    return Intl.message(
      'This is the chatbot',
      name: 'tutorialChatbot',
      desc: '',
      args: [],
    );
  }

  /// `This is the market`
  String get tutorialMarket {
    return Intl.message(
      'This is the market',
      name: 'tutorialMarket',
      desc: '',
      args: [],
    );
  }

  /// `This is your profile`
  String get tutorialProfile {
    return Intl.message(
      'This is your profile',
      name: 'tutorialProfile',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get greeting {
    return Intl.message('Hi', name: 'greeting', desc: '', args: []);
  }

  /// `User`
  String get defaultUsername {
    return Intl.message('User', name: 'defaultUsername', desc: '', args: []);
  }

  /// `Please fill in your car details to continue.`
  String get instruction {
    return Intl.message(
      'Please fill in your car details to continue.',
      name: 'instruction',
      desc: '',
      args: [],
    );
  }

  /// `Car Make`
  String get carMake {
    return Intl.message('Car Make', name: 'carMake', desc: '', args: []);
  }

  /// `Car Model`
  String get carModel {
    return Intl.message('Car Model', name: 'carModel', desc: '', args: []);
  }

  /// `Model Year`
  String get modelYear {
    return Intl.message('Model Year', name: 'modelYear', desc: '', args: []);
  }

  /// `Current car mileage (Approx.)`
  String get mileageLabel {
    return Intl.message(
      'Current car mileage (Approx.)',
      name: 'mileageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Mileage (KM)`
  String get mileageHint {
    return Intl.message(
      'Mileage (KM)',
      name: 'mileageHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter mileage`
  String get mileageError {
    return Intl.message(
      'Please enter mileage',
      name: 'mileageError',
      desc: '',
      args: [],
    );
  }

  /// `Average monthly usage (KM)`
  String get averageUsageLabel {
    return Intl.message(
      'Average monthly usage (KM)',
      name: 'averageUsageLabel',
      desc: '',
      args: [],
    );
  }

  /// `Average (KM)`
  String get averageUsageHint {
    return Intl.message(
      'Average (KM)',
      name: 'averageUsageHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter average usage`
  String get averageUsageError {
    return Intl.message(
      'Please enter average usage',
      name: 'averageUsageError',
      desc: '',
      args: [],
    );
  }

  /// `Last periodic Maintenance`
  String get lastMaintenance {
    return Intl.message(
      'Last periodic Maintenance',
      name: 'lastMaintenance',
      desc: '',
      args: [],
    );
  }

  /// `Select Maintenance Date`
  String get selectMaintenanceDate {
    return Intl.message(
      'Select Maintenance Date',
      name: 'selectMaintenanceDate',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this item?`
  String get permanentDeleteTitle {
    return Intl.message(
      'Are you sure you want to delete this item?',
      name: 'permanentDeleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `This action is permanent and cannot be undone.`
  String get permanentDeleteMessage {
    return Intl.message(
      'This action is permanent and cannot be undone.',
      name: 'permanentDeleteMessage',
      desc: '',
      args: [],
    );
  }

  /// `Product Name`
  String get productName {
    return Intl.message(
      'Product Name',
      name: 'productName',
      desc: '',
      args: [],
    );
  }

  /// `Add Product Name`
  String get addProductName {
    return Intl.message(
      'Add Product Name',
      name: 'addProductName',
      desc: '',
      args: [],
    );
  }

  /// `Product Category`
  String get productCategory {
    return Intl.message(
      'Product Category',
      name: 'productCategory',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get availability {
    return Intl.message(
      'Availability',
      name: 'availability',
      desc: '',
      args: [],
    );
  }

  /// `Stock Count`
  String get stockCount {
    return Intl.message('Stock Count', name: 'stockCount', desc: '', args: []);
  }

  /// `Add Count`
  String get addCount {
    return Intl.message('Add Count', name: 'addCount', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Add Price`
  String get addPrice {
    return Intl.message('Add Price', name: 'addPrice', desc: '', args: []);
  }

  /// `Discard`
  String get discard {
    return Intl.message('Discard', name: 'discard', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Done`
  String get Done {
    return Intl.message('Done', name: 'Done', desc: '', args: []);
  }

  /// `Please add a car to see maintenance items`
  String get addCarToViewMaintenance {
    return Intl.message(
      'Please add a car to see maintenance items',
      name: 'addCarToViewMaintenance',
      desc: '',
      args: [],
    );
  }

  /// `undo`
  String get undo {
    return Intl.message('undo', name: 'undo', desc: '', args: []);
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
