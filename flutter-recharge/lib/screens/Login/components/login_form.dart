import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasError = false;


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
            controller: email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            textDirection: TextDirection.rtl,
            validator: (value) => value!.isEmpty || !vEmail(value)
                ? S.of(context).invalid_email
                : null,
            onSaved: (email) {},
            
            decoration: InputDecoration(
              hintText: S.of(context).your_email,
              hintStyle : TextStyle(
                  color: Colors.black
                ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person,color:FitnessAppTheme.nearlyDarkBlue),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textDirection: TextDirection.rtl,
              controller: password,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value) =>
                  value!.isEmpty ? S.of(context).invalid_password : null,
              decoration: InputDecoration(
                hintText: S.of(context).your_password,
                hintStyle : TextStyle(
                  color: Colors.black
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock,color: FitnessAppTheme.nearlyDarkBlue,),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: FitnessAppTheme.nearlyDarkBlue),
              onPressed: _isLoading ? null : handleLogin,
              child: Text(
                S.of(context).login.toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  handleLogin() async {

    if (_formKey.currentState!.validate()) {
      print('Form is valid');
      setState(() {
        _isLoading = true;
        
        EasyLoading.show(status: 'جاري التحقق ...',maskType: EasyLoadingMaskType.custom);

      });
      

      var data = {'email': email.text, 'password': password.text};

      try {
var res = await AuthApi().login(data);

      var body = jsonDecode(res.body);

      if (body['status']) {
        var data = AuthApi().getData(body);

        SharedPreferences localeStorage = await SharedPreferences.getInstance();
        // save the token

        localeStorage.setString('token', data['token']);
        localeStorage.setString('user', jsonEncode(data['user']));
        
        localeStorage.setString('transactions', jsonEncode(data['transactions']));
        localeStorage.setString('notifications', jsonEncode(data['notifications']));
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
      }catch(error){
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
}
