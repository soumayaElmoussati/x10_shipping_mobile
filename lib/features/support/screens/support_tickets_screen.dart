
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../dashboard/widgets/dashboard_drawer.dart';

class SupportTicket {
  final String id;
  final String subject;
  final String category;
  final String description;
  final String date;
  final String status;
  final String priority;
  final String lastMessage;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.category,
    required this.description,
    required this.date,
    required this.status,
    required this.priority,
    required this.lastMessage,
  });
}

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'All';
  String _selectedCategory = 'Shipment Issue';
  String _selectedPriority = 'Medium';

  final List<String> _filters = [
    'All',
    'Open',
    'In Progress',
    'Resolved',
  ];

  final List<SupportTicket> _tickets = [
    SupportTicket(
      id: 'X10-2026-0042',
      subject: 'Delayed shipment',
      category: 'Shipment Issue',
      description:
          'My shipment has not arrived at the expected delivery date. '
          'Could you please check its current status?',
      date: 'Nov 19, 2026',
      status: 'In Progress',
      priority: 'High',
      lastMessage: 'Our team is checking with the delivery company.',
    ),
    SupportTicket(
      id: 'X10-2026-0039',
      subject: 'Incorrect tracking information',
      category: 'Tracking',
      description:
          'The tracking information has not been updated for several days.',
      date: 'Nov 18, 2026',
      status: 'Open',
      priority: 'Medium',
      lastMessage: 'Your request has been received.',
    ),
    SupportTicket(
      id: 'X10-2026-0035',
      subject: 'Recipient address correction',
      category: 'Address Update',
      description:
          'I would like to request a correction to the recipient address.',
      date: 'Nov 16, 2026',
      status: 'Resolved',
      priority: 'Low',
      lastMessage: 'The address update request has been processed.',
    ),
    SupportTicket(
      id: 'X10-2026-0031',
      subject: 'Unable to create a shipment',
      category: 'Technical Issue',
      description:
          'I encountered an error while submitting a new shipment request.',
      date: 'Nov 14, 2026',
      status: 'Open',
      priority: 'High',
      lastMessage: 'Our support team will review your request.',
    ),
  ];

  List<SupportTicket> get _filteredTickets {
    final query = _searchController.text.toLowerCase();

    return _tickets.where((ticket) {
      final matchesFilter = _selectedFilter == 'All' ||
          ticket.status == _selectedFilter;

      final matchesSearch = ticket.subject.toLowerCase().contains(query) ||
          ticket.id.toLowerCase().contains(query) ||
          ticket.category.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  int get _openCount =>
      _tickets.where((ticket) => ticket.status == 'Open').length;

  int get _progressCount =>
      _tickets.where((ticket) => ticket.status == 'In Progress').length;

  int get _resolvedCount =>
      _tickets.where((ticket) => ticket.status == 'Resolved').length;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Open':
        return const Color(0xFF3488D8);
      case 'In Progress':
        return const Color(0xFFF0A020);
      case 'Resolved':
        return const Color(0xFF16A36A);
      default:
        return AppColors.primary;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE54848);
      case 'Medium':
        return const Color(0xFFF0A020);
      case 'Low':
        return const Color(0xFF16A36A);
      default:
        return AppColors.textSecondary;
    }
  }

  // ---------------------------------------------------------
  // DRAWER NAVIGATION
  // ---------------------------------------------------------

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
    Navigator.pop(context); // Close drawer
    if (route != '/support') {
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

  // ---------------------------------------------------------
  // CREATE TICKET
  // ---------------------------------------------------------

  void _showCreateTicketDialog() {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();

    String category = 'Shipment Issue';
    String priority = 'Medium';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: const Text(
                'Create Support Ticket',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Subject'),
                    TextField(
                      controller: subjectController,
                      decoration: _inputDecoration(
                        'Enter ticket subject',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Category'),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: _inputDecoration('Select category'),
                      items: const [
                        'Shipment Issue',
                        'Tracking',
                        'Address Update',
                        'Technical Issue',
                        'Other',
                      ].map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => category = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Priority'),
                    DropdownButtonFormField<String>(
                      value: priority,
                      decoration: _inputDecoration('Select priority'),
                      items: const ['Low', 'Medium', 'High'].map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => priority = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Description'),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: _inputDecoration(
                        'Describe your issue...',
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (subjectController.text.trim().isEmpty ||
                        descriptionController.text.trim().isEmpty) {
                      return;
                    }

                    setState(() {
                      _tickets.insert(
                        0,
                        SupportTicket(
                          id: 'X10-2026-${(43 + _tickets.length).toString().padLeft(4, '0')}',
                          subject: subjectController.text.trim(),
                          category: category,
                          description: descriptionController.text.trim(),
                          date: 'Nov 20, 2026',
                          status: 'Open',
                          priority: priority,
                          lastMessage: 'Your request has been submitted.',
                        ),
                      );
                      _selectedFilter = 'All';
                    });

                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                        content: Text('Your support ticket has been created.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Submit Ticket'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      subjectController.dispose();
      descriptionController.dispose();
    });
  }

  // ---------------------------------------------------------
  // TICKET DETAILS
  // ---------------------------------------------------------

  void _showTicketDetails(SupportTicket ticket) {
    final replyController = TextEditingController();

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
        return Padding(
          padding: EdgeInsets.fromLTRB(
            22,
            12,
            22,
            MediaQuery.of(sheetContext).viewInsets.bottom + 22,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ticket Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        _statusBadge(ticket.status),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      ticket.id,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ticket.subject,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _detailRow('Category', ticket.category),
                    _detailRow('Priority', ticket.priority),
                    _detailRow('Created', ticket.date),
                    const SizedBox(height: 18),
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ticket.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Latest Update',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        ticket.lastMessage,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Send a Reply',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: replyController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                        'Write your message...',
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (replyController.text.trim().isEmpty) return;

                          setState(() {
                            final index = _tickets.indexOf(ticket);
                            if (index != -1) {
                              _tickets[index] = SupportTicket(
                                id: ticket.id,
                                subject: ticket.subject,
                                category: ticket.category,
                                description: ticket.description,
                                date: ticket.date,
                                status: ticket.status,
                                priority: ticket.priority,
                                lastMessage: replyController.text.trim(),
                              );
                            }
                          });

                          Navigator.pop(sheetContext);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text('Your reply has been added.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.send_rounded, size: 17),
                        label: const Text('Send Reply'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
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
          ),
        );
      },
    ).then((_) => replyController.dispose());
  }

  // ---------------------------------------------------------
  // UI HELPERS
  // ---------------------------------------------------------

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9FB),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EAF0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
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
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8EAF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 17),
            ),
            const SizedBox(height: 12),
            Text(
              count.toString().padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(SupportTicket ticket) {
    return InkWell(
      onTap: () => _showTicketDetails(ticket),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        margin: const EdgeInsets.only(bottom: 13),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFE8EAF0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.subject,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        ticket.id,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _statusBadge(ticket.status),
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                const Icon(
                  Icons.folder_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  ticket.category,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Text(
                  ticket.date,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                ticket.lastMessage,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.flag_rounded,
                  size: 14,
                  color: _priorityColor(ticket.priority),
                ),
                const SizedBox(width: 4),
                Text(
                  '${ticket.priority} Priority',
                  style: TextStyle(
                    color: _priorityColor(ticket.priority),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Text(
                  'View Details',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // MAIN SCREEN
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // Reuse the same drawer used by the Dashboard.
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.82,
        child: DashboardDrawer(
          customerName: 'Soumaya',
          customerEmail: 'soumaya@example.com',
          initials: 'S',
          activeItem: 'Support Center',
          onItemSelected: _handleDrawerNavigation,
          onLogout: _handleLogout,
        ),
      ),

      // Header
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
              'Support Center',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'We are here to help you',
              style: TextStyle(
                color: AppColors.textSecondary,
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
                  color: AppColors.text,
                  size: 25,
                ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
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

      // Main content
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
            setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            children: [
              // Support banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFF15A00),
                      Color(0xFFFF8500),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.17),
                      blurRadius: 18,
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
                            'Need assistance?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 7),
                          const Text(
                            'Create a ticket and our support team will '
                            'help you as soon as possible.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: _showCreateTicketDialog,
                            icon: const Icon(
                              Icons.add_rounded,
                              size: 17,
                            ),
                            label: const Text(
                              'Create Ticket',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 11,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.17),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.headset_mic_rounded,
                        size: 34,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 23),

              const Text(
                'Ticket Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  _buildStatCard(
                    'Open',
                    _openCount,
                    const Color(0xFF3488D8),
                    Icons.mark_email_unread_outlined,
                  ),
                  const SizedBox(width: 9),
                  _buildStatCard(
                    'In Progress',
                    _progressCount,
                    const Color(0xFFF0A020),
                    Icons.pending_actions_rounded,
                  ),
                  const SizedBox(width: 9),
                  _buildStatCard(
                    'Resolved',
                    _resolvedCount,
                    const Color(0xFF16A36A),
                    Icons.check_circle_outline_rounded,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Tickets',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    '${_filteredTickets.length} tickets',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              // Search
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by ticket ID or subject...',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 21,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8EAF0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8EAF0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Filters
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
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        showCheckmark: false,
                        side: BorderSide(
                          color: selected
                              ? AppColors.primary
                              : const Color(0xFFE8EAF0),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 11,
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

              if (_filteredTickets.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: const Color(0xFFE8EAF0),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 42,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No tickets found',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Try another filter or create a new support ticket.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._filteredTickets.map(_buildTicketCard),
            ],
          ),
        ),
      ),

      // Bottom navigation - same five destinations as Dashboard.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
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

          if (index != 3) {
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
