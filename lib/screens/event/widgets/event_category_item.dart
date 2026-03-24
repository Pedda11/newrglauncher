import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/rg_event_list_data.dart';
import '../cubit/event_screen_cubit.dart';
import 'event_item.dart';

class EventCategoryItem extends StatelessWidget {
  final List<RgEventListData> rgEventListDataList;

  const EventCategoryItem({super.key, required this.rgEventListDataList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: rgEventListDataList.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            child: Card(
              elevation: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        context
                            .read<EventScreenCubit>()
                            .toggleExpansion(e.events.first.categoryId);
                      },
                      child: Card(
                          elevation: 1,
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(e.events.first.categoryName),
                          ))),
                  e.isExpanded
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: e.events.length,
                          itemBuilder: (context, index) =>
                              EventItem(rgEventData: e.events[index]),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
