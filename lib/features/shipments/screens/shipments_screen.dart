
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../dashboard/widgets/dashboard_drawer.dart';

// ============================================================
// SHIPMENT MODEL
// ============================================================

class Shipment {
  final String id;
  final String trackingNumber;
  final String recipient;
  final String phone;
  final String origin;
  final String destination;
  final String date;
  final String estimatedDelivery;
  final String carrier;
  final String status;
  final String packageType;
  final String weight;
  final String description;
  final double progress;

  const Shipment({
    required this.id,
    required this.trackingNumber,
    required this.recipient,
    required this.phone,
    required this.origin,
    required this.destination,
    required this.date,
    required this.estimatedDelivery,
    required this.carrier,
    required this.status,
    required this.packageType,
    required this.weight,
    required this.description,
    required this.progress,
  });
}

// ============================================================
// MY SHIPMENTS SCREEN
// ============================================================

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Pending',
    'Approved',
    'In Transit',
    'Delivered',
    'Cancelled',
  ];


final List<Shipment> _shipments = [
  const Shipment(
    id: '1',
    trackingNumber: 'X10-2026-00842',
    recipient: 'Ahmed Al Mansoori',
    phone: '+971 50 123 4567',
    origin: 'Riyadh, Saudi Arabia',
    destination: 'Dubai, UAE',
    date: 'Nov 19, 2026',
    estimatedDelivery: 'Nov 22, 2026',
    carrier: 'Aramex',
    status: 'In Transit',
    packageType: 'Standard Package',
    weight: '2.5 kg',
    description: 'Personal items and accessories',
    progress: 0.65,
  ),
  const Shipment(
    id: '2',
    trackingNumber: 'X10-2026-00839',
    recipient: 'Sara Al Nuaimi',
    phone: '+971 55 234 9876',
    origin: 'Abu Dhabi, UAE',
    destination: 'Dubai, UAE',
    date: 'Nov 18, 2026',
    estimatedDelivery: 'Nov 21, 2026',
    carrier: 'DHL Express',
    status: 'Approved',
    packageType: 'Document',
    weight: '0.5 kg',
    description: 'Business documents',
    progress: 0.25,
  ),
  const Shipment(
    id: '3',
    trackingNumber: 'X10-2026-00831',
    recipient: 'Youssef Al Hashmi',
    phone: '+971 52 345 6789',
    origin: 'Doha, Qatar',
    destination: 'Abu Dhabi, UAE',
    date: 'Nov 16, 2026',
    estimatedDelivery: 'Nov 19, 2026',
    carrier: 'FedEx Express',
    status: 'Delivered',
    packageType: 'Large Package',
    weight: '5.0 kg',
    description: 'Electronic equipment',
    progress: 1.0,
  ),
  const Shipment(
    id: '4',
    trackingNumber: 'X10-2026-00825',
    recipient: 'Omar Al Mazrouei',
    phone: '+971 56 456 3210',
    origin: 'Sharjah, UAE',
    destination: 'Dubai, UAE',
    date: 'Nov 20, 2026',
    estimatedDelivery: 'Pending confirmation',
    carrier: 'Not assigned',
    status: 'Pending',
    packageType: 'Standard Package',
    weight: '1.2 kg',
    description: 'Clothing and accessories',
    progress: 0.10,
  ),
  const Shipment(
    id: '5',
    trackingNumber: 'X10-2026-00819',
    recipient: 'Lina Al Khalifa',
    phone: '+971 58 987 6543',
    origin: 'Muscat, Oman',
    destination: 'Dubai, UAE',
    date: 'Nov 14, 2026',
    estimatedDelivery: 'Cancelled',
    carrier: 'Not assigned',
    status: 'Cancelled',
    packageType: 'Document',
    weight: '0.3 kg',
    description: 'Official documents',
    progress: 0,
  ),
];


  // ==========================================================
  // FILTERING
  // ==========================================================

  List<Shipment> get _filteredShipments {
    final query = _searchController.text.trim().toLowerCase();

    return _shipments.where((shipment) {
      final matchesFilter = _selectedFilter == 'All' ||
          shipment.status == _selectedFilter;

      final matchesSearch =
          shipment.trackingNumber.toLowerCase().contains(query) ||
          shipment.recipient.toLowerCase().contains(query) ||
          shipment.origin.toLowerCase().contains(query) ||
          shipment.destination.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int _countStatus(String status) {
    return _shipments.where((s) => s.status == status).length;
  }

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color _dark = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);
  static const Color _border = Color(0xFFE8EAF0);
  static const Color _pageBackground = Color(0xFFF8F9FB);
  static const Color _orange = Color(0xFFF15A00);
  static const Color _green = Color(0xFF16A36A);
  static const Color _blue = Color(0xFF3488D8);
  static const Color _yellow = Color(0xFFF0A020);
  static const Color _red = Color(0xFFE54848);

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return _yellow;
      case 'Approved':
        return _blue;
      case 'In Transit':
        return _orange;
      case 'Delivered':
        return _green;
      case 'Cancelled':
        return _red;
      default:
        return _muted;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.hourglass_empty_rounded;
      case 'Approved':
        return Icons.check_circle_outline_rounded;
      case 'In Transit':
        return Icons.local_shipping_outlined;
      case 'Delivered':
        return Icons.task_alt_rounded;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  // ==========================================================
  // DRAWER NAVIGATION
  // ==========================================================

void _handleDrawerNavigation(String item) {
  final routes = {
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

  if (route != null) {
    Navigator.pop(context);
    if (route != '/shipments') {
      context.go(route);
    }
  }
}

  Future<void> _handleLogout() async {
    const storage = FlutterSecureStorage();

    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_role');

    if (!mounted) return;
    context.go('/login');
  }

  // ==========================================================
  // SHIPMENT DETAILS
  // ==========================================================

  void _showShipmentDetails(Shipment shipment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 23),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shipment Details',
                        style: TextStyle(
                          color: _dark,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      _statusBadge(shipment.status),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4ED),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            color: _orange,
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tracking Number',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                shipment.trackingNumber,
                                style: const TextStyle(
                                  color: _dark,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: shipment.trackingNumber,
                              ),
                            );
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text('Tracking number copied.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.copy_rounded,
                            color: _orange,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 23),

                  const Text(
                    'Shipment Progress',
                    style: TextStyle(
                      color: _dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildTrackingTimeline(shipment),

                  const SizedBox(height: 24),

                  const Text(
                    'Delivery Route',
                    style: TextStyle(
                      color: _dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 15),

                  _routeRow(
                    Icons.radio_button_checked_rounded,
                    'Origin',
                    shipment.origin,
                    _blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 11),
                    child: Container(
                      width: 1.5,
                      height: 27,
                      color: _border,
                    ),
                  ),
                  _routeRow(
                    Icons.location_on_rounded,
                    'Destination',
                    shipment.destination,
                    _orange,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Recipient Information',
                    style: TextStyle(
                      color: _dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 13),

                  _informationRow(
                    Icons.person_outline_rounded,
                    'Recipient',
                    shipment.recipient,
                  ),
                  _informationRow(
                    Icons.phone_outlined,
                    'Phone Number',
                    shipment.phone,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Package Information',
                    style: TextStyle(
                      color: _dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 13),

                  _informationRow(
                    Icons.inventory_2_outlined,
                    'Package Type',
                    shipment.packageType,
                  ),
                  _informationRow(
                    Icons.scale_outlined,
                    'Weight',
                    shipment.weight,
                  ),
                  _informationRow(
                    Icons.description_outlined,
                    'Description',
                    shipment.description,
                  ),
                  _informationRow(
                    Icons.local_shipping_outlined,
                    'Delivery Company',
                    shipment.carrier,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Important Dates',
                    style: TextStyle(
                      color: _dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 13),

                  _informationRow(
                    Icons.calendar_today_outlined,
                    'Request Date',
                    shipment.date,
                  ),
                  _informationRow(
                    Icons.event_available_outlined,
                    'Estimated Delivery',
                    shipment.estimatedDelivery,
                  ),

                  const SizedBox(height: 20),

                  if (shipment.status != 'Cancelled' &&
                      shipment.status != 'Pending')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetContext);
                          context.push(
                            '/tracking/${shipment.trackingNumber}',
                          );
                        },
                        icon: const Icon(
                          Icons.location_searching_rounded,
                          size: 18,
                        ),
                        label: const Text('View Tracking History'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // TIMELINE
  // ==========================================================

  Widget _buildTrackingTimeline(Shipment shipment) {
    final steps = [
      'Request Created',
      'Request Approved',
      'Assigned to Carrier',
      'Picked Up',
      'In Transit',
      'Delivered',
    ];

    int activeStep;

    switch (shipment.status) {
      case 'Pending':
        activeStep = 0;
        break;
      case 'Approved':
        activeStep = 1;
        break;
      case 'In Transit':
        activeStep = 4;
        break;
      case 'Delivered':
        activeStep = 5;
        break;
      case 'Cancelled':
        activeStep = 0;
        break;
      default:
        activeStep = 0;
    }

    if (shipment.status == 'Cancelled') {
      return Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: _red.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: _red),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'This shipment request has been cancelled.',
                style: TextStyle(
                  color: _red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= activeStep;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
              child: Column(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isCompleted ? _orange : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? _orange : _border,
                        width: 1.5,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 14,
                          )
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 29,
                      color: index < activeStep ? _orange : _border,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 27),
                child: Text(
                  steps[index],
                  style: TextStyle(
                    color: isCompleted ? _dark : _muted,
                    fontSize: 12,
                    fontWeight:
                        isCompleted ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (index == activeStep)
              const Text(
                'Current',
                style: TextStyle(
                  color: _orange,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        );
      }),
    );
  }

  // ==========================================================
  // DETAIL HELPERS
  // ==========================================================

  Widget _routeRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 23),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: _dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _informationRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(icon, color: _muted, size: 18),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
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
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _statusIcon(status),
            size: 12,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STAT CARD
  // ==========================================================

  Widget _buildStatCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 31,
              height: 31,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: color, size: 17),
            ),
            const SizedBox(height: 11),
            Text(
              count.toString().padLeft(2, '0'),
              style: const TextStyle(
                color: _dark,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SHIPMENT CARD
  // ==========================================================

  Widget _buildShipmentCard(Shipment shipment) {
    final statusColor = _statusColor(shipment.status);

    return InkWell(
      onTap: () => _showShipmentDetails(shipment),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: _orange,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipment.trackingNumber,
                        style: const TextStyle(
                          color: _dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shipment.date,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusBadge(shipment.status),
              ],
            ),

            const SizedBox(height: 17),

            // Route
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 10,
                      color: _blue,
                    ),
                    Container(
                      height: 31,
                      width: 1.5,
                      color: _border,
                    ),
                    const Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: _orange,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FROM',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        shipment.origin,
                        style: const TextStyle(
                          color: _dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'TO',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        shipment.destination,
                        style: const TextStyle(
                          color: _dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress
            if (shipment.status != 'Cancelled') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shipment Progress',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '${(shipment.progress * 100).round()}%',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: shipment.progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFF0F1F4),
                  valueColor: AlwaysStoppedAnimation(statusColor),
                ),
              ),
              const SizedBox(height: 15),
            ],

            const Divider(color: _border, height: 1),

            const SizedBox(height: 12),

            // Bottom row
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 15,
                  color: _muted,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    shipment.recipient,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  'View Details',
                  style: TextStyle(
                    color: _orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: _orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // MAIN BUILD
  // ==========================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shipments = _filteredShipments;

    return Scaffold(
      backgroundColor: _pageBackground,

      // Same sidebar drawer as Dashboard and Support.
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.82,
        child: DashboardDrawer(
          customerName: 'Soumaya',
          customerEmail: 'soumaya@example.com',
          initials: 'S',
          activeItem: 'My Shipments',
          onItemSelected: _handleDrawerNavigation,
          onLogout: _handleLogout,
        ),
      ),

      // Same header structure.
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Shipments',
              style: TextStyle(
                color: _dark,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Manage and track your deliveries',
              style: TextStyle(
                color: _muted,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: _dark,
                  size: 25,
                ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _orange,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),

      // Body
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: _orange,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            children: [
              // Page introduction
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Deliveries',
                          style: TextStyle(
                            color: _dark,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Keep track of all your shipment requests.',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/create-shipment'),
                    icon: const Icon(Icons.add_rounded, size: 17),
                    label: const Text(
                      'New Shipment',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 21),

              // Summary
              const Text(
                'Shipment Overview',
                style: TextStyle(
                  color: _dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  _buildStatCard(
                    title: 'Total',
                    count: _shipments.length,
                    color: _orange,
                    icon: Icons.inventory_2_outlined,
                  ),
                  const SizedBox(width: 9),
                  _buildStatCard(
                    title: 'In Transit',
                    count: _countStatus('In Transit'),
                    color: _blue,
                    icon: Icons.local_shipping_outlined,
                  ),
                  const SizedBox(width: 9),
                  _buildStatCard(
                    title: 'Delivered',
                    count: _countStatus('Delivered'),
                    color: _green,
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Search title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Shipments',
                    style: TextStyle(
                      color: _dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${shipments.length} results',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              // Search field
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search tracking number, recipient...',
                  hintStyle: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: _muted,
                    size: 21,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: _muted,
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: _border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: _orange,
                      width: 1.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Status filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final selected = _selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: selected,
                        onSelected: (_) {
                          setState(() => _selectedFilter = filter);
                        },
                        selectedColor: _orange,
                        backgroundColor: Colors.white,
                        showCheckmark: false,
                        side: BorderSide(
                          color: selected ? _orange : _border,
                        ),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : _muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 17),

              // Shipments list
              if (shipments.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: _border),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 43,
                        color: _muted,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No shipments found',
                        style: TextStyle(
                          color: _dark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Try changing your search or selected filter.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...shipments.map(_buildShipmentCard),
            ],
          ),
        ),
      ),

      // Same bottom navigation as Dashboard and Support.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _orange,
        unselectedItemColor: _muted,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        elevation: 12,
        onTap: (index) {
          const routes = [
            '/home',
            '/shipments',
            '/create-shipment',
            '/support',
            '/profile',
          ];

          if (index != 1) {
            context.go(routes[index]);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: 'Shipments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded, size: 25),
            activeIcon: Icon(Icons.add_circle_rounded, size: 25),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset_mic_outlined),
            activeIcon: Icon(Icons.headset_mic_rounded),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
