import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
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
  TextEditingController quantity =  TextEditingController();final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasError = false;
  double _cost = 0;
  bool _hasCash = true;

void _checkCash() async {
        var user = await GetData().getAuth();
        setState(() {
          _hasCash = user['cash'] + .0 >= _cost;
        });
}
  
  @override
void initState() {
  super.initState();
  quantity.addListener(() {
    final isV = quantity.value.text.isEmpty;
    if(!isV) {
      setState(() {
        _cost = double.parse(quantity.value.text) * defaultAcceleratorToken;
        // validate the cash of the user 
        _checkCash();
      });
    }
    else 
      setState(() {
        _cost = 0;
      });
  });
}

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
              color: _imageFile!=null ? Colors.teal : Colors.red,
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
      key: _formKey,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: _hasError || !_hasCash
                  ? Text(
                      S.of(context).invalid_cash,
                      style: TextStyle(color: Colors.red),
                    )
                  : null),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value!.isEmpty || (value.isNotEmpty && int.parse(value)==0)
                ? S.of(context).invalid_quantity
                : null,
            controller: quantity,
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(FitnessAppTheme.nearlyDarkBlue),
              ),
                  onPressed: !_hasCash || _isLoading ? null : handleAddToken,
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
          S().cost + _cost.toString(),
          style: const TextStyle(color: Colors.pink),
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
  
   handleAddToken() async {
    if(!_hasCash && _imageFile!=null){
      
    if (_formKey.currentState!.validate()) {
      print('Form is valid');

      // here test the cost if is it bigger then the cash of the user
      setState(() {
        _isLoading = true;
      });

      var data = {'count': quantity.text , 'cost' : _cost,'type' : 'point'};

      var res = await AuthApi().addPoint(data,_imageFile);
      var body = res.data;

      if (body['status']) {

        var data = AuthApi().getData(body);
        await AuthApi().updateUser(data);

      } else {
        setState(() {
          _hasError = true;
        });
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      print('Form is invalid');

      setState(() {
        _hasError = true;
      });
    }
    }
  }

}
