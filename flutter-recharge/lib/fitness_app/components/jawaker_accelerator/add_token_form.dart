import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/navigation_home_screen.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';

class AddTokenForm extends StatelessWidget {
  const AddTokenForm({
    Key? key,
  }) : super(key: key);

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
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: S.of(context).your_id,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person_2),
                ),
              ),
              validator: (value) {
                  if(value == null || value.isEmpty)
                  return 'Please enter valid id';
              },
            ),
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
}
