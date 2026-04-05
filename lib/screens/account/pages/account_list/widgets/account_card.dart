import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/account.dart';
import '../../../cubit/account_cubit/account_screen_cubit.dart';
import '../../../cubit/character_cubit/character_data_cubit.dart';

class AccountCard extends StatefulWidget {
  final Account acc;
  final Function()? onTap;
  final Function()? onDoubleTap;

  const AccountCard({
    super.key,
    required this.acc,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  double _progress = 0.0;
  bool _isLaunching = false;

  void _onDoubleTap(AccountScreenCubit screenCubit) async {
    if (_isLaunching) return;

    screenCubit.startGame(widget.acc);

    setState(() {
      _isLaunching = true;
      _progress = 0.0;
    });

    for (int i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _progress = i / 200;
      });
    }

    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      _isLaunching = false;
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenCubit = context.read<AccountScreenCubit>();
    final characterDataCubit = context.read<CharacterDataCubit>();
    return GestureDetector(
      onDoubleTap: () => _onDoubleTap(screenCubit),
      onTap: () => characterDataCubit.getAccountDetails(widget.acc),
      child: Stack(
        children: [
          /// BASE CARD
          Container(
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
                  Expanded(flex: 1, child: Text(widget.acc.accId.toString())),
                  const VerticalDivider(color: Colors.black),
                  Expanded(flex: 8, child: Text(widget.acc.listName)),
                  const VerticalDivider(color: Colors.black),
                  Expanded(flex: 8, child: Text(widget.acc.accountName)),
                  const VerticalDivider(color: Colors.black),
                  Expanded(flex: 8, child: Text(widget.acc.accountRealm)),
                ],
              ),
            ),
          ),

          /// PROGRESS OVERLAY
          if (_isLaunching)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 50),
                    width: MediaQuery.of(context).size.width * _progress,
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
