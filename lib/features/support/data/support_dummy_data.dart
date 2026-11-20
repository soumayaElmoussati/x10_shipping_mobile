
import '../models/support_ticket.dart';

class SupportDummyData {
  static const List<SupportTicket> tickets = [
    SupportTicket(
      id: 'X10-2026-00124',
      subject: 'Shipment delivery delay',
      category: 'Delivery Issue',
      description:
          'My shipment has not been delivered within the expected delivery time. '
          'I would like to know its current status.',
      date: 'Nov 18, 2026',
      lastUpdate: '2 hours ago',
      status: TicketStatus.inProgress,
      priority: TicketPriority.high,
      replies: 3,
    ),
    SupportTicket(
      id: 'X10-2026-00118',
      subject: 'Incorrect tracking information',
      category: 'Tracking Issue',
      description:
          'The tracking information does not seem to be updating correctly.',
      date: 'Nov 16, 2026',
      lastUpdate: 'Yesterday',
      status: TicketStatus.open,
      priority: TicketPriority.medium,
      replies: 1,
    ),
    SupportTicket(
      id: 'X10-2026-00102',
      subject: 'Request for delivery confirmation',
      category: 'General Inquiry',
      description:
          'I need confirmation that my shipment was successfully delivered.',
      date: 'Nov 12, 2026',
      lastUpdate: 'Nov 14, 2026',
      status: TicketStatus.resolved,
      priority: TicketPriority.low,
      replies: 4,
    ),
  ];

  static const List<Map<String, String>> faqs = [
    {
      'question': 'How can I create a shipment request?',
      'answer':
          'Open the Create Shipment section, enter your sender and recipient '
          'details, add the package information and submit your request. '
          'Our team will review it and assign a suitable delivery partner.',
    },
    {
      'question': 'How can I track my shipment?',
      'answer':
          'Go to My Shipments and select the shipment you want to track. '
          'You will find the latest available tracking events and delivery status.',
    },
    {
      'question': 'Why is my shipment request still pending?',
      'answer':
          'Your request may be waiting for review or carrier assignment. '
          'Our team will update its status once the request has been processed.',
    },
    {
      'question': 'Can I change my shipment details?',
      'answer':
          'Some shipment details can be updated before the request is processed. '
          'Please contact our support team and include your shipment reference.',
    },
    {
      'question': 'What should I do if my package is delayed?',
      'answer':
          'Check the latest tracking events first. If there is no new update, '
          'create a support ticket and provide your tracking number.',
    },
    {
      'question': 'How can I contact customer support?',
      'answer':
          'You can create a support ticket directly from this page. '
          'Our support team will review your request and respond to you.',
    },
  ];
}
