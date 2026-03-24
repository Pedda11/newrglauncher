import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/event/widgets/event_category_item.dart';
import '../../../screens/event/widgets/event_item.dart';
import '../../../screens/event/cubit/event_screen_cubit.dart';

class EventScreenContent extends StatelessWidget {
  const EventScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state) {
        return state.maybeWhen(
          initialized: (events) {
            if (events.isNotEmpty) {
              return EventCategoryItem(rgEventListDataList: events);
            } else {
              return const Text('empty');
            }
          },
          orElse: () {
            return const CircularProgressIndicator();
          },
        );
      },
    );
  }
}
