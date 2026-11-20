
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardDrawer extends StatelessWidget {
  final String customerName;
  final String customerEmail;
  final String initials;
  final String activeItem;
  final ValueChanged<String> onItemSelected;
  final VoidCallback onLogout;

  const DashboardDrawer({
    super.key,
    required this.customerName,
    required this.customerEmail,
    required this.initials,
    required this.activeItem,
    required this.onItemSelected,
    required this.onLogout,
  });

  static const Color orange = Color(0xFFF15A00);
  static const Color orangeLight = Color(0xFFFF8500);
  static const Color text = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);
  static const Color border = Color(0xFFE8EAF0);
  static const Color background = Color(0xFFF8F9FB);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.86;

    return Drawer(
      width: width > 350 ? 350 : width,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 25, 18, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('WORKSPACE'),
                    const SizedBox(height: 13),

                    _buildMenuItem(
                      icon: Icons.grid_view_rounded,
                      title: 'Dashboard',
                    ),
                    _buildMenuItem(
                      icon: Icons.inventory_2_outlined,
                      title: 'My Shipments',
                      badge: '12',
                    ),
                    _buildMenuItem(
                      icon: Icons.add_box_outlined,
                      title: 'Create Shipment',
                    ),
                    _buildMenuItem(
                      icon: Icons.radar_rounded,
                      title: 'Track Shipments',
                    ),
                    _buildMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      badge: '3',
                      badgeColor: const Color(0xFFE54848),
                    ),

                    const SizedBox(height: 27),

                    _sectionLabel('ACCOUNT MANAGEMENT'),
                    const SizedBox(height: 13),

                    _buildMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'My Profile',
                    ),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Saved Addresses',
                    ),
                    _buildMenuItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Shipment History',
                    ),

                    const SizedBox(height: 27),

                    _sectionLabel('HELP & SUPPORT'),
                    const SizedBox(height: 13),

                    _buildMenuItem(
                      icon: Icons.headset_mic_outlined,
                      title: 'Customer Support',
                    ),
                    _buildMenuItem(
                      icon: Icons.confirmation_number_outlined,
                      title: 'My Support Tickets',
                      badge: '2',
                    ),
                    _buildMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Center',
                    ),

                    const SizedBox(height: 27),

                    _sectionLabel('PREFERENCES'),
                    const SizedBox(height: 13),

                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                    ),
                    _buildMenuItem(
                      icon: Icons.info_outline_rounded,
                      title: 'About X10',
                    ),
                  ],
                ),
              ),
            ),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 20, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [orange, orangeLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -65,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.17),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.local_shipping_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'X10 SHIPPING',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Smart shipping. Simplified.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.15),
                      minimumSize: const Size(38, 38),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 29),

              Row(
                children: [
                  Container(
                    width: 57,
                    height: 57,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.65),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: orange,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          customerEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.17),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: Colors.white,
                                size: 11,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'CUSTOMER ACCOUNT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  letterSpacing: 0.7,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // SECTION LABEL
  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 12,
            decoration: BoxDecoration(
              color: orange,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 9),
          Text(
            title,
            style: const TextStyle(
              color: muted,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  // MENU ITEM
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? badge,
    Color? badgeColor,
  }) {
    final selected = activeItem == title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected
            ? const Color(0xFFFFF1E9)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onItemSelected(title),
          splashColor: orange.withOpacity(0.08),
          highlightColor: orange.withOpacity(0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? const Color(0xFFFFDDCA)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: selected
                        ? orange
                        : background,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: selected ? Colors.white : muted,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: selected ? orange : text,
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                ),

                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? orange).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: badgeColor ?? orange,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                if (selected) ...[
                  const SizedBox(width: 7),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: orange,
                    size: 11,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 250),
    );
  }

  // FOOTER
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: border, width: 1),
        ),
      ),
      child: Column(
        children: [
          Material(
            color: const Color(0xFFFFF1F0),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: onLogout,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE54848).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFE54848),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Color(0xFFE54848),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFE54848),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'X10 SHIPPING',
                style: TextStyle(
                  color: muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 4,
                color: orange,
              ),
              SizedBox(width: 7),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: muted,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
