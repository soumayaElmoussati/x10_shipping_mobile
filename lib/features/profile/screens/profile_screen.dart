import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../dashboard/widgets/dashboard_drawer.dart';
import '../data/profile_dummy_data.dart';
import '../widgets/profile_info_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _orange = Color(0xFFF15A00);
  static const Color _dark = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);
  static const Color _background = Color(0xFFF8F9FB);
  static const Color _border = Color(0xFFE8EAF0);
  static const Color _success = Color(0xFF16A36A);

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  late String _fullName;
  late String _email;
  late String _phone;

  bool _pushNotifications = true;
  bool _emailNotifications = true;
  String _language = 'English';

  @override
  void initState() {
    super.initState();

    _fullName = ProfileDummyData.fullName;
    _email = ProfileDummyData.email;
    _phone = ProfileDummyData.phone;
  }

  String get _initials {
    final parts = _fullName.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> _editPersonalInformation() async {
    final nameController = TextEditingController(text: _fullName);
    final emailController = TextEditingController(text: _email);
    final phoneController = TextEditingController(text: _phone);

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Edit personal information',
            style: TextStyle(
              color: _dark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField(
                    controller: nameController,
                    label: 'Full name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _dialogField(
                    controller: emailController,
                    label: 'Email address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _dialogField(
                    controller: phoneController,
                    label: 'Phone number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: _muted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save changes'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        _fullName = nameController.text.trim();
        _email = emailController.text.trim();
        _phone = phoneController.text.trim();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile information updated'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 19),
        filled: true,
        fillColor: _background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange),
        ),
      ),
    );
  }

  void _showSecurityDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Change password',
            style: TextStyle(
              color: _dark,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _passwordField(
                  controller: currentPasswordController,
                  label: 'Current password',
                ),
                const SizedBox(height: 12),
                _passwordField(
                  controller: newPasswordController,
                  label: 'New password',
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Use at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _passwordField(
                  controller: confirmPasswordController,
                  label: 'Confirm new password',
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: _muted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password changes will be enabled after backend integration.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    ).then((_) {
      currentPasswordController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();
    });
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, size: 19),
        filled: true,
        fillColor: _background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange),
        ),
      ),
    );
  }

  void _showPreferences() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Preferences',
                      style: TextStyle(
                        color: _dark,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'LANGUAGE',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    DropdownButtonFormField<String>(
                      value: _language,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.language_outlined,
                          color: _orange,
                        ),
                        filled: true,
                        fillColor: _background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _border),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'Arabic',
                          child: Text('Arabic'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() => _language = value);
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'NOTIFICATIONS',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _pushNotifications,
                      activeColor: _orange,
                      title: const Text(
                        'Push notifications',
                        style: TextStyle(
                          color: _dark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Receive shipment updates on your device',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 11,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _pushNotifications = value);
                        setSheetState(() {});
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _emailNotifications,
                      activeColor: _orange,
                      title: const Text(
                        'Email notifications',
                        style: TextStyle(
                          color: _dark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Receive updates by email',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 11,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _emailNotifications = value);
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _background,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.currency_exchange_rounded,
                            color: _orange,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Display currency',
                              style: TextStyle(
                                color: _dark,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            'AED',
                            style: TextStyle(
                              color: _dark,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 49,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Log out?',
            style: TextStyle(
              color: _dark,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out of your account?',
            style: TextStyle(
              color: _muted,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: _muted),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _storage.deleteAll();

    if (!mounted) return;

    context.go('/login');
  }

  void _handleDrawerNavigation(String item) {
    Navigator.of(context).pop();

    const routes = {
      'Dashboard': '/home',
      'My Shipments': '/shipments',
      'Create Shipment': '/create-shipment',
      'Track Shipments': '/tracking',
      'Notifications': '/notifications',
      'Customer Support': '/support',
      'My Support Tickets': '/support',
      'Help Center': '/support',
    };

    final route = routes[item];

    if (route != null) {
      context.go(route);
    }
  }

  void _onBottomNavigationTap(int index) {
    HapticFeedback.selectionClick();

    const routes = [
      '/home',
      '/shipments',
      '/create-shipment',
      '/support',
      '/profile',
    ];

    if (index < 0 || index >= routes.length || index == 4) return;

    context.go(routes[index]);
  }

  Widget _buildBottomNavigation() {
    const items = [
      (icon: Icons.home_outlined, label: 'Home'),
      (icon: Icons.inventory_2_outlined, label: 'Shipments'),
      (icon: Icons.add_box_outlined, label: 'Create'),
      (icon: Icons.support_agent_outlined, label: 'Support'),
      (icon: Icons.person_outline, label: 'Profile'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 65,
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => _onBottomNavigationTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[i].icon,
                          color: i == 4 ? _orange : _muted,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[i].label,
                          style: TextStyle(
                            color: i == 4 ? _orange : _muted,
                            fontSize: 10,
                            fontWeight: i == 4
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF15A00),
            Color(0xFFFF8500),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.65),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFF8500),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: _success,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            _fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 13),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 13,
                ),
                SizedBox(width: 6),
                Text(
                  'Verified Customer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, String> address) {
    final isHome = address['label'] == 'Home';

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              isHome ? Icons.home_outlined : Icons.business_outlined,
              color: _orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      address['label'] ?? '',
                      style: const TextStyle(
                        color: _dark,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isHome)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F7EF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            color: _success,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  address['name'] ?? '',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address['address'] ?? '',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address['phone'] ?? '',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.location_on_outlined,
            color: _muted,
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = _orange,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 19,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _dark,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: _muted,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      drawer: DashboardDrawer(
        customerName: _fullName,
        customerEmail: _email,
        initials: _initials,
        activeItem: 'My Profile',
        onItemSelected: _handleDrawerNavigation,
        onLogout: _handleLogout,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: _dark,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/notifications'),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: _dark,
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 18),

            ProfileSection(
              title: 'Personal Information',
              trailing: TextButton.icon(
                onPressed: _editPersonalInformation,
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: _orange,
                ),
              ),
              child: Column(
                children: [
                  ProfileInfoTile(
                    icon: Icons.person_outline,
                    title: 'Full name',
                    value: _fullName,
                  ),
                  const Divider(height: 1, color: _border),
                  ProfileInfoTile(
                    icon: Icons.email_outlined,
                    title: 'Email address',
                    value: _email,
                  ),
                  const Divider(height: 1, color: _border),
                  ProfileInfoTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone number',
                    value: _phone,
                  ),
                  const Divider(height: 1, color: _border),
                  const ProfileInfoTile(
                    icon: Icons.badge_outlined,
                    title: 'Customer ID',
                    value: ProfileDummyData.customerId,
                  ),
                  const Divider(height: 1, color: _border),
                  const ProfileInfoTile(
                    icon: Icons.calendar_month_outlined,
                    title: 'Member since',
                    value: ProfileDummyData.memberSince,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            ProfileSection(
              title: 'Saved Addresses',
              trailing: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Address management will be available soon.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text(
                  'Manage',
                  style: TextStyle(
                    color: _orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              child: Column(
                children: [
                  for (final address in ProfileDummyData.addresses)
                    _buildAddressCard(address),
                ],
              ),
            ),

            const SizedBox(height: 15),

            ProfileSection(
              title: 'Account Settings',
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.lock_outline,
                    title: 'Password & Security',
                    subtitle: 'Manage your password and account security',
                    onTap: _showSecurityDialog,
                  ),
                  const Divider(height: 1, color: _border),
                  _buildActionTile(
                    icon: Icons.tune_rounded,
                    title: 'Preferences',
                    subtitle: 'Language and notification preferences',
                    onTap: _showPreferences,
                  ),
                  const Divider(height: 1, color: _border),
                  _buildActionTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notifications',
                    subtitle: 'View your latest shipment updates',
                    onTap: () => context.go('/notifications'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            ProfileSection(
              title: 'Support & Help',
              child: Column(
                children: [
                  _buildActionTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Support',
                    subtitle: 'Get help from our customer support team',
                    onTap: () => context.go('/support'),
                  ),
                  const Divider(height: 1, color: _border),
                  _buildActionTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    subtitle: 'Find answers to common questions',
                    onTap: () => context.go('/support'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE54848),
                  side: const BorderSide(
                    color: Color(0xFFF3CACA),
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Center(
              child: Column(
                children: [
                  Text(
                    'X10 SHIPPING',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}