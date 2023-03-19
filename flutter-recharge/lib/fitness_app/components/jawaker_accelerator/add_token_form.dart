import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/navigation_home_screen.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';

class AddTokenForm extends StatefulWidget {
  const AddTokenForm({
    Key? key,
  }) : super(key: key);


  @override
  _AddTokenForm createState() => _AddTokenForm();

  }

class _AddTokenForm extends State<AddTokenForm> {
  
  TextEditingController quantity =  TextEditingController();
  TextEditingController id = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasError = false;
  double _cost = 0;
  bool _hasCash = true;

  @override
void initState() {
  super.initState();
  quantity.addListener(() {
    final isV = quantity.value.text.isEmpty;
    if(!isV) {
      setState(() {
        _cost = double.parse(quantity.value.text);
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

void _checkCash() async {
        var user = await GetData().getAuth();
        setState(() {
          _hasCash = user['cash'] + .0 >= _cost;
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
            keyboardType: TextInputType.number,
            controller: quantity,
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
            child: TextFormField(
              controller: id,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value!.isEmpty ? S.of(context).invalid_id : null,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: S.of(context).your_id,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person_2),
                ),
              ),
            ),
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
                S.of(context).confirm.toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          S.of(context).cost + _cost.toString(),
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
    if(!_hasCash){
      
    if (_formKey.currentState!.validate()) {
      print('Form is valid');

      // here test the cost if is it bigger then the cash of the user

      setState(() {
        _isLoading = true;
      });

      var data = {'account_id': id.text, 'count': quantity.text , 'cost' : _cost};

      var res = await AuthApi().addToken(data);

      var body = jsonDecode(res.body);

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
