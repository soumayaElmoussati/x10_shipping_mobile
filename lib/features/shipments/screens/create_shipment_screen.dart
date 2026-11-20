
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../dashboard/widgets/dashboard_drawer.dart';
import '../../../shared/widgets/custom_selection_field.dart';

class CreateShipmentScreen extends StatefulWidget {
  const CreateShipmentScreen({super.key});

  @override
  State<CreateShipmentScreen> createState() =>
      _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends State<CreateShipmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _pickupAddressController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _declaredValueController = TextEditingController();
  final _notesController = TextEditingController();

  static const Color _primary = Color(0xFFF15A00);
  static const Color _secondary = Color(0xFFFF8500);
  static const Color _background = Color(0xFFF8F9FB);
  static const Color _dark = Color(0xFF20242C);
  static const Color _muted = Color(0xFF858B98);
  static const Color _border = Color(0xFFE8EAF0);
  static const Color _success = Color(0xFF16A36A);
  static const Color _error = Color(0xFFE54848);

  String _originCountry = 'Saudi Arabia';
  String _originCity = 'Riyadh';
  String _destinationCity = 'Dubai';
  String _parcelType = 'Documents';
  String _deliveryType = 'Standard';

  DateTime? _preferredDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pickupAddressController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _deliveryAddressController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _declaredValueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // NAVIGATION
  // --------------------------------------------------

  void _handleDrawerNavigation(String item) {
    Navigator.of(context).pop();

    const routes = {
      'Dashboard': '/home',
      'My Shipments': '/shipments',
      'Create Shipment': '/create-shipment',
      'Track Shipments': '/shipments',
      'Notifications': '/notifications',
      'My Profile': '/profile',
      'Saved Addresses': '/addresses',
      'Shipment History': '/shipments',
      'Customer Support': '/support',
      'My Support Tickets': '/support',
      'Help Center': '/support',
      'Settings': '/settings',
      'About X10': '/about',
    };

    final route = routes[item];

    if (route == null || route == '/create-shipment') {
      return;
    }

    context.go(route);
  }

  Future<void> _handleLogout() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    if (!mounted) return;

    context.go('/login');
  }

  void _onNavigationTap(int index) {
    HapticFeedback.selectionClick();

    const routes = [
      '/home',
      '/shipments',
      '/create-shipment',
      '/support',
      '/profile',
    ];

    if (index < 0 || index >= routes.length || index == 2) {
      return;
    }

    context.go(routes[index]);
  }

  // --------------------------------------------------
  // COUNTRY AND CITY DATA
  // --------------------------------------------------

  List<String> _citiesForCountry(String country) {
    switch (country) {
      case 'Saudi Arabia':
        return [
          'Riyadh',
          'Jeddah',
          'Dammam',
          'Mecca',
          'Medina',
        ];

      case 'Qatar':
        return [
          'Doha',
          'Al Wakrah',
          'Al Rayyan',
          'Lusail',
        ];

      case 'Oman':
        return [
          'Muscat',
          'Salalah',
          'Sohar',
          'Nizwa',
        ];

      case 'Bahrain':
        return [
          'Manama',
          'Riffa',
          'Muharraq',
          'Hamad Town',
        ];

      case 'Kuwait':
        return [
          'Kuwait City',
          'Hawalli',
          'Salmiya',
          'Farwaniya',
        ];

      default:
        return [
          'Dubai',
          'Abu Dhabi',
          'Sharjah',
          'Ajman',
        ];
    }
  }

  // --------------------------------------------------
  // VALIDATION
  // --------------------------------------------------

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    final number = double.tryParse(value);

    if (number == null || number <= 0) {
      return 'Enter a valid positive number';
    }

    return null;
  }

  String? _optionalNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final number = double.tryParse(value);

    if (number == null || number <= 0) {
      return 'Enter a valid positive number';
    }

    return null;
  }

  // --------------------------------------------------
  // DATE PICKER
  // --------------------------------------------------

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: _preferredDate ??
          now.add(const Duration(days: 1)),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _dark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() => _preferredDate = selected);
    }
  }

  // --------------------------------------------------
  // SUBMIT REQUEST
  // --------------------------------------------------

  Future<void> _submitRequest() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_preferredDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a preferred pickup date.',
          ),
          backgroundColor: _error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Frontend simulation. Backend integration will be added later.
    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: _success.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: _success,
                    size: 43,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Request Submitted!',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your shipment request has been submitted successfully. Our team will review it and update you shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: _muted,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      context.go('/shipments');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: const Text(
                      'View My Shipments',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------
  // MAIN SCREEN
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,

      drawer: DashboardDrawer(
        customerName: 'Soumaya',
        customerEmail: 'soumaya@example.com',
        initials: 'S',
        activeItem: 'Create Shipment',
        onItemSelected: _handleDrawerNavigation,
        onLogout: _handleLogout,
      ),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(
              Icons.menu_rounded,
              color: _dark,
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Request',
              style: TextStyle(
                color: _dark,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Ship something new',
              style: TextStyle(
                color: _muted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/notifications'),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: _dark,
            ),
          ),
          const SizedBox(width: 5),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: _border,
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroCard(),
              const SizedBox(height: 24),

              _buildSectionTitle(
                '01',
                'Shipment Route',
                'Where should your shipment go?',
                Icons.route_rounded,
              ),
              const SizedBox(height: 14),
              _buildRouteSection(),

              const SizedBox(height: 26),

              _buildSectionTitle(
                '02',
                'Recipient Information',
                'Who will receive this shipment?',
                Icons.person_outline_rounded,
              ),
              const SizedBox(height: 14),
              _buildRecipientSection(),

              const SizedBox(height: 26),

              _buildSectionTitle(
                '03',
                'Package Details',
                'Tell us about your package.',
                Icons.inventory_2_outlined,
              ),
              const SizedBox(height: 14),
              _buildPackageSection(),

              const SizedBox(height: 26),

              _buildSectionTitle(
                '04',
                'Delivery Preferences',
                'Choose your preferred service.',
                Icons.local_shipping_outlined,
              ),
              const SizedBox(height: 14),
              _buildDeliverySection(),

              const SizedBox(height: 26),

              _buildSectionTitle(
                '05',
                'Additional Instructions',
                'Anything else we should know?',
                Icons.edit_note_rounded,
              ),
              const SizedBox(height: 14),
              _buildNotesSection(),

              const SizedBox(height: 24),
              _buildNotice(),
              const SizedBox(height: 24),

              _buildSubmitButton(),
              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'By submitting, you agree to our shipping terms and conditions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: _muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // --------------------------------------------------
  // INTRO CARD
  // --------------------------------------------------

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primary, _secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ready to ship?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Complete the details below and let X10 handle your shipment request.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.88),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.17),
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.local_shipping_rounded,
              size: 34,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // SECTION TITLE
  // --------------------------------------------------

  Widget _buildSectionTitle(
    String number,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: _primary.withOpacity(0.09),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: _primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
        Text(
          number,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: _primary.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // ROUTE SECTION
  // --------------------------------------------------

  Widget _buildRouteSection() {
    return _buildCard(
      child: Column(
        children: [
          CustomSelectionField(
            label: 'Origin Country',
            hint: 'Select origin country',
            value: _originCountry,
            leadingIcon: Icons.public_rounded,
            options: const [
              SelectionOption(
                label: 'United Arab Emirates',
                icon: Icons.location_on_outlined,
              ),
              SelectionOption(
                label: 'Saudi Arabia',
                icon: Icons.location_on_outlined,
              ),
              SelectionOption(
                label: 'Qatar',
                icon: Icons.location_on_outlined,
              ),
              SelectionOption(
                label: 'Oman',
                icon: Icons.location_on_outlined,
              ),
              SelectionOption(
                label: 'Bahrain',
                icon: Icons.location_on_outlined,
              ),
              SelectionOption(
                label: 'Kuwait',
                icon: Icons.location_on_outlined,
              ),
            ],
            onChanged: (value) {
              setState(() {
                _originCountry = value;
                _originCity = _citiesForCountry(value).first;
              });
            },
          ),

          const SizedBox(height: 15),

          CustomSelectionField(
            label: 'Origin City',
            hint: 'Select origin city',
            value: _originCity,
            leadingIcon: Icons.location_city_rounded,
            options: _citiesForCountry(_originCountry)
                .map(
                  (city) => SelectionOption(
                    label: city,
                    icon: Icons.location_on_outlined,
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() => _originCity = value);
            },
          ),

          const SizedBox(height: 15),

          _buildTextField(
            label: 'Pickup Address',
            hint: 'Enter complete pickup address',
            controller: _pickupAddressController,
            icon: Icons.home_outlined,
            validator: _requiredValidator,
            maxLines: 2,
          ),

          const SizedBox(height: 18),

          Container(height: 1, color: _border),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                color: _success,
                size: 19,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Destination Country',
                  style: TextStyle(
                    color: _dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _success.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'UAE',
                  style: TextStyle(
                    color: _success,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          CustomSelectionField(
            label: 'Destination City',
            hint: 'Select destination city',
            value: _destinationCity,
            leadingIcon: Icons.location_on_outlined,
            options: const [
              SelectionOption(
                label: 'Dubai',
                icon: Icons.location_city_outlined,
              ),
              SelectionOption(
                label: 'Abu Dhabi',
                icon: Icons.location_city_outlined,
              ),
              SelectionOption(
                label: 'Sharjah',
                icon: Icons.location_city_outlined,
              ),
              SelectionOption(
                label: 'Ajman',
                icon: Icons.location_city_outlined,
              ),
              SelectionOption(
                label: 'Ras Al Khaimah',
                icon: Icons.landscape_outlined,
              ),
              SelectionOption(
                label: 'Fujairah',
                icon: Icons.waves_outlined,
              ),
              SelectionOption(
                label: 'Umm Al Quwain',
                icon: Icons.location_city_outlined,
              ),
            ],
            onChanged: (value) {
              setState(() => _destinationCity = value);
            },
          ),

          const SizedBox(height: 15),

          _buildTextField(
            label: 'Delivery Address',
            hint: 'Enter recipient delivery address',
            controller: _deliveryAddressController,
            icon: Icons.place_outlined,
            validator: _requiredValidator,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // RECIPIENT SECTION
  // --------------------------------------------------

  Widget _buildRecipientSection() {
    return _buildCard(
      child: Column(
        children: [
          _buildTextField(
            label: 'Recipient Full Name',
            hint: 'Enter recipient name',
            controller: _recipientNameController,
            icon: Icons.person_outline_rounded,
            validator: _requiredValidator,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: 'Recipient Phone Number',
            hint: '+971 50 000 0000',
            controller: _recipientPhoneController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: _phoneValidator,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // PACKAGE SECTION
  // --------------------------------------------------

  Widget _buildPackageSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSelectionField(
            label: 'Package Type',
            hint: 'Select package type',
            value: _parcelType,
            leadingIcon: Icons.inventory_2_outlined,
            options: const [
              SelectionOption(
                label: 'Documents',
                subtitle: 'Letters, contracts and paperwork',
                icon: Icons.description_outlined,
              ),
              SelectionOption(
                label: 'Electronics',
                subtitle: 'Phones, computers and accessories',
                icon: Icons.devices_outlined,
              ),
              SelectionOption(
                label: 'Clothing',
                subtitle: 'Clothes, shoes and accessories',
                icon: Icons.checkroom_outlined,
              ),
              SelectionOption(
                label: 'Personal Items',
                subtitle: 'Personal belongings',
                icon: Icons.shopping_bag_outlined,
              ),
              SelectionOption(
                label: 'Food & Gifts',
                subtitle: 'Gifts and permitted food items',
                icon: Icons.card_giftcard_outlined,
              ),
              SelectionOption(
                label: 'Other',
                subtitle: 'Other package categories',
                icon: Icons.category_outlined,
              ),
            ],
            onChanged: (value) {
              setState(() => _parcelType = value);
            },
          ),

          const SizedBox(height: 15),

          _buildTextField(
            label: 'Package Weight (kg)',
            hint: 'e.g. 2.5',
            controller: _weightController,
            icon: Icons.scale_outlined,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            validator: _numberValidator,
          ),

          const SizedBox(height: 17),

          const Text(
            'Package Dimensions (cm)',
            style: TextStyle(
              color: _dark,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildDimensionField(
                  'Length',
                  _lengthController,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _buildDimensionField(
                  'Width',
                  _widthController,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _buildDimensionField(
                  'Height',
                  _heightController,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildTextField(
            label: 'Declared Value (AED)',
            hint: 'e.g. 500',
            controller: _declaredValueController,
            icon: Icons.payments_outlined,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            validator: _numberValidator,
          ),

          const SizedBox(height: 8),

          const Text(
            'Enter the estimated value of the contents for shipment documentation.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDimensionField(
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: _muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          validator: _optionalNumberValidator,
          style: const TextStyle(
            fontSize: 12,
            color: _dark,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: '0',
            suffixText: 'cm',
            suffixStyle: const TextStyle(
              color: _muted,
              fontSize: 9,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 13,
            ),
            filled: true,
            fillColor: _background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: const BorderSide(
                color: _primary,
                width: 1.5,
              ),
            ),
            errorStyle: const TextStyle(fontSize: 9),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // DELIVERY PREFERENCES
  // --------------------------------------------------

  Widget _buildDeliverySection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preferred Delivery Service',
            style: TextStyle(
              color: _dark,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          _buildDeliveryOption(
            title: 'Standard Delivery',
            subtitle: 'Cost-effective delivery option',
            description: 'Regular processing',
            value: 'Standard',
            icon: Icons.local_shipping_outlined,
          ),

          const SizedBox(height: 10),

          _buildDeliveryOption(
            title: 'Express Delivery',
            subtitle: 'Priority shipment request',
            description: 'Faster processing',
            value: 'Express',
            icon: Icons.bolt_rounded,
          ),

          const SizedBox(height: 18),

          const Text(
            'Preferred Pickup Date',
            style: TextStyle(
              color: _dark,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 9),

          InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: _background,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: _border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: _primary,
                    size: 20,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      _preferredDate == null
                          ? 'Select your preferred date'
                          : '${_preferredDate!.day.toString().padLeft(2, '0')}/${_preferredDate!.month.toString().padLeft(2, '0')}/${_preferredDate!.year}',
                      style: TextStyle(
                        color: _preferredDate == null
                            ? _muted
                            : _dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _muted,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'This is your preferred date. Actual collection will be confirmed by X10.',
            style: TextStyle(
              color: _muted,
              fontSize: 10,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption({
    required String title,
    required String subtitle,
    required String description,
    required String value,
    required IconData icon,
  }) {
    final selected = _deliveryType == value;

    return InkWell(
      onTap: () {
        setState(() => _deliveryType = value);
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: selected
              ? _primary.withOpacity(0.055)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _primary : _border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? _primary.withOpacity(0.12)
                    : _background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? _primary : _muted,
                size: 21,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _dark,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: _primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? _primary : _muted,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // ADDITIONAL NOTES
  // --------------------------------------------------

  Widget _buildNotesSection() {
    return _buildCard(
      child: _buildTextField(
        label: 'Special Instructions (Optional)',
        hint: 'Add any special handling instructions or additional information...',
        controller: _notesController,
        icon: Icons.notes_rounded,
        maxLines: 4,
      ),
    );
  }

  // --------------------------------------------------
  // NOTICE
  // --------------------------------------------------

  Widget _buildNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _primary.withOpacity(0.13),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _primary,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your request will be reviewed by the X10 team. Pickup and delivery arrangements will be confirmed after approval.',
              style: TextStyle(
                color: _dark.withOpacity(0.85),
                fontSize: 11,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // SUBMIT BUTTON
  // --------------------------------------------------

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _primary.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 18),
                  SizedBox(width: 10),
                  Text(
                    'Submit Shipment Request',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 17),
                ],
              ),
      ),
    );
  }

  // --------------------------------------------------
  // TEXT FIELD
  // --------------------------------------------------

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _dark,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(
            color: _dark,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFADB2BC),
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                bottom: maxLines > 1 ? 35 : 0,
              ),
              child: Icon(
                icon,
                color: _muted,
                size: 19,
              ),
            ),
            alignLabelWithHint: true,
            filled: true,
            fillColor: _background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _primary,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: _error,
                width: 1.4,
              ),
            ),
            errorStyle: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // COMMON CARD
  // --------------------------------------------------

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.018),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // --------------------------------------------------
  // BOTTOM NAVIGATION
  // --------------------------------------------------

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 9,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.inventory_2_outlined,
                label: 'Shipments',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.add_circle_rounded,
                label: 'Create',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.support_agent_rounded,
                label: 'Support',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final selected = index == 2;

    return Expanded(
      child: InkWell(
        onTap: () => _onNavigationTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? _primary : _muted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: selected ? _primary : _muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
