import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twodotnulllauncher/screens/event/widgets/event_category_item.dart';
import '../../../screens/event/widgets/event_item.dart';
import '../../../screens/event/cubit/event_screen_cubit.dart';
import '../../../localization/generated/l10n.dart';

class EventScreenContent extends StatelessWidget {
  const EventScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state) {
        return state.maybeWhen(
          initialized: (events) {
            if (events.isNotEmpty) {
              return EventCategoryItem(rgEventListDataList: events);
            } else {
              return Text(locales.eventScreenEmpty);
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
