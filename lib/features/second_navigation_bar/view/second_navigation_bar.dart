import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../second_nav_bar_cubit.dart';

class SecondNavBar extends StatefulWidget {
  const SecondNavBar({Key? key}) : super(key: key);

  @override
  State<SecondNavBar> createState() => _SecondNavBarState();
}

class _SecondNavBarState extends State<SecondNavBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 20),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: (context.watch<SecondNavBarCubit>().state == 0)
                  ? Colors.white.withOpacity(0.25)
                  : Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    context.read<SecondNavBarCubit>().changePage(0);
                  },
                  icon: Icon(
                    Icons.local_offer_rounded,
                    color: Colors.white70,
                  )),
            ),CircleAvatar(
              backgroundColor: (context.watch<SecondNavBarCubit>().state == 1)
                  ? Colors.white.withOpacity(0.25)
                  : Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    context.read<SecondNavBarCubit>().changePage(1);
                  },
                  icon: Icon(
                    Icons.widgets_rounded,
                    color: Colors.white70,
                  )),
            ),
            CircleAvatar(
              backgroundColor: (context.watch<SecondNavBarCubit>().state == 2)
                  ? Colors.white.withOpacity(0.25)
                  : Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    context.read<SecondNavBarCubit>().changePage(2);
                  },
                  icon: Icon(
                    Icons.fastfood_outlined,
                    color: Colors.white70,
                  )),
            ),
            CircleAvatar(
              backgroundColor: (context.watch<SecondNavBarCubit>().state == 3)
                  ? Colors.white.withOpacity(0.25)
                  : Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    context.read<SecondNavBarCubit>().changePage(3);
                  },
                  icon: Icon(
                    Icons.add_card_outlined,
                    color: Colors.white70,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
