
import 'package:flutter/material.dart';

class TrackingEvent {
  final String title;
  final String description;
  final String location;
  final DateTime dateTime;
  final bool isCompleted;
  final bool isCurrent;
  final IconData icon;

  const TrackingEvent({
    required this.title,
    required this.description,
    required this.location,
    required this.dateTime,
    required this.isCompleted,
    required this.isCurrent,
    required this.icon,
  });
}

class TrackingShipment {
  final String trackingNumber;
  final String recipientName;
  final String recipientPhone;
  final String originCity;
  final String originCountry;
  final String destinationCity;
  final String destinationCountry;
  final String carrierName;
  final String carrierTrackingNumber;
  final String packageType;
  final String weight;
  final String deliveryType;
  final String status;
  final DateTime estimatedDelivery;
  final List<TrackingEvent> events;

  const TrackingShipment({
    required this.trackingNumber,
    required this.recipientName,
    required this.recipientPhone,
    required this.originCity,
    required this.originCountry,
    required this.destinationCity,
    required this.destinationCountry,
    required this.carrierName,
    required this.carrierTrackingNumber,
    required this.packageType,
    required this.weight,
    required this.deliveryType,
    required this.status,
    required this.estimatedDelivery,
    required this.events,
  });
}
