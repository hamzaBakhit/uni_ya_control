import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/constants/texts.dart';
import 'package:uni_ya_control/features/addition/logic/addition_bloc.dart';
import 'package:uni_ya_control/features/group/logic/group_bloc.dart';
import 'package:uni_ya_control/services/connection.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';

import '../logic/meal_bloc.dart';
import '../model/meal.dart';

class EditMealScreen extends StatefulWidget {
  EditMealScreen({this.meal, Key? key}) : super(key: key);
  Meal? meal;
  late bool isNew;

  @override
  State<EditMealScreen> createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  File? file;
  TextEditingController titleController = TextEditingController(),
      descriptionController = TextEditingController(),
      priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.isNew = false;
    if (widget.meal == null) {
      widget.isNew = true;
      widget.meal =
          Meal(title: '', img: '', price: 0, additions: [], groups: []);
    }
    titleController = TextEditingController(text: widget.meal!.title);
    descriptionController =
        TextEditingController(text: widget.meal!.description);
    priceController =
        TextEditingController(text: widget.meal!.price.toString());
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
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: ListView(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        width: double.maxFinite,
                        child: (file != null)
                            ? Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(file!),
                                      fit: BoxFit.contain),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(4),
                                child: Image.network(
                                  widget.meal!.img,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                          child: Text(
                                    TextKeys.noImage.tr(),
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
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
                              child: Text( TextKeys.pickImage.tr())),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return  TextKeys.emptyTitle.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: titleController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            label: Text( TextKeys.title.tr()),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return  TextKeys.emptyDescription.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 3,
                          decoration: InputDecoration(
                            label: Text(TextKeys.description.tr()),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return TextKeys.emptyPrice.tr();
                            } else if (double.tryParse(value) == null) {
                              return TextKeys.wrongPrice.tr();
                            } else {
                              return null;
                            }
                          },
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text(TextKeys.totalPrice.tr()),
                            suffixText: '\$',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: context
                              .read<GroupsBloc>()
                              .state
                              .groups
                              .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                      selected:
                                          widget.meal!.groups.contains(e.id),
                                      label: Text(e.title),
                                      onSelected: (value) {
                                        setState(() {
                                          (value)
                                              ? widget.meal!.addGroup(e.id)
                                              : widget.meal!.removeGroup(e.id);
                                        });
                                      },
                                    ),
                              ))
                              .toList(),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              //todo: additions
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async {
                    List<String>? additions = await showDialog(
                        context: context,
                        builder: (context) =>
                            AdditionsDialog(additions: widget.meal!.additions));
                    if (additions != null) {
                      widget.meal!.additions = additions;
                    }
                  },
                  child: Text(TextKeys.addAdditions.tr()),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.black),
                    foregroundColor:
                        MaterialStatePropertyAll<Color>(Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: (widget.isNew && file == null)
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            widget.meal!.setPrice(
                                double.parse(priceController.value.text));
                            widget.meal!
                                .setTitle(titleController.value.text.trim());
                            widget.meal!.setDescription(
                                descriptionController.value.text.trim());
                            if (await checkConnection(context)) {
                              if (widget.isNew) {
                                context
                                    .read<MealsBloc>()
                                    .add(AddMeal(widget.meal!, file!));
                              } else {
                                context
                                    .read<MealsBloc>()
                                    .add(UpdateMeal(widget.meal!, file));
                              }
                              Navigator.pop(context);
                            }
                          }
                        },
                  child: Text(TextKeys.save.tr()),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.black),
                    foregroundColor:
                        MaterialStatePropertyAll<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

class AdditionsDialog extends StatefulWidget {
  AdditionsDialog({required this.additions, Key? key}) : super(key: key);
  List<String> additions;

  @override
  State<AdditionsDialog> createState() => _AdditionsDialogState();
}

class _AdditionsDialogState extends State<AdditionsDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AlertDialog(
        title: Text(TextKeys.additions.tr()),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView(
            children: context
                .read<AdditionsBloc>()
                .state
                .additions
                .map(
                  (e) => CheckboxListTile(
                    title: Text(e.title),
                    value: widget.additions.contains(e.id),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          (value)
                              ? widget.additions.add(e.id)
                              : widget.additions.remove(e.id);
                        }
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            child: Text(TextKeys.addAdditions.tr(),
                style: TextStyle(color: Colors.redAccent)),
            onPressed: () => Navigator.pop(context, widget.additions),
          ),
        ],
      ),
    );
  }
}
