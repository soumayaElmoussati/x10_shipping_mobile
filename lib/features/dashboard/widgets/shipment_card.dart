
import 'package:flutter/material.dart';
import '../data/dashboard_dummy_data.dart';

class ShipmentCard extends StatelessWidget {
  final DashboardShipment shipment;
  final VoidCallback? onTap;

  const ShipmentCard({
    super.key,
    required this.shipment,
    this.onTap,
  });

  static const Color _text = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);
  static const Color _border = Color(0xFFE8EAF0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 43,
                    width: 43,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E9),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: Color(0xFFF15A00),
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shipment.trackingNumber,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: _text,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shipment.date,
                          style: const TextStyle(
                            fontSize: 11,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusBadge(
                    label: shipment.status,
                    color: shipment.statusColor,
                  ),
                ],
              ),

              const SizedBox(height: 19),

              Row(
                children: [
                  Expanded(
                    child: _LocationItem(
                      label: 'EXPÉDITEUR',
                      city: shipment.origin,
                      icon: Icons.radio_button_checked,
                      iconColor: const Color(0xFFF15A00),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.grey.shade400,
                      size: 19,
                    ),
                  ),
                  Expanded(
                    child: _LocationItem(
                      label: 'DESTINATAIRE',
                      city: shipment.destination,
                      icon: Icons.location_on_rounded,
                      iconColor: const Color(0xFF16A36A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Progression',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(shipment.progress * 100).round()}%',
                    style: const TextStyle(
                      color: _text,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 9),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: shipment.progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFF0F1F4),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    shipment.statusColor,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 15,
                    color: _muted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      shipment.carrier,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text(
                    'Voir détails',
                    style: TextStyle(
                      color: Color(0xFFF15A00),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFF15A00),
                    size: 11,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationItem extends StatelessWidget {
  final String label;
  final String city;
  final IconData icon;
  final Color iconColor;

  const _LocationItem({
    required this.label,
    required this.city,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF858B98),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Icon(icon, size: 15, color: iconColor),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                city,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF20242C),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
