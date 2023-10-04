import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uni_ya_control/features/group/logic/group_bloc.dart';
import 'package:uni_ya_control/features/group/model/group.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';

import '../../../constants/texts.dart';
import '../../../services/connection.dart';

class EditGroupScreen extends StatefulWidget {
  EditGroupScreen(
      {this.group, required this.isOffer, this.isNew = false, Key? key})
      : super(key: key);
  Group? group;
  bool isOffer, isNew;

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  File? file;
  TextEditingController controller = TextEditingController();
  late Color color;

  @override
  void initState() {
    if (widget.group == null) {
      widget.group = Group(title: '', img: '', isOffer: widget.isOffer);
      widget.isNew = true;
    }
    controller = TextEditingController(text: widget.group!.title);
    color = widget.group!.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            width: double.maxFinite,
            child: (file != null)
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file!), fit: BoxFit.contain),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(4),
                    child: Image.network(
                      widget.group!.img,
                      errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                            TextKeys.noImage.tr(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: Text(TextKeys.pickImage.tr())),
              if (!widget.group!.isOffer) CircleAvatar(backgroundColor: color),
              if (!widget.group!.isOffer)
                ElevatedButton(
                    onPressed: () async {
                      pickColor(context);
                    },
                    child: Text(TextKeys.pickColor.tr())),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                label: Text(TextKeys.title.tr()),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: (widget.isNew && file == null)
                  ? null
                  : () async {
                      widget.group!.setColor(color.value);
                      widget.group!.setTitle(controller.value.text.trim());
                      if (await checkConnection(context)) {
                        if (widget.isNew) {
                          context
                              .read<GroupsBloc>()
                              .add(AddGroup(widget.group!, file!));
                        } else {
                          context
                              .read<GroupsBloc>()
                              .add(UpdateGroup(widget.group!, file));
                        }
                        Navigator.pop(context);
                      }
                    },
              child: Text(TextKeys.save.tr()),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  pickColor(BuildContext context) {
    Color pickedColor = color;
    showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title:  Text(TextKeys.pickColor.tr()),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: pickedColor,
                onColorChanged: (newColor) {
                  setState(() {
                    pickedColor = newColor;
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child:  Text(TextKeys.save.tr()),
                onPressed: () {
                  setState(() => color = pickedColor);
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child:  Text(TextKeys.cancel.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )),
    );
  }

  pickImage() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() => file = File(result.files.first.path!));
    }
  }
}
