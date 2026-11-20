import 'package:flutter/material.dart';

enum AppNotificationType {
  shipment,
  account,
  support,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final AppNotificationType type;
  final DateTime dateTime;
  final bool isRead;
  final IconData icon;
  final Color color;
  final String? trackingNumber;
  final String? ticketNumber;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.dateTime,
    required this.isRead,
    required this.icon,
    required this.color,
    this.trackingNumber,
    this.ticketNumber,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    AppNotificationType? type,
    DateTime? dateTime,
    bool? isRead,
    IconData? icon,
    Color? color,
    String? trackingNumber,
    String? ticketNumber,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      isRead: isRead ?? this.isRead,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      ticketNumber: ticketNumber ?? this.ticketNumber,
    );
  }

  String get categoryLabel {
    switch (type) {
      case AppNotificationType.shipment:
        return 'Shipment';
      case AppNotificationType.account:
        return 'Account';
      case AppNotificationType.support:
        return 'Support';
    }
  }
}