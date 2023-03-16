import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/navigation_home_screen.dart';
import 'package:flutter/material.dart';
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
            validator: (value) => value!.isEmpty
                ? S.of(context).invalid_name
                : null,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: S.of(context).your_name,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
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
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone),
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
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: password,
            validator: (value) => value!.isEmpty
                ? S.of(context).invalid_password
                : null,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: S.of(context).your_password,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),

          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
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


  handleRegister() async {

    if (_formKey.currentState!.validate()) {
      print('Form is valid');
      setState(() {
        _isLoading = true;
      });

      var data = {'email': email.text, 'password': password.text,'phone' : phone.text,'name' : name.text};


      var res = await AuthApi().register(data);

      var body = jsonDecode(res.body);

      if (body['status']) {
        var data = AuthApi().getData(body);

        SharedPreferences localeStorage = await SharedPreferences.getInstance();
        // save the token

        localeStorage.setString('token', data['token']);
        localeStorage.setString('user', jsonEncode(data['user']));

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


  vEmail(value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }
  vPhone(value){
    return value!.length == 10;
  }
}