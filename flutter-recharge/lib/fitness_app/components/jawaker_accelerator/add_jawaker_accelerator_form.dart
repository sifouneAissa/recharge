import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddJawakerAcceleratorForm extends StatefulWidget {
  const AddJawakerAcceleratorForm({Key? key}) : super(key: key);

  @override
  _AddJawakerAcceleratorForm createState() => _AddJawakerAcceleratorForm();
}


class _AddJawakerAcceleratorForm extends State<AddJawakerAcceleratorForm> {
  
  final ImagePicker _picker = ImagePicker();

  PickedFile? _imageFile;

 Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        AspectRatio(
           aspectRatio: 1.5, 
          child: Image(image: _imageFile ==null ? 
              AssetImage("assets/fitness_app/account_id.png")
              : FileImage(File(_imageFile!.path)) as ImageProvider,fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).choose_image,
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text(S.of(context).camera),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text(S.of(context).gallery),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (quantity) {},
            decoration: InputDecoration(
              hintText: S.of(context).your_quantity,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.numbers),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: imageProfile(),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                // print('you click the login button');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return NavigationHomeScreen();
                //     },
                //   ),
                // );
              },
              child: Text(
                S().confirm.toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          S().cost,
          style: const TextStyle(color: kPrimaryColor),
        ),
        // GestureDetector(
        //   onTap: () => {

        //   },
        //   child: Text(
        //     login ? "Sign Up" : "Sign In",
        //     style: const TextStyle(
        //       color: kPrimaryColor,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // )
      ],
    ),
        ],
      ),
    );
  }
}
