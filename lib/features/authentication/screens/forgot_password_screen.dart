
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  static const Color primary = Color(0xFFF15A00);
  static const Color secondary = Color(0xFFFF8500);
  static const Color dark = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);
  static const Color background = Color(0xFFFFFBF8);

  bool _isLoading = false;
  bool _emailSent = false;

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulated frontend request.
      // Replace with the password-reset API later.
      await Future.delayed(const Duration(milliseconds: 1400));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to send the reset request.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
            left: -110,
            child: _ambientCircle(270),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  _buildHeader(),

                  const Spacer(),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _emailSent
                        ? _buildSuccessContent()
                        : _buildFormContent(),
                  ),

                  const Spacer(),

                  _buildFooter(),

                  const SizedBox(height: 25),
                ],
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
          onTap: () {
            if (_emailSent) {
              setState(() => _emailSent = false);
            } else {
              context.pop();
            }
          },
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
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: dark,
          ),
        ),

        const Spacer(),

        const SizedBox(width: 43),
      ],
    );
  }

  // FORM CONTENT

  Widget _buildFormContent() {
    return Column(
      key: const ValueKey('forgot-form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIllustration(),

        const SizedBox(height: 37),

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
            'ACCOUNT RECOVERY',
            style: TextStyle(
              color: primary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.3,
            ),
          ),
        ),

        const SizedBox(height: 19),

        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Forgot your\n'),
              TextSpan(
                text: 'password?',
                style: TextStyle(color: primary),
              ),
            ],
          ),
          style: TextStyle(
            color: dark,
            fontSize: 34,
            height: 1.16,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'No worries! Enter the email address associated with your account and we will help you reset your password.',
          style: TextStyle(
            color: muted,
            fontSize: 13,
            height: 1.8,
          ),
        ),

        const SizedBox(height: 28),

        _buildEmailForm(),

        const SizedBox(height: 22),

        _buildSendButton(),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildIllustration() {
    return Center(
      child: SizedBox(
        width: 190,
        height: 175,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 165,
              height: 165,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFEDE2),
              ),
            ),

            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.12),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: primary,
                size: 65,
              ),
            ),

            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 39,
                height: 39,
                decoration: const BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.question_mark_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ),

            Positioned(
              bottom: 8,
              left: 15,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A36A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 19,
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

  Widget _buildEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Email address',
            style: TextStyle(
              color: dark,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 9),

          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            style: const TextStyle(
              color: dark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Enter your registered email',
              hintStyle: const TextStyle(
                color: Color(0xFFB4B7BF),
                fontSize: 11,
              ),
              prefixIcon: const Icon(
                Icons.mail_outline_rounded,
                color: muted,
                size: 19,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
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
                ),
              ),
              errorStyle: const TextStyle(fontSize: 10),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email address is required';
              }

              if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$')
                  .hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
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
          onPressed: _isLoading ? null : _sendResetLink,
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
                      'Send Reset Instructions',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // SUCCESS STATE

  Widget _buildSuccessContent() {
    return Column(
      key: const ValueKey('forgot-success'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 35),

        Container(
          width: 145,
          height: 145,
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
            Icons.mark_email_read_rounded,
            color: Color(0xFF16A36A),
            size: 75,
          ),
        ).animate().scale(
              begin: const Offset(0.5, 0.5),
              curve: Curves.easeOutBack,
              duration: 650.ms,
            ),

        const SizedBox(height: 35),

        const Text(
          'CHECK YOUR EMAIL',
          style: TextStyle(
            color: Color(0xFF16A36A),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Instructions are on\ntheir way!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dark,
            fontSize: 31,
            height: 1.2,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          'If this address is registered, you will receive password reset instructions at ${_emailController.text.trim()}.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: muted,
            fontSize: 13,
            height: 1.8,
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          height: 55,
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
            child: const Text(
              'Back to Sign In',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: const Text(
            'Try another email address',
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // FOOTER

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
          'Your account security matters to us',
          style: TextStyle(
            color: muted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
