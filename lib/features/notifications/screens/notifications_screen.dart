import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../dashboard/widgets/dashboard_drawer.dart';
import '../data/notification_dummy_data.dart';
import '../models/app_notification.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_filter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const Color _orange = Color(0xFFF15A00);
  static const Color _dark = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);
  static const Color _background = Color(0xFFF8F9FB);
  static const Color _border = Color(0xFFE8EAF0);

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  late List<AppNotification> _notifications;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();

    _notifications = NotificationDummyData.notifications
        .map((notification) => notification.copyWith())
        .toList();
  }

  int get _unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  List<AppNotification> get _filteredNotifications {
    final result = _notifications.where((notification) {
      switch (_selectedFilter) {
        case 'Unread':
          return !notification.isRead;
        case 'Shipments':
          return notification.type == AppNotificationType.shipment;
        case 'Account':
          return notification.type == AppNotificationType.account;
        case 'All':
        default:
          return true;
      }
    }).toList();

    result.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return result;
  }

  void _markAllAsRead() {
    if (_unreadCount == 0) return;

    setState(() {
      _notifications = _notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();
    });

    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markAsRead(String notificationId) {
    final index = _notifications.indexWhere(
      (notification) => notification.id == notificationId,
    );

    if (index == -1 || _notifications[index].isRead) return;

    setState(() {
      _notifications[index] =
          _notifications[index].copyWith(isRead: true);
    });
  }

  Future<void> _deleteNotification(AppNotification notification) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete notification?',
            style: TextStyle(
              color: _dark,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'This notification will be permanently removed from your list.',
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _notifications.removeWhere(
        (item) => item.id == notification.id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openNotification(AppNotification notification) {
    _markAsRead(notification.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _NotificationDetailsSheet(
          notification: notification,
          onAction: () {
            Navigator.pop(sheetContext);
            _handleNotificationAction(notification);
          },
        );
      },
    );
  }

  void _handleNotificationAction(AppNotification notification) {
    switch (notification.type) {
      case AppNotificationType.shipment:
        final trackingNumber = notification.trackingNumber;

        if (trackingNumber != null && trackingNumber.isNotEmpty) {
          context.go('/tracking/$trackingNumber');
        } else {
          context.go('/shipments');
        }
        break;

      case AppNotificationType.support:
        context.go('/support');
        break;

      case AppNotificationType.account:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account information is up to date.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    }
  }

  String _groupTitle(DateTime date) {
    final now = DateTime.now();

    if (DateUtils.isSameDay(date, now)) {
      return 'TODAY';
    }

    final yesterday = now.subtract(const Duration(days: 1));

    if (DateUtils.isSameDay(date, yesterday)) {
      return 'YESTERDAY';
    }

    return 'EARLIER';
  }

  Widget _buildNotificationList() {
    final notifications = _filteredNotifications;

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    final Map<String, List<AppNotification>> grouped = {};

    for (final notification in notifications) {
      final group = _groupTitle(notification.dateTime);
      grouped.putIfAbsent(group, () => []);
      grouped[group]!.add(notification);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        for (final group in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: 18,
              bottom: 12,
            ),
            child: Row(
              children: [
                Text(
                  group.key,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 1,
                    color: _border,
                  ),
                ),
              ],
            ),
          ),
          for (final notification in group.value) ...[
            NotificationCard(
              notification: notification,
              onTap: () => _openNotification(notification),
              onDelete: () => _deleteNotification(notification),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    String title = 'No notifications yet';
    String description =
        'You are all caught up. New updates will appear here.';

    if (_selectedFilter == 'Unread') {
      title = 'No unread notifications';
      description = 'You have read all your notifications.';
    } else if (_selectedFilter == 'Shipments') {
      title = 'No shipment notifications';
      description = 'Shipment updates will appear here.';
    } else if (_selectedFilter == 'Account') {
      title = 'No account notifications';
      description = 'Account updates will appear here.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0E8),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 42,
                color: _orange,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _dark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _muted,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
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

    if (route != null && route != '/notifications') {
      context.go(route);
    }
  }

  Future<void> _handleLogout() async {
    await _storage.deleteAll();

    if (!mounted) return;

    context.go('/login');
  }

  void _onBottomNavigationTap(int index) {
    HapticFeedback.selectionClick();

    const routes = [
      '/home',
      '/shipments',
      '/create-shipment',
      '/support',
    ];

    if (index >= 0 && index < routes.length) {
      context.go(routes[index]);
    } else if (index == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile page is coming soon.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
          top: BorderSide(color: _border, width: 1),
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
                          color: _muted,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[i].label,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      drawer: DashboardDrawer(
        customerName: 'Soumaya',
        customerEmail: 'soumaya@example.com',
        initials: 'S',
        activeItem: 'Notifications',
        onItemSelected: _handleDrawerNavigation,
        onLogout: _handleLogout,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                color: _dark,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Stay up to date with your shipments',
              style: TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(
                Icons.done_all_rounded,
                size: 17,
              ),
              label: const Text(
                'Read all',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: _orange,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Total',
                        value: '${_notifications.length}',
                        icon: Icons.notifications_none_rounded,
                        color: const Color(0xFF3488D8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Unread',
                        value: '$_unreadCount',
                        icon: Icons.mark_email_unread_outlined,
                        color: _orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                NotificationFilter(
                  selectedFilter: _selectedFilter,
                  unreadCount: _unreadCount,
                  onChanged: (filter) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildNotificationList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: color,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: _dark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationDetailsSheet extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onAction;

  const _NotificationDetailsSheet({
    required this.notification,
    required this.onAction,
  });

  static const Color _orange = Color(0xFFF15A00);
  static const Color _dark = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '${months[date.month - 1]} ${date.day}, ${date.year} at $hour:$minute';
  }

  String get _actionLabel {
    switch (notification.type) {
      case AppNotificationType.shipment:
        return 'View Shipment';
      case AppNotificationType.support:
        return 'Open Support Center';
      case AppNotificationType.account:
        return 'Got it';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        22,
        12,
        22,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
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
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: notification.color.withOpacity(0.11),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.color,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.categoryLabel,
                        style: TextStyle(
                          color: notification.color,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.title,
                        style: const TextStyle(
                          color: _dark,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 23),
            Text(
              notification.message,
              style: const TextStyle(
                color: _muted,
                fontSize: 14,
                height: 1.7,
              ),
            ),
            if (notification.trackingNumber != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      color: _orange,
                      size: 19,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Tracking number',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      notification.trackingNumber!,
                      style: const TextStyle(
                        color: _dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (notification.ticketNumber != null) ...[
              const SizedBox(height: 15),
              Text(
                'Ticket reference: ${notification.ticketNumber}',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: _muted,
                  size: 15,
                ),
                const SizedBox(width: 7),
                Text(
                  _formatDate(notification.dateTime),
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  _actionLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}