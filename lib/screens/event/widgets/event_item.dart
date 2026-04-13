import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/rg_event_data.dart';

class EventItem extends StatelessWidget {
  final RgEventData rgEventData;

  const EventItem({super.key, required this.rgEventData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GestureDetector(
        onTap: () async {
          if (rgEventData.detailsUrl.isNotEmpty) {
            if (await canLaunchUrl(Uri.parse(rgEventData.detailsUrl))) {
              await launchUrl(Uri.parse(rgEventData.detailsUrl));
            } else {
              throw 'Could not launch ${Uri.parse(rgEventData.detailsUrl)}';
            }
          }
        },
        child: Card(
          elevation: 1.0,
          color: rgEventData.eventColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: Row(
              children: [
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      rgEventData.iconUrl,
                      height: 20,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Expanded(flex: 3, child: Text(rgEventData.name)),
                Expanded(flex: 3, child: Text(rgEventData.formattedDateRange)),
                Expanded(flex: 1, child: Text(rgEventData.categoryName))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
