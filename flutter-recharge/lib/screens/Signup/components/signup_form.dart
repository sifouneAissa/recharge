import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpForm createState() => _SignUpForm();
}

class _SignUpForm extends State<SignUpForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();
  bool _isLoading = false;
  bool _hasError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                      S.of(context).email_taken,
                      style: TextStyle(color: Colors.red),
                    )
                  : null),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: name,
            validator: (value) =>
                value!.isEmpty ? S.of(context).invalid_name : null,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: S.of(context).your_name,
              hintStyle: TextStyle(color: Colors.black),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child:
                    Icon(Icons.person, color: FitnessAppTheme.nearlyDarkBlue),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: phone,
              validator: (value) => value!.isEmpty || !vPhone(value)
                  ? S.of(context).invalid_phone
                  : null,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: InputDecoration(
                hintText: S.of(context).your_phone,
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child:
                      Icon(Icons.phone, color: FitnessAppTheme.nearlyDarkBlue),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: email,
              validator: (value) => value!.isEmpty || !vEmail(value)
                  ? S.of(context).invalid_email
                  : null,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: InputDecoration(
                hintText: S.of(context).your_email,
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child:
                      Icon(Icons.email, color: FitnessAppTheme.nearlyDarkBlue),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: password,
              validator: (value) =>
                  value!.isEmpty ? S.of(context).invalid_password : null,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: S.of(context).your_password,
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child:
                      Icon(Icons.lock, color: FitnessAppTheme.nearlyDarkBlue),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: FitnessAppTheme.nearlyDarkBlue),
            onPressed: _isLoading ? null : handleRegister,
            child: Text(S.of(context).sign_up.toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
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

  handleRegister() async {
    if (_formKey.currentState!.validate()) {
      print('Form is valid');
      setState(() {
        _isLoading = true;
        EasyLoading.show(
            status: 'جاري انشاء الحساب ...',
            maskType: EasyLoadingMaskType.custom);
      });

      var data = {
        'email': email.text,
        'password': password.text,
        'phone': phone.text,
        'name': name.text
      };

      try {
        var res = await AuthApi().register(data);

        var body = jsonDecode(res.body);

        if (body['status']) {
          var data = AuthApi().getData(body);

          SharedPreferences localeStorage =
              await SharedPreferences.getInstance();
          // save the token

          localeStorage.setString('token', data['token']);
          localeStorage.setString('user', jsonEncode(data['user']));
          localeStorage.setString(
              'transactions', jsonEncode(data['transactions']));
          localeStorage.setString(
              'notifications', jsonEncode(data['notifications']));
          localeStorage.setString('months', jsonEncode(data['months']));
          localeStorage.setString('diffs', jsonEncode(data['diffs']));

          var user = localeStorage.getString('user');
          var token = localeStorage.getString('token');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NavigationHomeScreen();
              },
            ),
          );
        } else {
          setState(() {
            _hasError = true;
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
        _hasError = true;
      });
    }
  }

  vEmail(value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  vPhone(value) {
    return value!.length == 10;
  }
}
