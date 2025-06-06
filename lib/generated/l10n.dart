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

  /// `I'm a Business Owner`
  String get parts_seller {
    return Intl.message(
      'I\'m a Business Owner',
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

  /// `Enter your business email`
  String get emailS {
    return Intl.message(
      'Enter your business email',
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

  /// `Sign up to CarPal`
  String get Sigup_carPal {
    return Intl.message(
      'Sign up to CarPal',
      name: 'Sigup_carPal',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account? `
  String get Donot_account {
    return Intl.message(
      'Don’t have an account? ',
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

  /// `Enter your Username`
  String get user_name {
    return Intl.message(
      'Enter your Username',
      name: 'user_name',
      desc: '',
      args: [],
    );
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

  /// `Forgot Password? Reset it`
  String get forgot_password {
    return Intl.message(
      'Forgot Password? Reset it',
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

  /// `Delete Account`
  String get delete_Account {
    return Intl.message(
      'Delete Account',
      name: 'delete_Account',
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

  /// `Complete your business account details..`
  String get title {
    return Intl.message(
      'Complete your business account details..',
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

  /// `New`
  String get New {
    return Intl.message('New', name: 'New', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Maintain`
  String get maintain {
    return Intl.message('Maintain', name: 'maintain', desc: '', args: []);
  }

  /// `Maintenance`
  String get maintenance {
    return Intl.message('Maintenance', name: 'maintenance', desc: '', args: []);
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

  /// `Terms and Conditions`
  String get termsTitle {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please read these Terms and Conditions carefully before using the app. By accessing or using the Application, you agree to be bound by these Terms. If you do not agree with any part of the Terms, you must not use the Application.`
  String get termsIntro {
    return Intl.message(
      'Please read these Terms and Conditions carefully before using the app. By accessing or using the Application, you agree to be bound by these Terms. If you do not agree with any part of the Terms, you must not use the Application.',
      name: 'termsIntro',
      desc: '',
      args: [],
    );
  }

  /// `1. Service Description`
  String get section1Title {
    return Intl.message(
      '1. Service Description',
      name: 'section1Title',
      desc: '',
      args: [],
    );
  }

  /// `The Application provides tools for tracking and managing vehicle maintenance, including but not limited to reminders for periodic services, repair log entries, and informational guidance based on user-input data and vehicle-specific maintenance schedules.`
  String get section1Body {
    return Intl.message(
      'The Application provides tools for tracking and managing vehicle maintenance, including but not limited to reminders for periodic services, repair log entries, and informational guidance based on user-input data and vehicle-specific maintenance schedules.',
      name: 'section1Body',
      desc: '',
      args: [],
    );
  }

  /// `2. Disclaimer`
  String get section2Title {
    return Intl.message(
      '2. Disclaimer',
      name: 'section2Title',
      desc: '',
      args: [],
    );
  }

  /// `• The Application is intended for informational and assistance purposes only. It is not a substitute for professional vehicle inspections or certified maintenance services.\n• We make no warranties regarding the completeness, accuracy, or reliability of the data, and accept no liability for damages or breakdowns resulting from reliance on the Application’s content.\n• Information accuracy depends in part on user input, and actual results may vary accordingly.`
  String get section2Body {
    return Intl.message(
      '• The Application is intended for informational and assistance purposes only. It is not a substitute for professional vehicle inspections or certified maintenance services.\n• We make no warranties regarding the completeness, accuracy, or reliability of the data, and accept no liability for damages or breakdowns resulting from reliance on the Application’s content.\n• Information accuracy depends in part on user input, and actual results may vary accordingly.',
      name: 'section2Body',
      desc: '',
      args: [],
    );
  }

  /// `3. Third-Party Parts and Services`
  String get section3Title {
    return Intl.message(
      '3. Third-Party Parts and Services',
      name: 'section3Title',
      desc: '',
      args: [],
    );
  }

  /// `• The Application may act as an intermediary between users and third-party parts suppliers. We do not guarantee the quality, authenticity, or suitability of any parts or services offered.\n• Any transaction conducted outside the Application is strictly between the user and the third party. We disclaim all responsibility for any issues arising from such interactions.\n• We do not warrant the availability or pricing accuracy of listed products.`
  String get section3Body {
    return Intl.message(
      '• The Application may act as an intermediary between users and third-party parts suppliers. We do not guarantee the quality, authenticity, or suitability of any parts or services offered.\n• Any transaction conducted outside the Application is strictly between the user and the third party. We disclaim all responsibility for any issues arising from such interactions.\n• We do not warrant the availability or pricing accuracy of listed products.',
      name: 'section3Body',
      desc: '',
      args: [],
    );
  }

  /// `4. Data Usage and Privacy`
  String get section4Title {
    return Intl.message(
      '4. Data Usage and Privacy',
      name: 'section4Title',
      desc: '',
      args: [],
    );
  }

  /// `• We reserve the right to use aggregated, anonymized user data to improve service quality and analyze usage patterns.\n• User data will be stored securely and not shared with third parties without prior user consent, except as required by law.`
  String get section4Body {
    return Intl.message(
      '• We reserve the right to use aggregated, anonymized user data to improve service quality and analyze usage patterns.\n• User data will be stored securely and not shared with third parties without prior user consent, except as required by law.',
      name: 'section4Body',
      desc: '',
      args: [],
    );
  }

  /// `5. Amendments to Terms`
  String get section5Title {
    return Intl.message(
      '5. Amendments to Terms',
      name: 'section5Title',
      desc: '',
      args: [],
    );
  }

  /// `We reserve the right to modify these Terms at any time. Material changes will be communicated through the Application or via email. Continued use of the Application after such changes constitutes your acceptance of the updated Terms.`
  String get section5Body {
    return Intl.message(
      'We reserve the right to modify these Terms at any time. Material changes will be communicated through the Application or via email. Continued use of the Application after such changes constitutes your acceptance of the updated Terms.',
      name: 'section5Body',
      desc: '',
      args: [],
    );
  }

  /// `6. User Accounts`
  String get section6Title {
    return Intl.message(
      '6. User Accounts',
      name: 'section6Title',
      desc: '',
      args: [],
    );
  }

  /// `• You agree to provide accurate, current, and complete information when creating or updating your account.\n• You are solely responsible for maintaining the confidentiality of your login credentials and for all activities occurring under your account.\n• We reserve the right to suspend or terminate accounts that violate these Terms or contain false or misleading information.`
  String get section6Body {
    return Intl.message(
      '• You agree to provide accurate, current, and complete information when creating or updating your account.\n• You are solely responsible for maintaining the confidentiality of your login credentials and for all activities occurring under your account.\n• We reserve the right to suspend or terminate accounts that violate these Terms or contain false or misleading information.',
      name: 'section6Body',
      desc: '',
      args: [],
    );
  }

  /// `7. User-Submitted Content`
  String get section7Title {
    return Intl.message(
      '7. User-Submitted Content',
      name: 'section7Title',
      desc: '',
      args: [],
    );
  }

  /// `• You are solely responsible for the accuracy of data you submit, including mileage, vehicle information, and repair logs.\n• We reserve the right to edit or remove content that violates our policies or is deemed harmful, misleading, or inappropriate.`
  String get section7Body {
    return Intl.message(
      '• You are solely responsible for the accuracy of data you submit, including mileage, vehicle information, and repair logs.\n• We reserve the right to edit or remove content that violates our policies or is deemed harmful, misleading, or inappropriate.',
      name: 'section7Body',
      desc: '',
      args: [],
    );
  }

  /// `8. Maintenance Reminders and Notifications`
  String get section8Title {
    return Intl.message(
      '8. Maintenance Reminders and Notifications',
      name: 'section8Title',
      desc: '',
      args: [],
    );
  }

  /// `• The Application provides automated notifications based on user-entered data. We do not guarantee the accuracy or timeliness of such notifications.\n• Users are encouraged to regularly inspect their vehicles and not rely solely on the Application for maintenance alerts.`
  String get section8Body {
    return Intl.message(
      '• The Application provides automated notifications based on user-entered data. We do not guarantee the accuracy or timeliness of such notifications.\n• Users are encouraged to regularly inspect their vehicles and not rely solely on the Application for maintenance alerts.',
      name: 'section8Body',
      desc: '',
      args: [],
    );
  }

  /// `9. Prohibited Use`
  String get section9Title {
    return Intl.message(
      '9. Prohibited Use',
      name: 'section9Title',
      desc: '',
      args: [],
    );
  }

  /// `You agree not to:\n• Use the Application for any unlawful, abusive, or fraudulent purposes;\n• Infringe upon the rights of others or violate intellectual property laws;\n• Attempt unauthorized access to the Application or associated systems.\nWe reserve the right to suspend or permanently delete user accounts engaged in prohibited activities.`
  String get section9Body {
    return Intl.message(
      'You agree not to:\n• Use the Application for any unlawful, abusive, or fraudulent purposes;\n• Infringe upon the rights of others or violate intellectual property laws;\n• Attempt unauthorized access to the Application or associated systems.\nWe reserve the right to suspend or permanently delete user accounts engaged in prohibited activities.',
      name: 'section9Body',
      desc: '',
      args: [],
    );
  }

  /// `10. Limitation of Liability`
  String get section10Title {
    return Intl.message(
      '10. Limitation of Liability',
      name: 'section10Title',
      desc: '',
      args: [],
    );
  }

  /// `To the fullest extent permitted by applicable law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of or inability to use the Application.`
  String get section10Body {
    return Intl.message(
      'To the fullest extent permitted by applicable law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of or inability to use the Application.',
      name: 'section10Body',
      desc: '',
      args: [],
    );
  }

  /// `11. Governing Law`
  String get section11Title {
    return Intl.message(
      '11. Governing Law',
      name: 'section11Title',
      desc: '',
      args: [],
    );
  }

  /// `These Terms shall be governed by and construed in accordance with the laws of Egypt.`
  String get section11Body {
    return Intl.message(
      'These Terms shall be governed by and construed in accordance with the laws of Egypt.',
      name: 'section11Body',
      desc: '',
      args: [],
    );
  }

  /// `12. Severability`
  String get section12Title {
    return Intl.message(
      '12. Severability',
      name: 'section12Title',
      desc: '',
      args: [],
    );
  }

  /// `If any provision of these Terms is found to be invalid or unenforceable under applicable law, such provision shall be modified to the minimum extent necessary to make it valid, and the remaining provisions shall remain in full force and effect.`
  String get section12Body {
    return Intl.message(
      'If any provision of these Terms is found to be invalid or unenforceable under applicable law, such provision shall be modified to the minimum extent necessary to make it valid, and the remaining provisions shall remain in full force and effect.',
      name: 'section12Body',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `If you have any questions about these Terms, please contact us at: carapp711@gmail.com.`
  String get contactUsBody {
    return Intl.message(
      'If you have any questions about these Terms, please contact us at: carapp711@gmail.com.',
      name: 'contactUsBody',
      desc: '',
      args: [],
    );
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
