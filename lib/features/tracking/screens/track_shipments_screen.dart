
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../dashboard/widgets/dashboard_drawer.dart';
import '../data/tracking_dummy_data.dart';
import '../models/tracking_event.dart';
import '../widgets/tracking_search_field.dart';
import '../widgets/tracking_status_card.dart';
import '../widgets/tracking_timeline.dart';

class TrackShipmentsScreen extends StatefulWidget {
  final String? initialTrackingNumber;

  const TrackShipmentsScreen({
    super.key,
    this.initialTrackingNumber,
  });

  @override
  State<TrackShipmentsScreen> createState() =>
      _TrackShipmentsScreenState();
}

class _TrackShipmentsScreenState extends State<TrackShipmentsScreen> {
  static const Color _primary = Color(0xFFF15A00);
  static const Color _dark = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);
  static const Color _background = Color(0xFFF8F9FB);
  static const Color _border = Color(0xFFE8EAF0);
  static const Color _success = Color(0xFF16A36A);
  static const Color _error = Color(0xFFE54848);

  final TextEditingController _searchController =
      TextEditingController();

  TrackingShipment? _selectedShipment;

  bool _isSearching = false;

  final List<String> _recentSearches = [
    'X10-2026-00842',
    'X10-2026-00841',
    'X10-2026-00840',
  ];

  @override
  void initState() {
    super.initState();

    final initialNumber = widget.initialTrackingNumber;

    if (initialNumber != null && initialNumber.trim().isNotEmpty) {
      _searchController.text = initialNumber;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _searchShipment();
      });
    } else {
      _searchController.text = 'X10-2026-00842';
      _selectedShipment =
          TrackingDummyData.findShipment('X10-2026-00842');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // SEARCH
  // --------------------------------------------------

  Future<void> _searchShipment() async {
    FocusScope.of(context).unfocus();

    final trackingNumber = _searchController.text.trim();

    if (trackingNumber.isEmpty) {
      _showMessage(
        'Please enter a tracking number.',
        isError: true,
      );
      return;
    }

    setState(() => _isSearching = true);

    // Simulated frontend search. Replace with backend/API later.
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final result = TrackingDummyData.findShipment(trackingNumber);

    setState(() {
      _isSearching = false;
      _selectedShipment = result;

      if (result != null) {
        _recentSearches.remove(result.trackingNumber);
        _recentSearches.insert(0, result.trackingNumber);

        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      }
    });

    if (result == null) {
      _showMessage(
        'No shipment found for this tracking number.',
        isError: true,
      );
    }
  }

  void _selectRecentSearch(String trackingNumber) {
    _searchController.text = trackingNumber;
    _searchShipment();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? _error : _success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _copyTrackingNumber(String value) async {
    await Clipboard.setData(ClipboardData(text: value));

    if (!mounted) return;

    _showMessage('Tracking number copied.');
  }

  // --------------------------------------------------
  // NAVIGATION
  // --------------------------------------------------

  void _handleDrawerNavigation(String item) {
    Navigator.of(context).pop();

    const routes = {
      'Dashboard': '/home',
      'My Shipments': '/shipments',
      'Create Shipment': '/create-shipment',
      'Track Shipments': '/tracking',
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

    if (route == null || route == '/tracking') {
      return;
    }

    context.go(route);
  }

  Future<void> _handleLogout() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    if (!mounted) return;

    context.go('/login');
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

    if (index < 0 || index >= routes.length || index == 1) {
      return;
    }

    context.go(routes[index]);
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,

      drawer: DashboardDrawer(
        customerName: 'Soumaya',
        customerEmail: 'soumaya@example.com',
        initials: 'S',
        activeItem: 'Track Shipments',
        onItemSelected: _handleDrawerNavigation,
        onLogout: _handleLogout,
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu_rounded,
                color: _dark,
              ),
            );
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track Shipments',
              style: TextStyle(
                color: _dark,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Follow your shipment in real time',
              style: TextStyle(
                color: _muted,
                fontSize: 10,
              ),
            ),
          ],
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: _border,
          ),
        ),
      ),

      body: RefreshIndicator(
        color: _primary,
        onRefresh: _searchShipment,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroCard(),

              const SizedBox(height: 23),

              _buildSectionHeading(
                'Track Your Shipment',
                'Enter your X10 tracking number below.',
              ),

              const SizedBox(height: 13),

              TrackingSearchField(
                controller: _searchController,
                onSearch: _searchShipment,
                isLoading: _isSearching,
              ),

              const SizedBox(height: 17),

              _buildRecentSearches(),

              const SizedBox(height: 25),

              if (_selectedShipment != null) ...[
                _buildResultHeading(),
                const SizedBox(height: 13),

                TrackingStatusCard(
                  shipment: _selectedShipment!,
                ),

                const SizedBox(height: 24),

                _buildSectionHeading(
                  'Tracking History',
                  'A detailed overview of your shipment journey.',
                ),

                const SizedBox(height: 15),

                _buildTimelineCard(),

                const SizedBox(height: 23),

                _buildSectionHeading(
                  'Shipment Information',
                  'Package and carrier details.',
                ),

                const SizedBox(height: 13),

                _buildInformationCard(),

                const SizedBox(height: 18),

                _buildCarrierCard(),
              ] else
                _buildEmptyState(),

              const SizedBox(height: 20),

              _buildSupportBanner(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // --------------------------------------------------
  // INTRO CARD
  // --------------------------------------------------

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF15A00),
            Color(0xFFFF8500),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.19),
            blurRadius: 17,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stay Updated',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Know exactly where your shipment is and follow every delivery milestone.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.17),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.location_searching_rounded,
              color: Colors.white,
              size: 31,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // SECTION HEADINGS
  // --------------------------------------------------

  Widget _buildSectionHeading(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _dark,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: _muted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildResultHeading() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Tracking Result',
            style: TextStyle(
              color: _dark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            if (_selectedShipment != null) {
              _copyTrackingNumber(
                _selectedShipment!.trackingNumber,
              );
            }
          },
          icon: const Icon(
            Icons.copy_rounded,
            size: 14,
          ),
          label: const Text(
            'Copy ID',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: _primary,
            padding: const EdgeInsets.symmetric(horizontal: 5),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // RECENT SEARCHES
  // --------------------------------------------------

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.history_rounded,
              color: _muted,
              size: 16,
            ),
            SizedBox(width: 6),
            Text(
              'Recent Searches',
              style: TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _recentSearches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final number = _recentSearches[index];

              return InkWell(
                onTap: () => _selectRecentSearch(number),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _border),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history_rounded,
                        color: _primary,
                        size: 13,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        number,
                        style: const TextStyle(
                          color: _dark,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // TIMELINE
  // --------------------------------------------------

  Widget _buildTimelineCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 19, 15, 19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: TrackingTimeline(
        events: _selectedShipment!.events,
      ),
    );
  }

  // --------------------------------------------------
  // SHIPMENT INFORMATION
  // --------------------------------------------------

  Widget _buildInformationCard() {
    final shipment = _selectedShipment!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            'Recipient',
            shipment.recipientName,
            Icons.person_outline_rounded,
          ),
          _buildInfoDivider(),
          _buildInfoRow(
            'Phone Number',
            shipment.recipientPhone,
            Icons.phone_outlined,
          ),
          _buildInfoDivider(),
          _buildInfoRow(
            'Package Type',
            shipment.packageType,
            Icons.inventory_2_outlined,
          ),
          _buildInfoDivider(),
          _buildInfoRow(
            'Package Weight',
            shipment.weight,
            Icons.scale_outlined,
          ),
          _buildInfoDivider(),
          _buildInfoRow(
            'Delivery Service',
            shipment.deliveryType,
            Icons.local_shipping_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: _muted,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: _dark,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDivider() {
    return const Divider(
      height: 1,
      color: _border,
    );
  }

  // --------------------------------------------------
  // CARRIER CARD
  // --------------------------------------------------

  Widget _buildCarrierCard() {
    final shipment = _selectedShipment!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Carrier Information',
            style: TextStyle(
              color: _dark,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: _primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shipment.carrierName,
                      style: const TextStyle(
                        color: _dark,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Assigned delivery partner',
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARRIER TRACKING NUMBER',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(
                    shipment.carrierTrackingNumber,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: _dark,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    _copyTrackingNumber(
                      shipment.carrierTrackingNumber,
                    );
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: _primary,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: _muted,
                size: 15,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'External carrier tracking will be available once the carrier integration is activated.',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 10,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // EMPTY STATE
  // --------------------------------------------------

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: _primary,
              size: 31,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'No Shipment Found',
            style: TextStyle(
              color: _dark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Check your tracking number and try again. Make sure you entered the correct reference.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _muted,
              fontSize: 11,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 17),
          TextButton.icon(
            onPressed: () {
              _searchController.clear();
              setState(() => _selectedShipment = null);
            },
            icon: const Icon(Icons.refresh_rounded, size: 17),
            label: const Text('Try Another Number'),
            style: TextButton.styleFrom(
              foregroundColor: _primary,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // SUPPORT BANNER
  // --------------------------------------------------

  Widget _buildSupportBanner() {
    return InkWell(
      onTap: () => context.go('/support'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF6EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _primary.withOpacity(0.12),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: _primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need help with your shipment?',
                    style: TextStyle(
                      color: _dark,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Contact our support team.',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: _primary,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // BOTTOM NAVIGATION
  // --------------------------------------------------

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 9,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.inventory_2_outlined,
                label: 'Shipments',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.add_circle_outline_rounded,
                label: 'Create',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.support_agent_rounded,
                label: 'Support',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final selected = index == 1;

    return Expanded(
      child: InkWell(
        onTap: () => _onNavigationTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? _primary : _muted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: selected ? _primary : _muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
