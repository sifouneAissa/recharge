import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/list_view/recent_points_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/list_view/recent_tokens_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddJawakerAcceleratorForm extends StatefulWidget {
  const AddJawakerAcceleratorForm(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.onChangeBody,
      this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;
  final onChangeBody;

  @override
  _AddJawakerAcceleratorForm createState() => _AddJawakerAcceleratorForm();
}

class _AddJawakerAcceleratorForm extends State<AddJawakerAcceleratorForm> {
  final ImagePicker _picker = ImagePicker();

  PickedFile? _imageFile;
  TextEditingController quantity = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  bool _isLoading = false;
  bool _hasError = false;
  double _cost = 0;
  bool _hasCash = true;
  bool _showRecent = false;
  String? selectedPoint;
  var costs = {
      '100%' : defaultAcceleratorToken,
      '200%' : defaultAcceleratorToken * 2,
      '300%' : defaultAcceleratorToken * 3
  };

  void _checkCash() async {
    var user = await GetData().getAuth();

    setState(() {
      _hasCash = user['cash_point'] + .0 >= _cost;
    });
  }

  @override
  void initState() {
    super.initState();
    // quantity.addListener(() {
    //   final isV = quantity.value.text.isEmpty;
    //   if (!isV) {
    //     setState(() {
    //       if(selectedPoint!=null)
    //           _cost = costs[selectedPoint] as double;
    //       // _cost = double.parse(quantity.value.text) * defaultAcceleratorToken;
    //       else _cost = 0;
    //       // quantity.value.text = Common.formatNumber(quantity.value.text);
    //       // validate the cash of the user
    //       _checkCash();
    //     });
    //   } else
    //     setState(() {
    //       _cost = 0;
    //     });
    // });
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Image(
              image: _imageFile == null
                  ? AssetImage("assets/fitness_app/account_id.png")
                  : FileImage(File(_imageFile!.path)) as ImageProvider,
              fit: BoxFit.cover),
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
              color: _imageFile != null ? Colors.teal : Colors.red,
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

  handleSnackBar() {
    final snackBar = SnackBar(
      content: Text(S.of(context).request_success),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    widget.onChangeBody();
  }

  
  handleSelectPackage(data) {
      setState(() {
        selectedPoint = data;
      });

        setState(() {
          
            if(selectedPoint!=null)
                _cost = costs[selectedPoint] as double;
            // _cost = double.parse(quantity.value.text) * defaultAcceleratorToken;
            else _cost = 0;
            // quantity.value.text = Common.formatNumber(quantity.value.text);
            // validate the cash of the user
            _checkCash();
        });

        // setState(() {
        //   _cost = 0;
        // });
  }

  handleSnackBarError() {
    final snackBar = SnackBar(
      content: Text('فشل الاتصال'),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          JawakerAcceleratorListView(
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.mainScreenAnimation!,
                    curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: widget.mainScreenAnimationController,
            onSelectCallback: handleSelectPackage,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: _hasError || !_hasCash
                  ? Text(
                      S.of(context).invalid_cash,
                      style: TextStyle(color: Colors.red),
                    )
                  : null),

          // TextFormField(
          //   autovalidateMode: AutovalidateMode.onUserInteraction,
          //   validator: (value) => value!.isEmpty ||
          //           (value.isNotEmpty && (double.parse(value) + .0) == 0)
          //       ? S.of(context).invalid_quantity
          //       : null,
          //   controller: quantity,
          //   keyboardType: TextInputType.number,
          //   textInputAction: TextInputAction.next,
          //   cursorColor: kPrimaryColor,
          //   onSaved: (quantity) {},
          //   decoration: InputDecoration(
          //     hintText: S.of(context).your_quantity,
          //     hintStyle: TextStyle(color: Colors.black),
          //     prefixIcon: Padding(
          //       padding: const EdgeInsets.all(defaultPadding),
          //       child:
          //           Icon(Icons.numbers, color: FitnessAppTheme.nearlyDarkBlue),
          //     ),
          //   ),
          // ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                value!.isEmpty || (value.isEmpty) ? 'اسم خاطئ' : null,
            controller: name,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (quantity) {},
            decoration: InputDecoration(
              hintText: 'اسم اللاعب ',
              hintStyle: TextStyle(color: Colors.black),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child:
                    Icon(Icons.person, color: FitnessAppTheme.nearlyDarkBlue),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          //   child: imageProfile(),
          // ),
          const SizedBox(height: defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                S().cost + Common.formatNumber(_cost),
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
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(FitnessAppTheme.nearlyDarkBlue),
              ),
              onPressed: !_hasCash || _isLoading ? null : handleAddToken,
              child: Text(
                S().confirm.toUpperCase(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: ' اخر العمليات ',
                  style: TextStyle(color: Colors.black)),
              WidgetSpan(
                  child: Icon(
                Icons.history,
                size: 14,
              ))
            ]),
          ),
          RecentPointsListView(
            parentScrollController: widget.parentScrollController,
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.mainScreenAnimation!,
                    curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: widget.mainScreenAnimationController,
          ),
        ],
      ),
    );
  }

  handleAddToken() async {
    if (_hasCash) {
      if (_formKey.currentState!.validate()) {
        print('Form is valid');

        // here test the cost if is it bigger then the cash of the user
        setState(() {
          _isLoading = true;
          EasyLoading.show(
              status: S().sending_add_jawker,
              maskType: EasyLoadingMaskType.custom);
        });

        var data = {
          'name': name.text,
          'count': selectedPoint.toString(),
          'cost': _cost,
          'type': 'point',
          
        };

        try {
          var res = await AuthApi().addPointWithoutP(data);
          var body = res.data;

          if (body['status']) {
            var data = AuthApi().getData(body);
            await AuthApi().updateUser(data);
            handleSnackBar();
          } else {
            print(body);
            setState(() {
              _hasError = false;
            });
          }
        } catch (error) {
          handleSnackBarError();
        }

        setState(() {
          _isLoading = false;
        });
        EasyLoading.dismiss();
      } else {
        print('Form is invalid');

        setState(() {
          _hasError = false;
        });
      }
    }
  }
}
