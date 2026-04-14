import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../utils/network_info.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (mounted) setState(() => _error = 'Please enter both email and password.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      if (mounted) setState(() => _error = 'Please enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final success = await _auth.signInWithEmail(email, password);
      if (success && mounted) {
        // Show Offline Indicator if no internet
        bool hasInternet = await NetworkInfo.isConnected();
        if (!hasInternet && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  SizedBox(width: 8),
                  Text('No Internet. Offline Mode Active.'),
                ],
              ),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
        
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
        }
      }
    } catch (e) {
      String errorMessage = 'An error occurred during login.';
      String errorStr = e.toString().toLowerCase();
      if (errorStr.contains('user-not-found') || errorStr.contains('invalid-credential')) {
        errorMessage = 'Invalid email or password.';
      } else if (errorStr.contains('wrong-password')) {
        errorMessage = 'Wrong password provided.';
      } else if (errorStr.contains('invalid-email')) {
        errorMessage = 'The email address is badly formatted.';
      } else if (errorStr.contains('network-request-failed')) {
        errorMessage = 'Network error. Please check your connection.';
      } else {
        errorMessage = e.toString().replaceAll(RegExp(r'^\[.*?\]\s*'), '').replaceAll('Exception: ', '');
      }
      if (mounted) setState(() => _error = errorMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: glassBoxDecoration,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("STRM LOGIN", style: TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accent)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_error.isNotEmpty) Text(_error, style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 20),
                  _isLoading
                    ? const CircularProgressIndicator(color: AppColors.accent)
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                        child: const Text("Login", style: TextStyle(color: AppColors.textPrimary)),
                      ),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: const Text("Create an account", style: TextStyle(color: AppColors.accent)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
