
import 'package:flutter/material.dart';

import '../models/tracking_event.dart';

class TrackingTimeline extends StatelessWidget {
  final List<TrackingEvent> events;

  const TrackingTimeline({
    super.key,
    required this.events,
  });

  static const Color _primary = Color(0xFFF15A00);
  static const Color _dark = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);
  static const Color _border = Color(0xFFE8EAF0);
  static const Color _success = Color(0xFF16A36A);

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December',
    ];

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${months[date.month - 1]} ${date.day}, ${date.year} · $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'No tracking events available.',
          style: TextStyle(color: _muted, fontSize: 12),
        ),
      );
    }

    return Column(
      children: List.generate(events.length, (index) {
        final event = events[index];
        final isLast = index == events.length - 1;

        final Color eventColor = event.isCompleted
            ? (event.isCurrent ? _primary : _success)
            : const Color(0xFFD4D8E0);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: event.isCompleted
                            ? eventColor.withOpacity(0.11)
                            : const Color(0xFFF4F5F7),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: event.isCurrent
                              ? _primary
                              : event.isCompleted
                                  ? eventColor.withOpacity(0.35)
                                  : _border,
                          width: event.isCurrent ? 1.5 : 1,
                        ),
                      ),
                      child: Icon(
                        event.icon,
                        size: 17,
                        color: eventColor,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: event.isCompleted
                              ? _success.withOpacity(0.35)
                              : _border,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : 23,
                    top: 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: TextStyle(
                                color: event.isCompleted
                                    ? _dark
                                    : _muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (event.isCurrent)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _primary.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'CURRENT',
                                style: TextStyle(
                                  color: _primary,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(
                        event.description,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 10,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: _muted,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(
                        _formatDate(event.dateTime),
                        style: TextStyle(
                          color: event.isCompleted
                              ? _dark.withOpacity(0.65)
                              : _muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
