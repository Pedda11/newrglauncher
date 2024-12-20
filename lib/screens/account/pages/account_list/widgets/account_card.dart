
import 'package:flutter/material.dart';

import '../../../../../data/account.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({
    Key? super.key,
    required this.acc,
  });

  final Account acc;

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(widget.acc.accId.toString()),
              ),
              const VerticalDivider(
                color: Colors.black,
              ),
              Expanded(
                flex: 8,
                child: Text(widget.acc.listName),
              ),
              const VerticalDivider(
                color: Colors.black,
              ),
              Expanded(
                flex: 8,
                child: Text(widget.acc.accountName),
              ),
              const VerticalDivider(
                color: Colors.black,
              ),
              Expanded(
                flex: 8,
                child: Text(widget.acc.accountRealm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
