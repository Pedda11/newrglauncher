import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../screens/event/cubit/event_screen_cubit.dart';
import '../../../screens/event/widgets/event_screen_content.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventScreenCubit()..initialize(),
      child: const Scaffold(
        body: EventScreenContent(),
      ),
    );
  }
}
