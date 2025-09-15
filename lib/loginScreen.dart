import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/home_screen.dart';
import 'l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;

  const LoginScreen({super.key, this.onLanguageChanged});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  Locale _currentLocale = const Locale('en');

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'username': emailController.text,
          'password': passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(username: data["firstName"] ?? 'User'),
          ),
        );
      } else {
        debugPrint("Login Failed: ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.loginFailed!)),
          );
        }
      }
    } catch (e) {
      debugPrint("Error during login: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _changeLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF50C9C3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildLanguageButton('🇺🇸', 'en', const Locale('en')),
                        const SizedBox(width: 10),
                        _buildLanguageButton('🇳🇵', 'ne', const Locale('ne')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: ClipOval(
                        child: Image.network(
                          "https://img.icons8.com/fluency/96/facebook-new.png",
                          height: 80,
                          width: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    Text(
                      l10n!.welcomeBack!,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.loginToContinue!,
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Email field
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.emailRequired;
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF4A90E2),
                        ),
                        hintText: l10n.emailHint,
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.95),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF50C9C3), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Password field
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.passwordRequired;
                        } else if (value.length < 8) {
                          return l10n.passwordLength;
                        }
                        return null;
                      },
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF4A90E2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        hintText: l10n.password,
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.95),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF50C9C3), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.015),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          debugPrint("Forgot password tapped");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.forgotPasswordNotImplemented!)),
                          );
                        },
                        child: Text(
                          l10n.forgotPassword!,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4A90E2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _isLoading ? null : () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                        )
                            : Text(
                          l10n.login!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Divider with "or"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.6),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            l10n.or!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white.withOpacity(0.6),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      l10n.continueWith!,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(
                          iconPath: "https://img.icons8.com/color/48/google-logo.png",
                          onTap: () {
                            debugPrint("Google Login tapped");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.googleLoginNotImplemented!)),
                            );
                          },
                        ),
                        SizedBox(width: screenWidth * 0.05),
                        _socialButton(
                          iconPath: "https://img.icons8.com/fluency/48/facebook-new.png",
                          onTap: () {
                            debugPrint("Facebook Login tapped");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.facebookLoginNotImplemented!)),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Sign up option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.dontHaveAccount!,
                          style: const TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () {
                            debugPrint("Sign Up tapped");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.signUpNotImplemented!)),
                            );
                          },
                          child: Text(
                            l10n.signUp!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String flag, String languageCode, Locale locale) {
    return GestureDetector(
      onTap: () => _changeLanguage(locale),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _currentLocale.languageCode == languageCode
              ? Colors.white.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: Text(
          flag,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _socialButton({required String iconPath, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Image.network(
          iconPath,
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}