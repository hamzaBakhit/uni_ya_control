import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/addition/logic/addition_bloc.dart';
import 'package:uni_ya_control/features/addition/model/addition.dart';
import 'package:uni_ya_control/features/addition/view/edit_addition_screen.dart';
import 'package:uni_ya_control/ui/widgets/loading.dart';

import '../../../constants/texts.dart';
import '../../../ui/widgets/delete_alert.dart';

class AdditionsScreen extends StatelessWidget {
  const AdditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(TextKeys.additions.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,

      ),
      body: BlocBuilder<AdditionsBloc, AdditionsState>(builder: (context, state) {
        return Stack(
          children: [
            ListView(
              children: state.additions
                  .map((e) => Column(
                children: [
                  AdditionItem(addition: e),
                  Divider(),
                ],
              ))
                  .toList(),
            ),
            if(state is AdditionsProcess)const LoadingWidget(),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>EditAdditionScreen()));},
        label: Text(TextKeys.add.tr()),
        icon: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}

class AdditionItem extends StatelessWidget {
  AdditionItem({required this.addition, Key? key}) : super(key: key);
  Addition addition;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(addition.id),
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
      onDismissed: (direction) =>context.read<AdditionsBloc>().add(DeleteAddition(addition.id)),
      background: Container(
        color: Colors.redAccent.withOpacity(0.7),
        alignment: Alignment.center,
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
        ),
      ),
      child: ListTile(
        onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context)=>EditAdditionScreen(addition: addition,)));},

        title: Text(addition.title),
        subtitle: Text('${addition.price.toStringAsFixed(2)} \$'),
        leading: CircleAvatar(
          backgroundColor: Colors.black12,
          radius: 30,
          child: Container(
            margin: EdgeInsets.all(8),
            child: Image.network(
              addition.img,
              errorBuilder: (context, error, stackTrace) => Container(),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
