import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/screens/login_page.dart';
import 'package:password_manager/services/firestore_service.dart';
import 'dart:ui';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firestoreService = FirestoreService();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestoreService.registerUser(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join Password Vault',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(_nameController, 'Name', Icons.person, validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter name';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    _buildTextField(_emailController, 'Email', Icons.email, validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true, validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter password';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    }),
                    const SizedBox(height: 12),
                    _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock, isPassword: true, validator: (value) {
                      if (value == null || value.isEmpty) return 'Confirm password';
                      if (value != _passwordController.text) return 'Passwords do not match';
                      return null;
                    }),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withOpacity(0.9),
                                Colors.cyan.withOpacity(0.9),
                                Colors.green.withOpacity(0.9),
                                Colors.greenAccent.withOpacity(0.9),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            'Register',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                          },
                          child: Text(
                            'Log In',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false, String? Function(String?)? validator}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey[700], size: 22),
          filled: true,
          fillColor: Colors.white.withOpacity(0.25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          labelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.grey[700],
          ),
          hintStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.grey[500],
          ),
        ),
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Colors.black,
        ),
        validator: validator,
      ),
    );
  }
}