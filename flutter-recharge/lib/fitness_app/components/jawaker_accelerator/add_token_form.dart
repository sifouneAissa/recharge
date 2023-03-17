import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: _hasError
                  ? Text(
                      S.of(context).invalid_email_password,
                      style: TextStyle(color: Colors.red),
                    )
                  : null),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value!.isEmpty
                ? S.of(context).invalid_email
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value!.isEmpty ? S.of(context).invalid_password : null,
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
              onPressed: _isLoading ? null : handleAddToken,
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
          S.of(context).cost,
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

   handleAddToken() async {
    if (_formKey.currentState!.validate()) {
      print('Form is valid');

      setState(() {
        _isLoading = true;
      });

      var data = {'account_id': id.text, 'count': quantity.text , 'cost' : 0};

      var res = await AuthApi().addToken(data);

      var body = jsonDecode(res.body);

      if (body['status']) {

        var data = AuthApi().getData(body);
        await AuthApi().updateUser(data);

      } else {
        print(body);
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
