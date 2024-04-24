import 'dart:developer';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  List<String> items = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
  TextEditingController itemnamecontroller = TextEditingController();
  TextEditingController itempricecontroller = TextEditingController();
  TextEditingController itemdetailcontroller = TextEditingController();
  TextEditingController selectitemcontroller = TextEditingController();
  final picker = ImagePicker();
  File? image;
  Future imagePicker({required ImageSource source}) async {
    final pickedimg = await picker.pickImage(source: source);
    if (pickedimg != null) {
      setState(() {
        image = File(pickedimg.path);
        log("This is img url" + image.toString());
      });
    }
  }

  uploadItem() async {
    if (image != null &&
        itemnamecontroller.text.isNotEmpty &&
        itempricecontroller.text.isNotEmpty &&
        itemdetailcontroller.text.isNotEmpty &&
        selectitemcontroller.text.isNotEmpty) {
      String id = randomAlphaNumeric(10);
      log("This name controller" + itemnamecontroller.text);
      Reference storageRef =
          FirebaseStorage.instance.ref().child("blogImg").child(id);
      final UploadTask uploadTask = storageRef.putFile(image!);
      log("This is the image" + image.toString());
      log("This upload task" + uploadTask.toString());
      var downloadTask = await (await uploadTask).ref.getDownloadURL();

      log("This download task" + downloadTask.toString());
      Map<String, dynamic> add = {
        "Img": downloadTask,
        "Name": itemnamecontroller.text,
        "Price": itempricecontroller.text,
        "Details": itemdetailcontroller.text,
        "Type": selectitemcontroller.text,
      };
      await Database()
          .addFoodDetails(userinfo: add, name: selectitemcontroller.text)
          .then((value) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'On Snap!',
            message: 'SuccessFully Added Item',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      });
      Navigator.pop(context);
    }
  }

  showbottomsheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 150,
              child: Column(children: [
                ListTile(
                  onTap: () async {
                    await imagePicker(source: ImageSource.camera);
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.camera_alt_outlined),
                  title: Text("Camera"),
                ),
                ListTile(
                  onTap: () async {
                    await imagePicker(source: ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.photo),
                  title: Text("Gallery"),
                )
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Food",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the item image",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Center(
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              showbottomsheet();
                            },
                            icon: const Icon(Icons.camera_alt_outlined),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Item Name", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              TextField(
                controller: itemnamecontroller,
                decoration: InputDecoration(
                  labelText: "Enter Item Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Item Price", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              TextField(
                keyboardType: TextInputType.number,
                controller: itempricecontroller,
                decoration: InputDecoration(
                  labelText: "Enter Item Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Item Details", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              TextField(
                maxLines: 6,
                keyboardType: TextInputType.number,
                controller: itemdetailcontroller,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: "Enter Item Price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Select Category", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              DropdownMenu(
                  controller: selectitemcontroller,
                  onSelected: (value) {
                    setState(() {
                      selectitemcontroller.text = value!;
                    });
                  },
                  width: MediaQuery.of(context).size.width / 1.1,
                  label: Text("Select Category"),
                  dropdownMenuEntries:
                      items.map<DropdownMenuEntry<String>>((String value) {
                    log(selectitemcontroller.text);
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList()),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        fixedSize: Size(200, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () {
                      uploadItem();
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
