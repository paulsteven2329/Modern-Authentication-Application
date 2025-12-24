import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FloatingElements extends StatelessWidget {
  const FloatingElements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Stack(
      children: [
        // Floating icon 1
        Positioned(
          left: size.width * 0.1,
          top: size.height * 0.2,
          child: _buildFloatingIcon(Icons.star, 0),
        ),
        
        // Floating icon 2
        Positioned(
          right: size.width * 0.15,
          top: size.height * 0.15,
          child: _buildFloatingIcon(Icons.security, 1000),
        ),
        
        // Floating icon 3
        Positioned(
          left: size.width * 0.15,
          bottom: size.height * 0.25,
          child: _buildFloatingIcon(Icons.flash_on, 2000),
        ),
        
        // Floating icon 4
        Positioned(
          right: size.width * 0.1,
          bottom: size.height * 0.2,
          child: _buildFloatingIcon(Icons.verified, 3000),
        ),
      ],
    );
  }

  Widget _buildFloatingIcon(IconData icon, int delay) {
    return Icon(
      icon,
      size: 24,
      color: Colors.white.withOpacity(0.1),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .fadeIn(duration: 2000.ms, delay: delay.ms)
        .then(delay: 2000.ms)
        .fadeOut(duration: 2000.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
          duration: 4000.ms,
        )
        .rotate(
          begin: 0,
          end: 2,
          duration: 8000.ms,
        );
  }
}