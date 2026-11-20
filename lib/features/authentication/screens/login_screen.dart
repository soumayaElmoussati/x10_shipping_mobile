
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  static const Color primary = Color(0xFFF15A00);
  static const Color secondary = Color(0xFFFF8500);
  static const Color dark = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);
  static const Color background = Color(0xFFFFFBF8);

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Temporary frontend authentication.
      // Replace this block with the real API request later.
      await Future.delayed(const Duration(milliseconds: 1400));

      await AppConstants.storage.write(
        key: 'auth_token',
        value: 'x10_demo_customer_token',
      );

      await AppConstants.storage.write(
        key: 'user_role',
        value: AppConstants.customerRole,
      );

      if (!mounted) return;

      HapticFeedback.mediumImpact();

      context.go('/home');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to sign in. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Ambient background
          Positioned(
            top: -130,
            right: -100,
            child: _ambientCircle(320),
          ),

          Positioned(
            top: 340,
            left: -150,
            child: _ambientCircle(240),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18),

                            _buildTopBar(),

                            SizedBox(
                              height: screenHeight < 700 ? 30 : 45,
                            ),

                            _buildWelcomeSection(),

                            SizedBox(
                              height: screenHeight < 700 ? 25 : 35,
                            ),

                            _buildLoginForm(),

                            const SizedBox(height: 24),

                            _buildRegisterSection(),

                            const Spacer(),

                            _buildFooter(),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _ambientCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFDCC8).withOpacity(0.28),
      ),
    );
  }

  // ---------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [primary, secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.22),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_shipping_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),

        const SizedBox(width: 11),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'X10 SHIPPING',
              style: TextStyle(
                color: dark,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'SMARTER DELIVERY EXPERIENCE',
              style: TextStyle(
                color: muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFF0EAE5)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.language_rounded,
                color: muted,
                size: 15,
              ),
              SizedBox(width: 5),
              Text(
                'EN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: dark,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.15);
  }

  // ---------------------------------------------------------
  // WELCOME SECTION
  // ---------------------------------------------------------

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEEE4),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.waving_hand_rounded,
                color: primary,
                size: 15,
              ),
              SizedBox(width: 7),
              Text(
                'WELCOME BACK',
                style: TextStyle(
                  color: primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Your deliveries,\n'),
              TextSpan(
                text: 'your control.',
                style: TextStyle(color: primary),
              ),
            ],
          ),
          style: TextStyle(
            fontSize: 35,
            height: 1.16,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            color: dark,
          ),
        ),

        const SizedBox(height: 13),

        const Text(
          'Sign in to manage your shipments and stay connected with every delivery.',
          style: TextStyle(
            color: muted,
            fontSize: 13,
            height: 1.8,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 150.ms).slideY(
          begin: 0.12,
          duration: 650.ms,
          curve: Curves.easeOutCubic,
        );
  }

  // ---------------------------------------------------------
  // LOGIN FORM
  // ---------------------------------------------------------

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Email address'),

          const SizedBox(height: 9),

          _buildEmailField()
              .animate()
              .fadeIn(delay: 250.ms)
              .slideY(begin: 0.12),

          const SizedBox(height: 21),

          _buildFieldLabel('Password'),

          const SizedBox(height: 9),

          _buildPasswordField()
              .animate()
              .fadeIn(delay: 350.ms)
              .slideY(begin: 0.12),

          const SizedBox(height: 17),

          _buildFormOptions(),

          const SizedBox(height: 27),

          _buildLoginButton()
              .animate()
              .fadeIn(delay: 450.ms)
              .slideY(begin: 0.12),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: dark,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      style: const TextStyle(
        fontSize: 13,
        color: dark,
        fontWeight: FontWeight.w600,
      ),
      decoration: _inputDecoration(
        hint: 'Enter your email address',
        icon: Icons.mail_outline_rounded,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email address';
        }

        final emailRegex =
            RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email address';
        }

        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      onFieldSubmitted: (_) => _login(),
      style: const TextStyle(
        fontSize: 13,
        color: dark,
        fontWeight: FontWeight.w600,
      ),
      decoration: _inputDecoration(
        hint: 'Enter your password',
        icon: Icons.lock_outline_rounded,
      ).copyWith(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: muted,
            size: 19,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }

        if (value.length < 6) {
          return 'Password must contain at least 6 characters';
        }

        return null;
      },
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFB4B7BF),
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        icon,
        size: 19,
        color: muted,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 19,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFECE9E6),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFECE9E6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE54848),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFFE54848),
          width: 1.5,
        ),
      ),
      errorStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ---------------------------------------------------------
  // FORM OPTIONS
  // ---------------------------------------------------------

  Widget _buildFormOptions() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() => _rememberMe = !_rememberMe);
          },
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 19,
                height: 19,
                decoration: BoxDecoration(
                  color: _rememberMe ? primary : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _rememberMe
                        ? primary
                        : const Color(0xFFDADDE2),
                  ),
                ),
                child: _rememberMe
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
              const SizedBox(width: 9),
              const Text(
                'Remember me',
                style: TextStyle(
                  fontSize: 11,
                  color: muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        GestureDetector(
          onTap: () => context.push('/forgot-password'),
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 11,
              color: primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // LOGIN BUTTON
  // ---------------------------------------------------------

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primary, secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.24),
              blurRadius: 19,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    key: ValueKey('login'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 19,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // REGISTER
  // ---------------------------------------------------------

  Widget _buildRegisterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: muted,
            fontSize: 12,
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/register'),
          child: const Text(
            'Create account',
            style: TextStyle(
              color: primary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }

  // ---------------------------------------------------------
  // FOOTER
  // ---------------------------------------------------------

  Widget _buildFooter() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_rounded,
              size: 15,
              color: Color(0xFF16A36A),
            ),
            SizedBox(width: 7),
            Text(
              'Your information is secure and protected',
              style: TextStyle(
                fontSize: 10,
                color: muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        const Text(
          '© 2026 X10 Shipping. All rights reserved.',
          style: TextStyle(
            fontSize: 9,
            color: Color(0xFFB0B3BA),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }
}
