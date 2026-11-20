
import 'package:flutter/material.dart';

enum TicketStatus {
  open,
  inProgress,
  resolved,
}

enum TicketPriority {
  low,
  medium,
  high,
}

class SupportTicket {
  final String id;
  final String subject;
  final String category;
  final String description;
  final String date;
  final String lastUpdate;
  final TicketStatus status;
  final TicketPriority priority;
  final int replies;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.category,
    required this.description,
    required this.date,
    required this.lastUpdate,
    required this.status,
    required this.priority,
    required this.replies,
  });

  SupportTicket copyWith({
    String? id,
    String? subject,
    String? category,
    String? description,
    String? date,
    String? lastUpdate,
    TicketStatus? status,
    TicketPriority? priority,
    int? replies,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      replies: replies ?? this.replies,
    );
  }
}

extension TicketStatusStyle on TicketStatus {
  String get label {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.open:
        return const Color(0xFFF0A020);
      case TicketStatus.inProgress:
        return const Color(0xFF3488D8);
      case TicketStatus.resolved:
        return const Color(0xFF16A36A);
    }
  }

  Color get background {
    return color.withOpacity(0.10);
  }

  IconData get icon {
    switch (this) {
      case TicketStatus.open:
        return Icons.schedule_rounded;
      case TicketStatus.inProgress:
        return Icons.sync_rounded;
      case TicketStatus.resolved:
        return Icons.check_circle_outline_rounded;
    }
  }
}

extension TicketPriorityStyle on TicketPriority {
  String get label {
    switch (this) {
      case TicketPriority.low:
        return 'Low';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TicketPriority.low:
        return const Color(0xFF16A36A);
      case TicketPriority.medium:
        return const Color(0xFFF0A020);
      case TicketPriority.high:
        return const Color(0xFFE54848);
    }
  }
}
