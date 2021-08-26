import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starter_project/Salon/pages/screens/service_provider.dart';
import 'package:starter_project/core/repositories/service_repository.dart';
import 'package:starter_project/ui_helpers/widgets/image_picker_ui_assets.dart';

import 'package:starter_project/ui_helpers/responsive_state/responsive_state.dart';
import 'package:starter_project/ui_helpers/animation/FadeAnimation.dart';

import '../../../index.dart';

class AddNewService extends StatefulWidget {
  @override
  _AddNewServiceState createState() => _AddNewServiceState();
}

class _AddNewServiceState extends State<AddNewService> {
  // Controllers
  TextEditingController description = TextEditingController();
  TextEditingController nameOfService = TextEditingController();
  TextEditingController price = TextEditingController();

  List<String> _category = ['Hair', 'Makeup', 'Spa'];
  List<String> _isPublished = [
    'Yes',
    'No',
  ];
  String dropdownValue;
  String dropdownValue2;

  File _image;
  bool _track = false;

  final serviceKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ServiceProvider>(context, listen: false);
    final repo = Provider.of<ServiceRepo>(context);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Color(0xff9477cb),
      ),
      body: Form(
        key: serviceKey,
        child: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: Row(
                          children: [
                            Text('Services / Add'),
                          ],
                        ),
                      ),
                    ),
                    ResponsiveState(
                      state: repo.state,
                      busyWidget: CircularProgressIndicator(),
                      idleWidget: FadeAnimation(
                        1.5,
                        TextButton.icon(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xff9477cb)),
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (!serviceKey.currentState.validate()) return;
                            addService(context);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameOfService,
                            validator: (value) => model.validateName(value),
                              decoration: InputDecoration(
                                  labelText: 'Name of Service',
                                  labelStyle:
                                      TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.grey[300],
                                  ))),
                            ),
                            TextFormField(
                              controller: description,
                              validator: (value) => model.validateName(value),
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle:
                                      TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.grey[300],
                                  ))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _image == null
                                ? AddImageButton(
                                    onTap: () async {
                                      _image = await model.getImage();
                                      setState(() {

                                      });
                                    },
                                  )
                                : ImageView(
                                    image: _image,
                                    onTap: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                  ),
                            TextFormField(
                              controller: price,
                              validator: (value) => int.tryParse(value) == null ? 'Enter a valid figure' : null,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Price ',
                                  labelStyle:
                                      TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.grey[300],
                                  ))),
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Text(
                                    'Category',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      hint: Text('Select Category'),
                                      validator: (val)=> val == null ? 'Select a category' : null,
                                      value: dropdownValue,
                                      icon: Icon(Icons.arrow_drop_down),
                                      onChanged: (String value) {
                                        setState(() {
                                          dropdownValue = value;
                                        });
                                      },
                                      items: _category
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addService(context) async {
    final model = Provider.of<ServiceRepo>(context, listen: false);

    bool success = await model.createService(
      service: nameOfService.text, description: description.text,
      price: price.text,
      category: dropdownValue,
      image: _image == null ? null : _image.path
    );
    if (success) {
      Navigator.pop(context);
      Get.snackbar(
        'Success',
        'Service Successfully Created',
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black26,
      );
    }
  }
}
