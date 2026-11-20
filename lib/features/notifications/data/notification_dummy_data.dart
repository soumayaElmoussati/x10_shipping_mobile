import 'package:flutter/material.dart';

import '../models/app_notification.dart';

class NotificationDummyData {
  static List<AppNotification> get notifications {
    final now = DateTime.now();

    return [
      AppNotification(
        id: '1',
        title: 'Shipment is on its way',
        message:
            'Your shipment X10-2026-00842 has been picked up by Aramex and is now in transit. You can follow its progress using the tracking details.',
        type: AppNotificationType.shipment,
        dateTime: now.subtract(const Duration(minutes: 15)),
        isRead: false,
        icon: Icons.local_shipping_outlined,
        color: const Color(0xFF3488D8),
        trackingNumber: 'X10-2026-00842',
      ),
      AppNotification(
        id: '2',
        title: 'Shipment request approved',
        message:
            'Your shipment request X10-2026-00841 has been reviewed and approved. DHL Express has been assigned to handle your shipment.',
        type: AppNotificationType.shipment,
        dateTime: now.subtract(const Duration(hours: 2)),
        isRead: false,
        icon: Icons.check_circle_outline,
        color: const Color(0xFF16A36A),
        trackingNumber: 'X10-2026-00841',
      ),
      AppNotification(
        id: '3',
        title: 'Support ticket updated',
        message:
            'Our support team has replied to your request regarding a delivery question. Open your support center to review the latest update.',
        type: AppNotificationType.support,
        dateTime: now.subtract(const Duration(hours: 5)),
        isRead: false,
        icon: Icons.support_agent_outlined,
        color: const Color(0xFF8B65C7),
        ticketNumber: 'TKT-2026-0018',
      ),
      AppNotification(
        id: '4',
        title: 'Shipment delivered successfully',
        message:
            'Your shipment X10-2026-00840 has been marked as delivered. Thank you for choosing X10 Shipping.',
        type: AppNotificationType.shipment,
        dateTime: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: true,
        icon: Icons.inventory_2_outlined,
        color: const Color(0xFF16A36A),
        trackingNumber: 'X10-2026-00840',
      ),
      AppNotification(
        id: '5',
        title: 'Pickup date confirmed',
        message:
            'The pickup date for shipment X10-2026-00839 has been confirmed. You can view the shipment details in your shipments section.',
        type: AppNotificationType.shipment,
        dateTime: now.subtract(const Duration(days: 1, hours: 5)),
        isRead: true,
        icon: Icons.calendar_month_outlined,
        color: const Color(0xFFF0A020),
        trackingNumber: 'X10-2026-00839',
      ),
      AppNotification(
        id: '6',
        title: 'Welcome to X10 Shipping',
        message:
            'Your customer account is ready. You can now create shipment requests, track deliveries and contact our support team directly from the app.',
        type: AppNotificationType.account,
        dateTime: now.subtract(const Duration(days: 2)),
        isRead: true,
        icon: Icons.person_outline,
        color: const Color(0xFF3488D8),
      ),
      AppNotification(
        id: '7',
        title: 'Shipment delivery update',
        message:
            'There is an update concerning shipment X10-2026-00838. Please check the tracking timeline for the latest delivery information.',
        type: AppNotificationType.shipment,
        dateTime: now.subtract(const Duration(days: 3)),
        isRead: true,
        icon: Icons.notifications_active_outlined,
        color: const Color(0xFFF0A020),
        trackingNumber: 'X10-2026-00838',
      ),
      AppNotification(
        id: '8',
        title: 'Account information updated',
        message:
            'Your account information was successfully updated. If you did not make this change, please contact our support team.',
        type: AppNotificationType.account,
        dateTime: now.subtract(const Duration(days: 5)),
        isRead: true,
        icon: Icons.security_outlined,
        color: const Color(0xFF8B65C7),
      ),
    ];
  }
}