import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/group/model/group.dart';
import 'package:uni_ya_control/ui/widgets/loading.dart';

import '../../../constants/texts.dart';
import '../../../ui/widgets/delete_alert.dart';
import '../logic/group_bloc.dart';
import 'edit_group_screen.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(TextKeys.offers.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,

      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(builder: (context, state) {
        return Stack(
          children: [
            ListView(
              children: state.groups
                  .where((element) => element.isOffer).skipWhile((value) => value.id=='popular')
                  .map((e) => Column(
                        children: [
                          OfferItem(group: e),
                          Divider(),
                        ],
                      ))
                  .toList(),
            ),
            if (state is GroupsProcess)
             LoadingWidget(),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditGroupScreen(isOffer: true)));
        },
        label: Text(TextKeys.add.tr()),
        icon: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class OfferItem extends StatelessWidget {
  OfferItem({required this.group, Key? key}) : super(key: key);
  Group group;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(group.id),
      confirmDismiss: (direction) async {
        return await showDialog(
            context: context,
            builder: (context) => DeleteAlert(
                  title: TextKeys.areYouSure.tr(),
                  actionTitle: TextKeys.delete.tr(),
                  description: TextKeys.deleteDialogDescription.tr(),
                  actionColor: Colors.redAccent,
                ));
      },
      onDismissed: (direction) =>
          context.read<GroupsBloc>().add(DeleteGroup(group.id)),
      background: Container(
        color: Colors.redAccent.withOpacity(0.7),
        alignment: Alignment.center,
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: MediaQuery.of(context).size.height * .10,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditGroupScreen(
                        isOffer: false,
                        group: group,
                      )));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 5,
          semanticContainer: true,
          child: Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(group.img), fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      group.title,
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
