
import 'package:flutter/material.dart';

class DashboardShipment {
  final String trackingNumber;
  final String recipient;
  final String destination;
  final String origin;
  final String carrier;
  final String date;
  final String status;
  final double progress;
  final Color statusColor;
  final IconData icon;

  const DashboardShipment({
    required this.trackingNumber,
    required this.recipient,
    required this.destination,
    required this.origin,
    required this.carrier,
    required this.date,
    required this.status,
    required this.progress,
    required this.statusColor,
    required this.icon,
  });
}

class DashboardDummyData {
  static const int totalShipments = 128;
  static const int inTransit = 12;
  static const int delivered = 108;
  static const int pending = 8;

  static const List<DashboardShipment> recentShipments = [
    DashboardShipment(
      trackingNumber: 'X10-2026-00842',
      recipient: 'Ahmed Al Mansoori',
      destination: 'Dubai, UAE',
      origin: 'Riyadh, Saudi Arabia',
      carrier: 'Aramex',
      date: '19 Nov 2026',
      status: 'In Transit',
      progress: 0.68,
      statusColor: Color(0xFF3488D8),
      icon: Icons.local_shipping_rounded,
    ),
    DashboardShipment(
      trackingNumber: 'X10-2026-00841',
      recipient: 'Sara Al Nuaimi',
      destination: 'Abu Dhabi, UAE',
      origin: 'Doha, Qatar',
      carrier: 'DHL Express',
      date: '18 Nov 2026',
      status: 'Delivered',
      progress: 1.0,
      statusColor: Color(0xFF16A36A),
      icon: Icons.check_circle_rounded,
    ),
    DashboardShipment(
      trackingNumber: 'X10-2026-00840',
      recipient: 'Omar Al Mazrouei',
      destination: 'Sharjah, UAE',
      origin: 'Muscat, Oman',
      carrier: 'FedEx Express',
      date: '18 Nov 2026',
      status: 'Pending',
      progress: 0.15,
      statusColor: Color(0xFFF0A020),
      icon: Icons.schedule_rounded,
    ),
  ];
}
