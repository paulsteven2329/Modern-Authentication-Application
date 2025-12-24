import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';
import '../blocs/theme/theme_event.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: state.isDark 
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                context.read<ThemeBloc>().add(const ThemeToggleRequested());
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  state.isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: state.isDark ? Colors.yellow : Colors.orange,
                  size: 24,
                ),
              ),
            ),
          ),
        )
            .animate()
            .scale(duration: 200.ms)
            .then()
            .shimmer(duration: 1000.ms, delay: 2000.ms);
      },
    );
  }
}