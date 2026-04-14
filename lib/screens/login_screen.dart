import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
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
    setState(() => _isLoading = true);
    try {
      final success = await _auth.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success && mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
      }
    } catch (e) {
      setState(() => _error = e.toString());
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
