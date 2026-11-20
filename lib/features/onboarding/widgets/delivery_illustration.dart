
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DeliveryIllustration extends StatelessWidget {
  final int index;

  const DeliveryIllustration({
    super.key,
    required this.index,
  });

  static const Color orange = Color(0xFFF15A00);
  static const Color lightOrange = Color(0xFFFF8500);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles
          Container(
            width: 290,
            height: 290,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFE9DC).withOpacity(0.65),
            ),
          ),

          Container(
            width: 225,
            height: 225,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: orange.withOpacity(0.13),
                width: 1.5,
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: 30,
            right: 38,
            child: _floatingDot(13, orange),
          ),

          Positioned(
            bottom: 43,
            left: 38,
            child: _floatingDot(9, lightOrange),
          ),

          Positioned(
            top: 88,
            left: 25,
            child: const Icon(
              Icons.star_rounded,
              color: Color(0xFFFFB34D),
              size: 30,
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.2, 1.2),
              duration: 1800.ms,
            ),
          ),

          // Main illustration
          _buildMainIllustration(),

          // Floating information card
          if (index == 0)
            Positioned(
              top: 45,
              right: 8,
              child: _floatingCard(
                icon: Icons.inventory_2_rounded,
                title: 'Your parcel',
                subtitle: 'Ready to ship',
                color: orange,
              ),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),

          if (index == 1)
            Positioned(
              bottom: 32,
              right: 2,
              child: _floatingCard(
                icon: Icons.local_shipping_rounded,
                title: 'On the way',
                subtitle: 'Fast delivery',
                color: const Color(0xFF16A36A),
              ),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),

          if (index == 2)
            Positioned(
              top: 48,
              right: 0,
              child: _floatingCard(
                icon: Icons.location_on_rounded,
                title: 'Live tracking',
                subtitle: 'Follow your parcel',
                color: orange,
              ),
            ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildMainIllustration() {
    switch (index) {
      case 0:
        return _parcelIllustration();
      case 1:
        return _deliveryIllustration();
      default:
        return _trackingIllustration();
    }
  }

  Widget _parcelIllustration() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: -0.08,
          child: Container(
            width: 165,
            height: 145,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA45E), Color(0xFFE94F00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: orange.withOpacity(0.28),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 69,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 27,
                    color: const Color(0xFFFFC18F).withOpacity(0.75),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC18F).withOpacity(0.55),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Icon(
                    Icons.inventory_2_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          width: 115,
          height: 12,
          decoration: BoxDecoration(
            color: orange.withOpacity(0.13),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ],
    ).animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).moveY(
      begin: -7,
      end: 7,
      duration: 2200.ms,
      curve: Curves.easeInOut,
    );
  }

  Widget _deliveryIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 195,
          height: 125,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: orange.withOpacity(0.13),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
        ),
        Positioned(
          left: 23,
          top: 27,
          child: Container(
            width: 100,
            height: 65,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [orange, lightOrange],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_shipping_rounded,
              color: Colors.white,
              size: 55,
            ),
          ),
        ),
        Positioned(
          right: 18,
          top: 37,
          child: Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE7D9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: orange,
              size: 26,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 30,
          right: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _wheel(),
              _wheel(),
            ],
          ),
        ),
      ],
    ).animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).moveX(
      begin: -7,
      end: 7,
      duration: 2500.ms,
      curve: Curves.easeInOut,
    );
  }

  Widget _trackingIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 170,
          height: 205,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: orange.withOpacity(0.15),
                blurRadius: 35,
                offset: const Offset(0, 15),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          child: Container(
            width: 128,
            height: 9,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          top: 51,
          child: Container(
            width: 115,
            height: 95,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: orange,
              size: 65,
            ),
          ),
        ),
        Positioned(
          bottom: 23,
          child: Row(
            children: List.generate(
              3,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == 0 ? 35 : 25,
                height: 7,
                decoration: BoxDecoration(
                  color: i == 0 ? orange : const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
      ],
    ).animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).moveY(
      begin: -6,
      end: 6,
      duration: 2300.ms,
      curve: Curves.easeInOut,
    );
  }

  Widget _floatingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  color: Color(0xFF20242C),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF858B98),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _floatingDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(reverse: true),
    ).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.3, 1.3),
      duration: 1500.ms,
    );
  }

  Widget _wheel() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: const Color(0xFF292D35),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
      ),
    );
  }
}
