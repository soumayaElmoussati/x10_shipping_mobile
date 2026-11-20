
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/constants/app_constants.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() =>
      _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  static const Color primary = Color(0xFFF15A00);
  static const Color secondary = Color(0xFFFF8500);
  static const Color dark = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);
  static const Color background = Color(0xFFFFFBF8);
  static const Color success = Color(0xFF16A36A);

  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  Timer? _timer;

  int _remainingSeconds = 45;
  bool _isLoading = false;
  bool _isVerified = false;
  bool _hasError = false;

  String get _email {
    return GoRouterState.of(context).uri.queryParameters['email'] ??
        'your email address';
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = 45;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          timer.cancel();
        }
      },
    );
  }

  Future<void> _verifyCode() async {
    FocusScope.of(context).unfocus();

    if (_pinController.text.length != 6) {
      setState(() => _hasError = true);
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Demo OTP validation.
      // Replace with backend verification later.
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      if (_pinController.text != '123456') {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });

        HapticFeedback.heavyImpact();
        return;
      }

      _timer?.cancel();

      setState(() {
        _isLoading = false;
        _isVerified = true;
      });

      HapticFeedback.mediumImpact();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _resendCode() async {
    if (_remainingSeconds > 0) return;

    _pinController.clear();
    setState(() => _hasError = false);

    // Simulate sending a new OTP.
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A new verification code has been requested.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _completeVerification() async {
    // Frontend-only demo session.
    // In production, obtain the real token from the API.
    await AppConstants.storage.write(
      key: 'auth_token',
      value: 'x10_demo_customer_token',
    );

    await AppConstants.storage.write(
      key: 'user_role',
      value: AppConstants.customerRole,
    );

    if (!mounted) return;

    context.go('/home');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
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
            bottom: -140,
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
                      child: _isVerified
                          ? _buildSuccessContent()
                          : _buildVerificationContent(),
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

  // VERIFICATION CONTENT

  Widget _buildVerificationContent() {
    return Column(
      key: const ValueKey('verification'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildEmailIllustration(),

        const SizedBox(height: 35),

        const Text(
          'ACCOUNT VERIFICATION',
          style: TextStyle(
            color: primary,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 17),

        const Text(
          'Verify your\nemail address.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dark,
            fontSize: 32,
            height: 1.2,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'We have sent a 6-digit verification code to',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: muted,
            fontSize: 12,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          _email,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: dark,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 34),

        _buildPinInput(),

        if (_hasError) ...[
          const SizedBox(height: 12),
          const Text(
            'Incorrect code. Please try again.',
            style: TextStyle(
              color: Color(0xFFE54848),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],

        const SizedBox(height: 27),

        _buildVerifyButton(),

        const SizedBox(height: 24),

        _buildResendSection(),

        const SizedBox(height: 25),

        _buildDemoHint(),
      ],
    ).animate().fadeIn().slideY(begin: 0.08);
  }

  // ILLUSTRATION

  Widget _buildEmailIllustration() {
    return Center(
      child: SizedBox(
        width: 190,
        height: 175,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEDE2),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 125,
              height: 95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.13),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mark_email_unread_rounded,
                color: primary,
                size: 65,
              ),
            ),
            Positioned(
              top: 7,
              right: 13,
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 10,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.security_rounded,
                  color: primary,
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

  // PIN INPUT

  Widget _buildPinInput() {
    final defaultTheme = PinTheme(
      width: 47,
      height: 57,
      textStyle: const TextStyle(
        color: dark,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFECE9E6)),
      ),
    );

    return Pinput(
      controller: _pinController,
      focusNode: _focusNode,
      length: 6,
      keyboardType: TextInputType.number,
      defaultPinTheme: defaultTheme,
      focusedPinTheme: defaultTheme.copyWith(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primary, width: 1.7),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.08),
              blurRadius: 12,
            ),
          ],
        ),
      ),
      submittedPinTheme: defaultTheme.copyWith(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2EA),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: primary),
        ),
      ),
      errorPinTheme: defaultTheme.copyWith(
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEEE),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE54848)),
        ),
      ),
      forceErrorState: _hasError,
      onChanged: (_) {
        if (_hasError) {
          setState(() => _hasError = false);
        }
      },
      onCompleted: (_) => _verifyCode(),
    );
  }

  // VERIFY BUTTON

  Widget _buildVerifyButton() {
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
          onPressed: _isLoading ? null : _verifyCode,
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
                      'Verify Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
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

  // RESEND

  Widget _buildResendSection() {
    final canResend = _remainingSeconds == 0;

    final minutes =
        (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (_remainingSeconds % 60).toString().padLeft(2, '0');

    return Column(
      children: [
        const Text(
          "Didn't receive the code?",
          style: TextStyle(
            color: muted,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 9),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: canResend ? _resendCode : null,
              child: Text(
                'Resend code',
                style: TextStyle(
                  color: canResend ? primary : muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            if (!canResend) ...[
              const SizedBox(width: 9),
              Text(
                '$minutes:$seconds',
                style: const TextStyle(
                  color: dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDemoHint() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2EA),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFFFE0CC),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: primary,
            size: 17,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Demo mode: use 123456 to verify your account.',
              style: TextStyle(
                color: dark,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SUCCESS

  Widget _buildSuccessContent() {
    return Column(
      key: const ValueKey('verified'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 35),

        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFFE5F6EE),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: success.withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.verified_rounded,
            color: success,
            size: 83,
          ),
        ).animate().scale(
              begin: const Offset(0.4, 0.4),
              curve: Curves.easeOutBack,
              duration: 700.ms,
            ),

        const SizedBox(height: 35),

        const Text(
          'VERIFICATION COMPLETE',
          style: TextStyle(
            color: success,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 18),

        const Text(
          'Your account is\nverified!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dark,
            fontSize: 32,
            height: 1.2,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Welcome to X10 Shipping. Your account is ready. Let’s get your deliveries moving.',
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
            onPressed: _completeVerification,
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
                  'Continue to X10',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
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
          size: 15,
          color: success,
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
