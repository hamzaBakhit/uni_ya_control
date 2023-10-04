import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya_control/features/addition/logic/addition_bloc.dart';
import 'package:uni_ya_control/services/connection.dart';
import 'package:uni_ya_control/ui/widgets/backgruond.dart';

import '../../../constants/texts.dart';
import '../model/addition.dart';

class EditAdditionScreen extends StatefulWidget {
  EditAdditionScreen({this.addition, Key? key}) : super(key: key);
  Addition? addition;
  late bool isNew;

  @override
  State<EditAdditionScreen> createState() => _EditAdditionScreenState();
}

class _EditAdditionScreenState extends State<EditAdditionScreen> {
  File? file;
  TextEditingController titleController = TextEditingController(),
      priceController = TextEditingController();
  final _formKey=GlobalKey<FormState>();

  @override
  void initState() {
    widget.isNew = false;
    if (widget.addition == null) {
      widget.isNew = true;
      widget.addition = Addition(title: '', img: '', price: 0);
    }
    titleController = TextEditingController(text: widget.addition!.title);
    priceController =
        TextEditingController(text: widget.addition!.price.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.transparent ,
        ),          backgroundColor:Colors.transparent ,

        body: Form(
          key: _formKey,
          child: Column(
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
                          widget.addition!.img,
                          errorBuilder: (context, error, stackTrace) => Center(child:Text('No Image',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if(value!.trim().isEmpty){
                      return TextKeys.emptyTitle.tr();
                    }else {
                      return null;
                    }
                  },
                  controller: titleController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    label: Text(TextKeys.title.tr()),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(validator: (value) {
                  if(value!.trim().isEmpty){
                    return TextKeys.emptyPrice.tr();
                  }else if(double.tryParse(value)==null){
                    return TextKeys.wrongPrice.tr();
                  }else {
                    return null;
                  }
                },
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text(TextKeys.totalPrice.tr()),
                    //edited
                    prefix: Text("\$"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: (widget.isNew&&file==null)?null:() async {
                    if(_formKey.currentState!.validate()){
                      widget.addition!.setPrice(double.parse(priceController.value.text));
                      widget.addition!.setTitle(titleController.value.text.trim());
                      if(await checkConnection(context)){
                        if(widget.isNew){
                          context.read<AdditionsBloc>().add(AddAddition(widget.addition!, file!));
                        }else{
                          context.read<AdditionsBloc>().add(UpdateAddition(widget.addition!, file));
                        }
                        Navigator.pop(context);
                      }

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
