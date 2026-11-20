
import 'package:flutter/material.dart';

import '../models/tracking_event.dart';

class TrackingStatusCard extends StatelessWidget {
  final TrackingShipment shipment;

  const TrackingStatusCard({
    super.key,
    required this.shipment,
  });

  static const Color _primary = Color(0xFFF15A00);
  static const Color _dark = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);
  static const Color _success = Color(0xFF16A36A);
  static const Color _warning = Color(0xFFF0A020);
  static const Color _border = Color(0xFFE8EAF0);

  Color get _statusColor {
    switch (shipment.status.toLowerCase()) {
      case 'delivered':
        return _success;
      case 'in transit':
      case 'out for delivery':
        return const Color(0xFF3488D8);
      case 'pending':
      case 'approved':
        return _warning;
      case 'cancelled':
        return const Color(0xFFE54848);
      default:
        return _primary;
    }
  }

  IconData get _statusIcon {
    switch (shipment.status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'in transit':
        return Icons.local_shipping_rounded;
      case 'out for delivery':
        return Icons.delivery_dining_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.access_time_filled_rounded;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TRACKING NUMBER',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shipment.trackingNumber,
                      style: const TextStyle(
                        color: _dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tracking number copied.'),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.copy_rounded,
                  size: 18,
                  color: _muted,
                ),
                tooltip: 'Copy tracking number',
              ),
            ],
          ),

          const SizedBox(height: 17),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.075),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Icon(
                  _statusIcon,
                  color: _statusColor,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CURRENT STATUS',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        shipment.status,
                        style: TextStyle(
                          color: _statusColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    shipment.deliveryType,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 19),

          Row(
            children: [
              Expanded(
                child: _buildLocation(
                  label: 'ORIGIN',
                  city: shipment.originCity,
                  country: shipment.originCountry,
                  icon: Icons.radio_button_checked_rounded,
                  color: _primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: _muted.withOpacity(0.6),
                  size: 20,
                ),
              ),
              Expanded(
                child: _buildLocation(
                  label: 'DESTINATION',
                  city: shipment.destinationCity,
                  country: shipment.destinationCountry,
                  icon: Icons.location_on_rounded,
                  color: _success,
                  alignEnd: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(height: 1, color: _border),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.event_available_outlined,
                color: _primary,
                size: 19,
              ),
              const SizedBox(width: 9),
              const Expanded(
                child: Text(
                  'Estimated Delivery',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                shipment.status.toLowerCase() == 'delivered'
                    ? 'Delivered'
                    : _formatDate(shipment.estimatedDelivery),
                style: const TextStyle(
                  color: _dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocation({
    required String label,
    required String city,
    required String country,
    required IconData icon,
    required Color color,
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: alignEnd
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!alignEnd)
              Icon(icon, color: color, size: 16),
            if (!alignEnd) const SizedBox(width: 5),
            Flexible(
              child: Text(
                city,
                textAlign: alignEnd ? TextAlign.end : TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (alignEnd) const SizedBox(width: 5),
            if (alignEnd)
              Icon(icon, color: color, size: 16),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          country,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _muted,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
