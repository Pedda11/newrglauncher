import 'package:flutter/material.dart';

import '../../../../../data/account.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.acc,
  });

  final Account acc;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Text(acc.accId.toString()),
            ),
            const VerticalDivider(
              color: Colors.black,
            ),
            Expanded(
              flex: 8,
              child: Text(acc.listName),
            ),
            const VerticalDivider(
              color: Colors.black,
            ),
            Expanded(
              flex: 8,
              child: Text(acc.accountName),
            ),
            const VerticalDivider(
              color: Colors.black,
            ),
            Expanded(
              flex: 8,
              child: Text(acc.accountRealm),
            ),
          ],
        ),
      ),
    );
  }
}
