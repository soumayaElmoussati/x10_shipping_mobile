
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  static const Color primary = Color(0xFFF15A00);
  static const Color secondary = Color(0xFFFF8500);
  static const Color dark = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);
  static const Color background = Color(0xFFFFFBF8);

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _isLoading = false;

  String _countryCode = '+212';
  String _countryFlag = '🇲🇦';

  double get _passwordStrength {
    final password = _passwordController.text;

    if (password.isEmpty) return 0;

    double score = 0;

    if (password.length >= 8) score += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 0.25;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 0.25;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score += 0.25;

    return score;
  }

  String get _strengthLabel {
    if (_passwordStrength <= 0.25) return 'Weak';
    if (_passwordStrength <= 0.5) return 'Fair';
    if (_passwordStrength <= 0.75) return 'Good';
    return 'Strong';
  }

  Color get _strengthColor {
    if (_passwordStrength <= 0.25) return const Color(0xFFE54848);
    if (_passwordStrength <= 0.5) return const Color(0xFFF0A020);
    if (_passwordStrength <= 0.75) return const Color(0xFF3488D8);
    return const Color(0xFF16A36A);
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      _showMessage('Please accept the terms and conditions.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Frontend simulation only.
      // Backend account creation will be integrated later.
      await Future.delayed(const Duration(milliseconds: 1300));

      if (!mounted) return;

      HapticFeedback.mediumImpact();

      context.push(
        '/verify-account?email=${Uri.encodeComponent(_emailController.text.trim())}',
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark,
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  const SizedBox(height: 30),

                  _buildWelcome(),

                  const SizedBox(height: 28),

                  _buildForm(),

                  const SizedBox(height: 24),

                  _buildLoginLink(),

                  const SizedBox(height: 25),

                  _buildSecurityFooter(),

                  const SizedBox(height: 20),
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
          onTap: () => context.pop(),
          child: Container(
            width: 42,
            height: 42,
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
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 42),
      ],
    );
  }

  // WELCOME

  Widget _buildWelcome() {
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
          child: const Text(
            'JOIN X10 SHIPPING',
            style: TextStyle(
              color: primary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.3,
            ),
          ),
        ),

        const SizedBox(height: 17),

        const Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Create your\n'),
              TextSpan(
                text: 'account.',
                style: TextStyle(color: primary),
              ),
            ],
          ),
          style: TextStyle(
            color: dark,
            fontSize: 34,
            height: 1.15,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.4,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Get started with X10 and manage all your shipments from one place.',
          style: TextStyle(
            color: muted,
            fontSize: 13,
            height: 1.7,
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  // FORM

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('PERSONAL INFORMATION'),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _textField(
                  label: 'First name',
                  hint: 'First name',
                  controller: _firstNameController,
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _textField(
                  label: 'Last name',
                  hint: 'Last name',
                  controller: _lastNameController,
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _textField(
            label: 'Email address',
            hint: 'example@email.com',
            controller: _emailController,
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$')
                  .hasMatch(value.trim())) {
                return 'Invalid email address';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          _buildPhoneField(),

          const SizedBox(height: 27),

          _sectionTitle('SECURITY'),

          const SizedBox(height: 15),

          _passwordField(),

          const SizedBox(height: 13),

          _buildPasswordStrength(),

          const SizedBox(height: 20),

          _confirmPasswordField(),

          const SizedBox(height: 24),

          _buildTerms(),

          const SizedBox(height: 25),

          _buildRegisterButton(),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08);
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            color: dark,
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: dark,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: keyboardType == TextInputType.text
              ? TextCapitalization.words
              : TextCapitalization.none,
          style: const TextStyle(
            fontSize: 12,
            color: dark,
            fontWeight: FontWeight.w600,
          ),
          decoration: _inputDecoration(
            hint: hint,
            icon: icon,
          ),
          validator: validator,
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
      prefixIcon: Icon(icon, size: 18, color: muted),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFECE9E6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFECE9E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE54848)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE54848)),
      ),
      errorStyle: const TextStyle(fontSize: 9),
    );
  }

  // PHONE

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone number',
          style: TextStyle(
            color: dark,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFFECE9E6)),
                ),
                child: Row(
                  children: [
                    Text(
                      _countryFlag,
                      style: const TextStyle(fontSize: 19),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _countryCode,
                      style: const TextStyle(
                        color: dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: muted,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9 ]'),
                  ),
                ],
                style: const TextStyle(
                  fontSize: 12,
                  color: dark,
                  fontWeight: FontWeight.w600,
                ),
                decoration: _inputDecoration(
                  hint: 'Phone number',
                  icon: Icons.phone_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  if (value.replaceAll(' ', '').length < 7) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCountryPicker() {
    final countries = [
      {'flag': '🇲🇦', 'name': 'Morocco', 'code': '+212'},
      {'flag': '🇫🇷', 'name': 'France', 'code': '+33'},
      {'flag': '🇪🇸', 'name': 'Spain', 'code': '+34'},
      {'flag': '🇧🇪', 'name': 'Belgium', 'code': '+32'},
      {'flag': '🇺🇸', 'name': 'United States', 'code': '+1'},
      {'flag': '🇬🇧', 'name': 'United Kingdom', 'code': '+44'},
      {'flag': '🇩🇪', 'name': 'Germany', 'code': '+49'},
      {'flag': '🇨🇦', 'name': 'Canada', 'code': '+1'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select your country',
                  style: TextStyle(
                    color: dark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      final country = countries[index];
                      return ListTile(
                        leading: Text(
                          country['flag']!,
                          style: const TextStyle(fontSize: 23),
                        ),
                        title: Text(
                          country['name']!,
                          style: const TextStyle(
                            color: dark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Text(
                          country['code']!,
                          style: const TextStyle(
                            color: muted,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _countryFlag = country['flag']!;
                            _countryCode = country['code']!;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // PASSWORD

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            color: dark,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 12, color: dark),
          decoration: _inputDecoration(
            hint: 'Create a password',
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
                size: 18,
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

  Widget _buildPasswordStrength() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: _passwordStrength),
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _passwordController.text.isEmpty
                    ? 'Password strength'
                    : _strengthLabel,
                key: ValueKey(_strengthLabel + _passwordController.text.isEmpty.toString()),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: _passwordController.text.isEmpty
                      ? muted
                      : _strengthColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        const Text(
          'Use 8+ characters, uppercase letters, numbers and symbols.',
          style: TextStyle(
            fontSize: 9,
            color: muted,
          ),
        ),
      ],
    );
  }

  Widget _confirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm password',
          style: TextStyle(
            color: dark,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: const TextStyle(fontSize: 12, color: dark),
          decoration: _inputDecoration(
            hint: 'Confirm your password',
            icon: Icons.lock_reset_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: muted,
                size: 18,
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

  // TERMS

  Widget _buildTerms() {
    return GestureDetector(
      onTap: () {
        setState(() => _acceptedTerms = !_acceptedTerms);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _acceptedTerms ? primary : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _acceptedTerms
                    ? primary
                    : const Color(0xFFDADDE2),
              ),
            ),
            child: _acceptedTerms
                ? const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 10,
                  height: 1.6,
                  color: muted,
                ),
                children: [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BUTTON

  Widget _buildRegisterButton() {
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
              color: primary.withOpacity(0.22),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _register,
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
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
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
    );
  }

  // LOGIN LINK

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(color: muted, fontSize: 11),
        ),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: const Text(
            'Sign in',
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityFooter() {
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
          'Your information is protected',
          style: TextStyle(
            color: muted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
