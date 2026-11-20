
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  static const Color primary = Color(0xFFF15A00);
  static const Color secondary = Color(0xFFFF8500);
  static const Color dark = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);
  static const Color background = Color(0xFFFFFBF8);

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _isCompleted = false;

  double get _strength {
    final password = _passwordController.text;

    if (password.isEmpty) return 0;

    double score = 0;

    if (password.length >= 8) score += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 0.25;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score += 0.25;

    return score;
  }

  String get _strengthText {
    if (_strength <= 0.25) return 'Weak';
    if (_strength <= 0.5) return 'Fair';
    if (_strength <= 0.75) return 'Good';
    return 'Strong';
  }

  Color get _strengthColor {
    if (_strength <= 0.25) return const Color(0xFFE54848);
    if (_strength <= 0.5) return const Color(0xFFF0A020);
    if (_strength <= 0.75) return const Color(0xFF3488D8);
    return const Color(0xFF16A36A);
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Frontend simulation only.
      // The real reset-password endpoint will be integrated later.
      await Future.delayed(const Duration(milliseconds: 1400));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isCompleted = true;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to reset password. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          Positioned(
            top: -130,
            right: -100,
            child: _ambientCircle(300),
          ),

          Positioned(
            bottom: -150,
            left: -100,
            child: _ambientCircle(270),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 45),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      child: _isCompleted
                          ? _buildSuccessContent()
                          : _buildResetForm(),
                    ),

                    const SizedBox(height: 35),

                    _buildFooter(),
                  ],
                ),
              ),
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
        color: const Color(0xFFFFDCC8).withOpacity(0.25),
      ),
    );
  }

  // HEADER

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFECE9E6)),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: dark,
              size: 20,
            ),
          ),
        ),

        const Spacer(),

        const Text(
          'X10 SHIPPING',
          style: TextStyle(
            color: dark,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),

        const Spacer(),

        const SizedBox(width: 43),
      ],
    );
  }

  // FORM

  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('reset-form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIllustration(),

          const SizedBox(height: 35),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEEE4),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'NEW PASSWORD',
              style: TextStyle(
                color: primary,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Create a new\n'),
                TextSpan(
                  text: 'password.',
                  style: TextStyle(color: primary),
                ),
              ],
            ),
            style: TextStyle(
              color: dark,
              fontSize: 33,
              height: 1.17,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.4,
            ),
          ),

          const SizedBox(height: 13),

          const Text(
            'Choose a strong password to keep your X10 account safe and secure.',
            style: TextStyle(
              color: muted,
              fontSize: 13,
              height: 1.8,
            ),
          ),

          const SizedBox(height: 28),

          _buildPasswordField(),

          const SizedBox(height: 13),

          _buildStrengthIndicator(),

          const SizedBox(height: 22),

          _buildConfirmField(),

          const SizedBox(height: 28),

          _buildRequirements(),

          const SizedBox(height: 28),

          _buildSubmitButton(),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.08);
  }

  Widget _buildIllustration() {
    return Center(
      child: SizedBox(
        width: 185,
        height: 165,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 155,
              height: 155,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEDE2),
                shape: BoxShape.circle,
              ),
            ),

            Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.13),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: primary,
                size: 63,
              ),
            ),

            Positioned(
              top: 4,
              right: 5,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A36A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).moveY(
        begin: -5,
        end: 5,
        duration: 2200.ms,
      ),
    );
  }

  // PASSWORD FIELD

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New password',
          style: TextStyle(
            color: dark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 9),

        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(
            color: dark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          decoration: _inputDecoration(
            hint: 'Enter your new password',
            icon: Icons.lock_outline_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
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
              return 'Password is required';
            }
            if (value.length < 8) {
              return 'At least 8 characters required';
            }
            return null;
          },
        ),
      ],
    );
  }

  // STRENGTH

  Widget _buildStrengthIndicator() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _strength),
                  duration: const Duration(milliseconds: 350),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFEEECE9),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _strengthColor,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            Text(
              _passwordController.text.isEmpty
                  ? 'Password strength'
                  : _strengthText,
              style: TextStyle(
                color: _passwordController.text.isEmpty
                    ? muted
                    : _strengthColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // CONFIRM FIELD

  Widget _buildConfirmField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm password',
          style: TextStyle(
            color: dark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 9),

        TextFormField(
          controller: _confirmController,
          obscureText: _obscureConfirm,
          style: const TextStyle(
            color: dark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          decoration: _inputDecoration(
            hint: 'Confirm your new password',
            icon: Icons.lock_reset_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
              icon: Icon(
                _obscureConfirm
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: muted,
                size: 19,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }

            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }

            return null;
          },
        ),
      ],
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
        fontSize: 11,
      ),
      prefixIcon: Icon(icon, size: 19, color: muted),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 19,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFECE9E6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFECE9E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE54848)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE54848)),
      ),
      errorStyle: const TextStyle(fontSize: 10),
    );
  }

  // REQUIREMENTS

  Widget _buildRequirements() {
    final password = _passwordController.text;

    final requirements = [
      ('At least 8 characters', password.length >= 8),
      ('One uppercase letter', RegExp(r'[A-Z]').hasMatch(password)),
      ('One number', RegExp(r'[0-9]').hasMatch(password)),
      ('One special character', RegExp(r'[^A-Za-z0-9]').hasMatch(password)),
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFECE9E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PASSWORD REQUIREMENTS',
            style: TextStyle(
              color: dark,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 13),

          ...requirements.map(
            (requirement) {
              final isValid = requirement.$2;

              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 17,
                      height: 17,
                      decoration: BoxDecoration(
                        color: isValid
                            ? const Color(0xFFE5F6EE)
                            : const Color(0xFFF3F3F3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isValid
                            ? Icons.check_rounded
                            : Icons.circle_outlined,
                        size: 11,
                        color: isValid
                            ? const Color(0xFF16A36A)
                            : muted,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      requirement.$1,
                      style: TextStyle(
                        color: isValid ? dark : muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // SUBMIT

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primary, secondary],
          ),
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.23),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _resetPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Update Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // SUCCESS

  Widget _buildSuccessContent() {
    return Column(
      key: const ValueKey('reset-success'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),

        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFFE5F6EE),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF16A36A).withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF16A36A),
            size: 78,
          ),
        ).animate().scale(
              begin: const Offset(0.4, 0.4),
              curve: Curves.easeOutBack,
              duration: 700.ms,
            ),

        const SizedBox(height: 35),

        const Text(
          'PASSWORD UPDATED',
          style: TextStyle(
            color: Color(0xFF16A36A),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'You are all set!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dark,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Your password has been successfully updated. You can now sign in with your new credentials.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: muted,
            fontSize: 13,
            height: 1.8,
          ),
        ),

        const SizedBox(height: 35),

        SizedBox(
          width: double.infinity,
          height: 57,
          child: ElevatedButton(
            onPressed: () => context.go('/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Back to Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_rounded, size: 19),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user_rounded,
          color: Color(0xFF16A36A),
          size: 15,
        ),
        SizedBox(width: 7),
        Text(
          'Your account security is our priority',
          style: TextStyle(
            color: muted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
