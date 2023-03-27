import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/list_view/recent_tokens_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/token_package_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/list_view/accelerator_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:best_flutter_ui_templates/fitness_app/common.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';

class AddTokenForm extends StatefulWidget {
  const AddTokenForm(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _AddTokenForm createState() => _AddTokenForm();
}

class _AddTokenForm extends State<AddTokenForm> {
  TextEditingController quantity = TextEditingController();
  TextEditingController id = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasError = false;
  double _cost = 0;
  int _tokens = 0;
  bool _hasCash = true;
  bool _showRecent = false;
  int position = 1;

  List<PackageTokenData> data = [];

  @override
  void initState() {
    super.initState();
    // quantity.addListener(() {
    //   final isV = quantity.value.text.isEmpty;
    //   print(isV);
    //   if(!isV) {
    //     setState(() {
    //       _cost = double.parse(quantity.value.text);
    //       // validate the cash of the user
    //     });
    //     _checkCash();
    //   }
    //   else
    //     setState(() {
    //       _cost = 0;
    //     });
    // });
  }

  void _checkCash() async {
    var user = await GetData().getAuth();
    setState(() {
      _hasCash = (user['cash'] + .0) >= _cost;
    });
  }

  _getItemsList() {
    return List.generate(data.length, (index) {
      PackageTokenData element = data[index];
      String cost = (element.packageData['cost'] * double.parse(element.value))
          .toString();
      String text = 'لقد اخترت ';
      var ncost = 0.0;
      var ttokens = 0;
      data.forEach((element) {
        String cost =
            (element.packageData['cost'] * double.parse(element.value))
                .toString();

        String subtext = 'الحزمة : ' +
            element.packageData['count'].toString() +
            ' الكمية : ' +
            element.value.toString() +
            ' الكلفة : ' +
            cost.substring(0, cost.length > 5 ? 5 : cost.length);
        text = text + '\n' + subtext;
        ncost =
            element.packageData['cost'] * double.parse(element.value) + ncost;
        ttokens =
            element.packageData['count'] * int.parse(element.value) + ttokens;
      });

      setState(() {
        _cost = ncost + .0;
        _tokens = ttokens;
      });

      _checkCash();

      return Container(
        margin: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.withOpacity(0.3),
          // border: Border.all(color: Colors.black)
        ),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(right: 1),
                child: Text(
                  element.packageData['count'].toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(right: 30),
                child: Text(element.value.toString(),
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(right: 30),
                child:
                    Text(cost.substring(0, cost.length > 5 ? 5 : cost.length)),
              )
            ],
          ),
        ),
      );
    });
  }

  _getText() {
    if (data.isEmpty) {
      return 'ادخل الكمية من كل حزمة';
    } else {
      String text = 'لقد اخترت ';
      var ncost = 0.0;
      var ttokens = 0;
      data.forEach((element) {
        String cost =
            (element.packageData['cost'] * double.parse(element.value))
                .toString();

        String subtext = 'الحزمة : ' +
            element.packageData['count'].toString() +
            ' الكمية : ' +
            element.value.toString() +
            ' الكلفة : ' +
            cost.substring(0, cost.length > 5 ? 5 : cost.length);
        text = text + '\n' + subtext;
        ncost =
            element.packageData['cost'] * double.parse(element.value) + ncost;
        ttokens =
            element.packageData['count'] * int.parse(element.value) + ttokens;
      });

      setState(() {
        _cost = ncost + .0;
        _tokens = ttokens;
      });

      return text;
    }
  }

  _getPackages() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Text.rich(TextSpan(children: [
                // WidgetSpan(
                //     child: Icon(
                //   Icons.shop,
                //   size: 18,
                // )),

                TextSpan(
                    text: data.length.toString() + '-',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'الحزم التي تم اختيارها',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ])),
            ),
          ],
        ),
        Container(
          height: 2,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // border: Border.all(color: Colors.black)
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 1),
                  child: Text('الحزمة'),
                ),
                Container(
                  margin: EdgeInsets.only(right: 60),
                  child: Text(' الكمية'),
                ),
                Container(
                  margin: EdgeInsets.only(right: 80),
                  child: Text(' الكلفة'),
                )
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: _getItemsList(),
          ),
        ),
        Container(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(color: FitnessAppTheme.nearlyDarkBlue),
            //       borderRadius: BorderRadius.circular(10)),
            //   child: Padding(
            //     padding: EdgeInsets.all(5),
            //     child: Text(
            //       S.of(context).cost + _cost.toString(),
            //       style: const TextStyle(color: Colors.pink, fontSize: 20),
            //     ),
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: FitnessAppTheme.nearlyDarkBlue),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.money,
                          size: 35,
                          color: FitnessAppTheme.nearlyDarkBlue,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: 'الكلفة',
                            style: const TextStyle(
                                color: Colors.pink, fontSize: 15),
                          )
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: NumberFormat.simpleCurrency(
                                    // decimalDigits: 2,
                                    // locale: 'en_IN',
                                    // symbol: '.'
                                    )
                                .format(_cost),
                            style: const TextStyle(
                                color: Colors.pink, fontSize: 18),
                          )
                        ]))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: FitnessAppTheme.nearlyDarkBlue),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 3, right: 0),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.wallet_outlined,
                          size: 35,
                          color: FitnessAppTheme.nearlyDarkBlue,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: 'تاوكنز',
                            style: const TextStyle(
                                color: Colors.pink, fontSize: 15),
                          )
                        ])),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: Common.formatNumber(_tokens),
                            style: const TextStyle(
                                color: Colors.pink, fontSize: 18),
                          )
                        ]))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  _getPoints() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          height: 12,
          width: 12,
          margin: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              color: index == position
                  ? Colors.amber
                  : FitnessAppTheme.nearlyDarkBlue,
              shape: BoxShape.circle),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showRecent = !_showRecent;
              });
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: ' اخر العمليات ',
                    style: TextStyle(color: Colors.black)),
                WidgetSpan(
                    child: Icon(
                  _showRecent ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                ))
              ]),
            ),
          ),
          _showRecent
              ? RecentTokensListView(
                  mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                          parent: widget.mainScreenAnimation!,
                          curve:
                              Interval(0.8, 1.0, curve: Curves.fastOutSlowIn))),
                  mainScreenAnimationController:
                      widget.mainScreenAnimationController,
                )
              : Container(),

          TokenPackageListView(
            callbackPosition: (p) {
              setState(() {
                position = p;
              });
            },
            callback: (value, id, pdata) {
              PackageTokenData elementt = PackageTokenData(
                  value: value.toString(),
                  packageId: id.toString(),
                  packageData: pdata);
              // get the list without the selected element
              List<PackageTokenData> nData = data
                  .where((element) => element.packageId != elementt.packageId)
                  .toList();
              // update the data
              nData.add(elementt);
              // validate all data
              nData = nData.where((element) => element.value != '').toList();
              // set the data
              setState(() {
                data = nData;
              });

              _checkCash();
            },
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.mainScreenAnimation!,
                    curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController:
                widget.mainScreenAnimationController!,
          ),
          Container(
            height: 10,
          ),
          _getPoints(),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: _hasError || !_hasCash
                  ? Text(
                      S.of(context).invalid_cash,
                      style: TextStyle(color: Colors.red),
                    )
                  : null),

          Column(
            children: [
              Container(
                child: data.isNotEmpty
                    ? _getPackages()
                    : Text('ادخل الكمية من كل حزمة'),
              )
            ],
          ),
          // Text(
          //   S.of(context).cost + _cost.toString(),
          //   style: const TextStyle(color: Colors.pink),
          // ),
          // Text(
          //   'تاوكنز : ' + _tokens.toString(),
          //   style: const TextStyle(color: Colors.pink),
          // ),
          // TextFormField(
          //   autovalidateMode: AutovalidateMode.onUserInteraction,
          //   validator: (value) => value!.isEmpty || (value.isNotEmpty && int.parse(value)==0)
          //       ? S.of(context).invalid_quantity
          //       : null,
          //   keyboardType: TextInputType.number,
          //   controller: quantity,
          //   textInputAction: TextInputAction.next,
          //   cursorColor: kPrimaryColor,
          //   onSaved: (quantity) {},
          //   decoration: InputDecoration(
          //     hintText: S.of(context).your_quantity,
          //     hintStyle: TextStyle(color : Colors.black),
          //     prefixIcon: Padding(
          //       padding: const EdgeInsets.all(defaultPadding),
          //       child: Icon(Icons.numbers,color: FitnessAppTheme.nearlyDarkBlue,),
          //     ),
          //   ),
          // ),
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
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(
                    Icons.person_2,
                    color: FitnessAppTheme.nearlyDarkBlue,
                  ),
                ),
              ),
            ),
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
                S.of(context).confirm.toUpperCase(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
  }

  handleAddToken() async {
    if (_hasCash) {
      if (_formKey.currentState!.validate()) {
        print('Form is valid');

        // here test the cost if is it bigger then the cash of the user

        setState(() {
          _isLoading = true;

          EasyLoading.show(
              status: S().sending_add_tokens,
              maskType: EasyLoadingMaskType.custom);
        });

        var packages = [];

        data.forEach((element) {
          packages.add({'package_id': element.packageId, 'count': element.value});
        });

        var ddata = {
          'account_id': id.text,
          'count': _tokens.toString(),
          'cost': _cost.toString(),
          'packages': packages
        };

        var res = await AuthApi().addToken(ddata);

        var body = jsonDecode(res.body);
        if (body['status']) {
          var data = AuthApi().getData(body);
          await AuthApi().updateUser(data);
          handleSnackBar();
          setState(() {
            _hasError = false;
          });
        } else {
          setState(() {
            _hasError = true;
          });
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
    } else {}
  }
}

class PackageTokenData {
  PackageTokenData({this.value = '', this.packageId = '', this.packageData});

  String value;
  String packageId;
  var packageData;
}
