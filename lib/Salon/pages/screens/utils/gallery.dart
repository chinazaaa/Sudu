import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:starter_project/core/repositories/profile_repositories.dart';
import 'package:starter_project/ui_helpers/responsive_state/responsive_state.dart';

class AddGallery extends StatefulWidget {
  @override
  _AddGalleryState createState() => _AddGalleryState();
}

class _AddGalleryState extends State<AddGallery> {
  List<File> _images = [];
  final picker = ImagePicker();

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileM = Provider.of<ProfileRepo>(context);
    return Column(
      children: [
        Expanded(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: _images.length + 1,
                itemBuilder: (BuildContext context, index) {
                  return index == _images.length
                      ? Container(
                          child: GestureDetector(
                            onTap: () {
                              chooseImage();
                            },
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 2,
                              radius: Radius.circular(8),
                              dashPattern: [8, 4],
                              child: ClipRRect(
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              image: DecorationImage(
                                  image: FileImage(_images[index]),
                                  fit: BoxFit.cover)),
                        );
                },
                staggeredTileBuilder: (int index) => new StaggeredTile.count(
                    index == 0 ? 2 : 1, index == 0 ? 2 : 1),
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlineButton(
              padding: EdgeInsets.symmetric(horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("CANCEL",
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
            ),
            RaisedButton(
              onPressed: () async {
                if (_images.isEmpty) return;
                bool success = await profileM.updateGallery(_images.map((e) => e.path).toList());
                if (success) {
                  Navigator.pop(context);
                  Get.snackbar(
                    'Success!',
                    'Salon Gallery Updated',
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    snackStyle: SnackStyle.FLOATING,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black26,
                  );
                }
              },
              color: Color(0xff9477cb),
              padding: EdgeInsets.symmetric(horizontal: 50),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ResponsiveState(
                state: profileM.state,
                idleWidget: Text(
                  "SAVE GALLERY",
                  style: TextStyle(
                      fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                ),
                busyWidget: Row(
                  children: [
                    SizedBox(
                        height: 25, width: 25,
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
