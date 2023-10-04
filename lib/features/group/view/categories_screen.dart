import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/constants/texts.dart';
import 'package:uni_ya_control/features/group/logic/group_bloc.dart';
import 'package:uni_ya_control/features/group/model/group.dart';
import 'package:uni_ya_control/ui/widgets/delete_alert.dart';
import 'package:uni_ya_control/ui/widgets/loading.dart';

import 'edit_group_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(TextKeys.categories.tr()),
        backgroundColor: Colors.transparent,
        centerTitle: true,

      ),
      body: BlocBuilder<GroupsBloc, GroupsState>(builder: (context, state) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: state.groups
                    .where((element) => !element.isOffer)
                    .map((e) => Column(
                          children: [
                            CategoryItem(group: e),
                            Divider(),
                          ],
                        ))
                    .toList(),
              ),
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
                  builder: (context) => EditGroupScreen(isOffer: false)));
        },
        label: Text(TextKeys.add.tr()),
        icon: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({required this.group, Key? key}) : super(key: key);
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
      onDismissed: (direction) =>context.read<GroupsBloc>().add(DeleteGroup(group.id)),
      background: Container(
        color: Colors.redAccent.withOpacity(0.7),
        alignment: Alignment.center,
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditGroupScreen(
                        isOffer: false,
                        group: group,
                      )));
        },
        title: Text(group.title),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: group.color.withOpacity(0.5),
          child: Container(
            margin: EdgeInsets.all(8),
            child: Image.network(
              group.img,
              errorBuilder: (context, error, stackTrace) => Container(),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
