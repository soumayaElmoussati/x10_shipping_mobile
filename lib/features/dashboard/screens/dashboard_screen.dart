
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/dashboard_dummy_data.dart';
import '../widgets/shipment_card.dart';
import '../widgets/dashboard_drawer.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  String _activeDrawerItem = 'Dashboard';

static const String _customerName = 'Soumaya El Moussati';
static const String _customerEmail = 'soumaya@example.com';
static const String _customerInitials = 'SE';

  static const Color orange = Color(0xFFF15A00);
  static const Color orangeLight = Color(0xFFFF8500);
  static const Color background = Color(0xFFF8F9FB);
  static const Color text = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);
  static const Color border = Color(0xFFE8EAF0);



void _handleDrawerNavigation(String item) {
  // Close the drawer first.
  Navigator.of(context).pop();

  const routes = {
    'Dashboard': '/home',
    'My Shipments': '/shipments',
    'Create Shipment': '/create-shipment',
    'Track Shipments': '/shipments',
    'Notifications': '/notifications',
    'My Profile': '/profile',
    'Saved Addresses': '/addresses',
    'Shipment History': '/shipments',
    'Customer Support': '/support',
    'My Support Tickets': '/support',
    'Help Center': '/support',
    'Settings': '/settings',
    'About X10': '/about',
  };

  final route = routes[item];

  if (route == null) return;

  if (route == '/home') {
    setState(() {
      _selectedIndex = 0;
      _activeDrawerItem = 'Dashboard';
    });
    return;
  }

  context.go(route);
}


Future<void> _confirmLogout() async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: text,
          ),
        ),
        content: const Text(
          'Are you sure you want to sign out of your X10 Shipping account?',
          style: TextStyle(
            color: muted,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE54848),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Sign out'),
          ),
        ],
      );
    },
  );

  if (confirmed != true) return;

  await AppConstants.storage.delete(key: 'auth_token');
  await AppConstants.storage.delete(key: 'user_role');

  if (!mounted) return;

  context.go('/login');
}

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature sera disponible prochainement.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: text,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }


void _onNavigationTap(int index) {
  HapticFeedback.selectionClick();

  const routes = [
    '/home',
    '/shipments',
    '/create-shipment',
    '/support',
    '/profile',
  ];

  if (index < 0 || index >= routes.length) return;

  setState(() {
    _selectedIndex = index;
  });

  context.go(routes[index]);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      drawer: DashboardDrawer(
    customerName: _customerName,
    customerEmail: _customerEmail,
    initials: _customerInitials,
    activeItem: _activeDrawerItem,
    onItemSelected: _handleDrawerNavigation,
    onLogout: _confirmLogout,
  ),


      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeader()
                      .animate()
                      .fadeIn(duration: 450.ms)
                      .slideY(begin: -0.08, end: 0),

                  const SizedBox(height: 25),

                  _buildWelcomeCard()
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 500.ms)
                      .slideY(begin: 0.08, end: 0),

                  const SizedBox(height: 27),

                  _buildSectionHeading(
                    title: 'Overviewe',
                    subtitle: 'Track your activity',
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 15),

                  _buildStatistics(),

                  const SizedBox(height: 28),

                  _buildSectionHeading(
                    title: 'Quick access',
                    subtitle: 'Manage your shipments with ease',
                  ).animate().fadeIn(delay: 250.ms),

                  const SizedBox(height: 15),

                  _buildQuickActions(),

                  const SizedBox(height: 29),

                  _buildRecentHeader(),

                  const SizedBox(height: 15),

                  ...DashboardDummyData.recentShipments
                      .asMap()
                      .entries
                      .map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: ShipmentCard(
                        shipment: entry.value,
                        onTap: () {
                          _showComingSoon(
                            'Détails ${entry.value.trackingNumber}',
                          );
                        },
                      )
                          .animate()
                          .fadeIn(
                            delay: (300 + entry.key * 100).ms,
                            duration: 450.ms,
                          )
                          .slideY(begin: 0.08, end: 0),
                    );
                  }),

                  const SizedBox(height: 10),

                  _buildHelpBanner()
                      .animate()
                      .fadeIn(delay: 550.ms)
                      .slideY(begin: 0.08, end: 0),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------

Widget _buildHeader() {
  return Row(
    children: [
      Builder(
        builder: (context) => GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            Scaffold.of(context).openDrawer();
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: text,
              size: 23,
            ),
          ),
        ),
      ),

      const SizedBox(width: 10),

      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [orange, orangeLight],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: orange.withOpacity(0.20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.local_shipping_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),

      const SizedBox(width: 9),

      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'X10 SHIPPING',
              style: TextStyle(
                color: text,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Votre logistique, simplifiée.',
              style: TextStyle(
                color: muted,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      _buildNotificationButton(),

      const SizedBox(width: 9),

      GestureDetector(
        onTap: () => _onNavigationTap(4),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE9DB),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFFD4BB),
            ),
          ),
          child: const Center(
            child: Text(
              'SE',
              style: TextStyle(
                color: orange,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () => _showComingSoon('Notifications'),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: text,
              size: 23,
            ),
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // WELCOME CARD
  // --------------------------------------------------

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(21, 22, 19, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [orange, orangeLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: orange.withOpacity(0.24),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            top: -35,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 34,
            bottom: -75,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.waving_hand_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'BIENVENUE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.verified_rounded,
                    color: Colors.white70,
                    size: 19,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Text(
                'Bonjour, Soumaya !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Prête à expédier ? Gérez toutes vos\nlivraisons depuis un seul endroit.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 21),

              ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showComingSoon('Création d’une expédition');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: orange,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, size: 19),
                    SizedBox(width: 7),
                    Text(
                      'Nouvelle expédition',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 9),
                    Icon(Icons.arrow_forward_rounded, size: 15),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // SECTION HEADING
  // --------------------------------------------------

  Widget _buildSectionHeading({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: text,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: muted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // STATISTICS
  // --------------------------------------------------

  Widget _buildStatistics() {
    final items = [
      _StatisticData(
        title: 'Total expéditions',
        value: DashboardDummyData.totalShipments,
        icon: Icons.inventory_2_rounded,
        color: orange,
        background: const Color(0xFFFFF0E7),
        trend: '+12 ce mois',
      ),
      _StatisticData(
        title: 'En transit',
        value: DashboardDummyData.inTransit,
        icon: Icons.local_shipping_rounded,
        color: const Color(0xFF3488D8),
        background: const Color(0xFFEAF3FF),
        trend: 'En livraison',
      ),
      _StatisticData(
        title: 'Livrées',
        value: DashboardDummyData.delivered,
        icon: Icons.check_circle_rounded,
        color: const Color(0xFF16A36A),
        background: const Color(0xFFE7F7EF),
        trend: 'Terminées',
      ),
      _StatisticData(
        title: 'En attente',
        value: DashboardDummyData.pending,
        icon: Icons.schedule_rounded,
        color: const Color(0xFFF0A020),
        background: const Color(0xFFFFF5E4),
        trend: 'À traiter',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        return _buildStatisticCard(items[index])
            .animate()
            .fadeIn(
              delay: (180 + index * 90).ms,
              duration: 450.ms,
            )
            .scale(
              begin: const Offset(0.96, 0.96),
              end: const Offset(1, 1),
            );
      },
    );
  }

  Widget _buildStatisticCard(_StatisticData item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.018),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: item.background,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 18,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 9),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.value}',
                style: const TextStyle(
                  color: text,
                  fontSize: 25,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  item.trend,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: item.color,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // QUICK ACTIONS
  // --------------------------------------------------

  Widget _buildQuickActions() {
    final actions = [
      _QuickActionData(
        title: 'Créer',
        subtitle: 'Une expédition',
        icon: Icons.add_box_rounded,
        color: orange,
        background: const Color(0xFFFFF0E7),
        onTap: () => _showComingSoon('Nouvelle expédition'),
      ),
      _QuickActionData(
        title: 'Suivre',
        subtitle: 'Un colis',
        icon: Icons.radar_rounded,
        color: const Color(0xFF3488D8),
        background: const Color(0xFFEAF3FF),
        onTap: () => _showComingSoon('Suivi colis'),
      ),
      _QuickActionData(
        title: 'Support',
        subtitle: 'Nous contacter',
        icon: Icons.headset_mic_rounded,
        color: const Color(0xFF16A36A),
        background: const Color(0xFFE7F7EF),
        onTap: () => _showComingSoon('Support client'),
      ),
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 9),
            child: _buildQuickActionCard(action),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionCard(_QuickActionData action) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: action.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: 21,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                action.title,
                style: const TextStyle(
                  color: text,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                action.subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // RECENT SHIPMENTS
  // --------------------------------------------------

  Widget _buildRecentHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expéditions récentes',
                style: TextStyle(
                  color: text,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Retrouvez vos dernières opérations',
                style: TextStyle(
                  color: muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => _showComingSoon('Toutes les expéditions'),
          style: TextButton.styleFrom(
            foregroundColor: orange,
            padding: const EdgeInsets.symmetric(horizontal: 5),
          ),
          child: const Row(
            children: [
              Text(
                'Tout voir',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // HELP BANNER
  // --------------------------------------------------

  Widget _buildHelpBanner() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5EF),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFFFE2D0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: orange,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Besoin d’assistance ?',
                  style: TextStyle(
                    color: text,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Notre équipe est là pour vous aider.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showComingSoon('Support client'),
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: orange,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // BOTTOM NAVIGATION
  // --------------------------------------------------

  Widget _buildBottomNavigation() {
    const items = [
      _NavigationItem(
        icon: Icons.grid_view_rounded,
        label: 'Accueil',
      ),
      _NavigationItem(
        icon: Icons.inventory_2_outlined,
        label: 'Colis',
      ),
      _NavigationItem(
        icon: Icons.add_rounded,
        label: 'Créer',
      ),
      _NavigationItem(
        icon: Icons.headset_mic_outlined,
        label: 'Support',
      ),
      _NavigationItem(
        icon: Icons.person_outline_rounded,
        label: 'Profil',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: border, width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(items.length, (index) {
              final selected = _selectedIndex == index;
              final item = items[index];

              if (index == 2) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onNavigationTap(index),
                    child: Center(
                      child: Container(
                        width: 49,
                        height: 49,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [orange, orangeLight],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: orange.withOpacity(0.27),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onNavigationTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 21,
                        color: selected ? orange : muted,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: selected ? orange : muted,
                          fontSize: 9,
                          fontWeight: selected
                              ? FontWeight.w900
                              : FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: selected ? 13 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// LOCAL DATA CLASSES
// --------------------------------------------------

class _StatisticData {
  final String title;
  final int value;
  final IconData icon;
  final Color color;
  final Color background;
  final String trend;

  const _StatisticData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
    required this.trend,
  });
}

class _QuickActionData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const _QuickActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });
}

class _NavigationItem {
  final IconData icon;
  final String label;

  const _NavigationItem({
    required this.icon,
    required this.label,
  });
}
