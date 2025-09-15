import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcomeBack': 'Welcome Back!',
      'loginToContinue': 'Login to continue your journey',
      'email': 'Email',
      'emailHint': 'john45@gmail.com',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'login': 'Login',
      'or': 'OR',
      'continueWith': 'Continue with',
      'dontHaveAccount': 'Don\'t have an account? ',
      'signUp': 'Sign Up',
      'emailRequired': 'Please enter your email',
      'invalidEmail': 'Please enter a valid email',
      'passwordRequired': 'Password cannot be empty',
      'passwordLength': 'Password must be at least 8 characters long',
      'loginFailed': 'Login Failed. Please check your credentials.',
      'forgotPasswordNotImplemented': 'Forgot Password functionality not implemented yet.',
      'googleLoginNotImplemented': 'Google Login not implemented yet.',
      'facebookLoginNotImplemented': 'Facebook Login not implemented yet.',
      'signUpNotImplemented': 'Sign Up functionality not implemented yet.',
    },
    'ne': {
      'welcomeBack': 'फिर्ता स्वागत छ!',
      'loginToContinue': 'तपाईंको यात्रा जारी राख्न लगइन गर्नुहोस्',
      'email': 'इमेल',
      'emailHint': 'john45@gmail.com',
      'password': 'पासवर्ड',
      'forgotPassword': 'पासवर्ड बिर्सनुभयो?',
      'login': 'लगइन गर्नुहोस्',
      'or': 'वा',
      'continueWith': 'जारी राख्नुहोस्',
      'dontHaveAccount': 'खाता छैन? ',
      'signUp': 'साइन अप गर्नुहोस्',
      'emailRequired': 'कृपया आफ्नो इमेल प्रविष्ट गर्नुहोस्',
      'invalidEmail': 'कृपया वैध इमेल प्रविष्ट गर्नुहोस्',
      'passwordRequired': 'पासवर्ड खाली हुन सक्दैन',
      'passwordLength': 'पासवर्ड कम्तिमा ८ वर्ण लामो हुनुपर्छ',
      'loginFailed': 'लगइन असफल भयो। कृपया आफ्नो प्रमाणीकरण जाँच गर्नुहोस्।',
      'forgotPasswordNotImplemented': 'पासवर्ड बिर्सनुको लागि कार्यक्षमता अहिले सम्म लागू गरिएको छैन।',
      'googleLoginNotImplemented': 'गुगल लगइन अहिले सम्म लागू गरिएको छैन।',
      'facebookLoginNotImplemented': 'फेसबुक लगइन अहिले सम्म लागू गरिएको छैन।',
      'signUpNotImplemented': 'साइन अप कार्यक्षमता अहिले सम्म लागू गरिएको छैन।',
    },
  };

  String? get welcomeBack => _localizedValues[locale.languageCode]?['welcomeBack'];
  String? get loginToContinue => _localizedValues[locale.languageCode]?['loginToContinue'];
  String? get email => _localizedValues[locale.languageCode]?['email'];
  String? get emailHint => _localizedValues[locale.languageCode]?['emailHint'];
  String? get password => _localizedValues[locale.languageCode]?['password'];
  String? get forgotPassword => _localizedValues[locale.languageCode]?['forgotPassword'];
  String? get login => _localizedValues[locale.languageCode]?['login'];
  String? get or => _localizedValues[locale.languageCode]?['or'];
  String? get continueWith => _localizedValues[locale.languageCode]?['continueWith'];
  String? get dontHaveAccount => _localizedValues[locale.languageCode]?['dontHaveAccount'];
  String? get signUp => _localizedValues[locale.languageCode]?['signUp'];
  String? get emailRequired => _localizedValues[locale.languageCode]?['emailRequired'];
  String? get invalidEmail => _localizedValues[locale.languageCode]?['invalidEmail'];
  String? get passwordRequired => _localizedValues[locale.languageCode]?['passwordRequired'];
  String? get passwordLength => _localizedValues[locale.languageCode]?['passwordLength'];
  String? get loginFailed => _localizedValues[locale.languageCode]?['loginFailed'];
  String? get forgotPasswordNotImplemented => _localizedValues[locale.languageCode]?['forgotPasswordNotImplemented'];
  String? get googleLoginNotImplemented => _localizedValues[locale.languageCode]?['googleLoginNotImplemented'];
  String? get facebookLoginNotImplemented => _localizedValues[locale.languageCode]?['facebookLoginNotImplemented'];
  String? get signUpNotImplemented => _localizedValues[locale.languageCode]?['signUpNotImplemented'];
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ne'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}