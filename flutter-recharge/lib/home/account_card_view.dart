import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';

class AccountCardView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const AccountCardView({Key? key, this.animationController, this.animation})
      : super(key: key);


  @override
  _AccountCardView createState() => _AccountCardView();

  }

class _AccountCardView extends State<AccountCardView> {
  var user;

   @override
  void initState() {
    _getUser();
    super.initState();
  }

  _getUser() async {
      var auth = await GetData().getAuth();
      setState(() {
        user = auth;
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4, bottom: 8, top: 16),
                            child: Text(
                              S.of(context).balance,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: FitnessAppTheme.darkText),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Text(
                                      user!=null ? user['cash'].toString() : '0',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 32,
                                        color: Color.fromARGB(255, 4, 4, 5),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 8, bottom: 8),
                                  //   child: Text(
                                  //     'Ibs',
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //       fontFamily: FitnessAppTheme.fontName,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: 18,
                                  //       letterSpacing: -0.2,
                                  //       color: FitnessAppTheme.nearlyDarkBlue,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: <Widget>[
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: <Widget>[
                              //         Icon(
                              //           Icons.access_time,
                              //           color: FitnessAppTheme.grey
                              //               .withOpacity(0.5),
                              //           size: 16,
                              //         ),
                              //         Padding(
                              //           padding:
                              //               const EdgeInsets.only(left: 4.0),
                              //           child: Text(
                              //             user != null ? user['name'] : '',
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //               fontFamily:
                              //                   FitnessAppTheme.fontName,
                              //               fontWeight: FontWeight.w500,
                              //               fontSize: 14,
                              //               letterSpacing: 0.0,
                              //               color: FitnessAppTheme.grey
                              //                   .withOpacity(0.5),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     Padding(
                              //       padding: const EdgeInsets.only(
                              //           top: 4, bottom: 14),
                              //       child: Text(
                              //         user != null ? user['email'] : '',
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //           fontFamily: FitnessAppTheme.fontName,
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 12,
                              //           letterSpacing: 0.0,
                              //           color: FitnessAppTheme.nearlyDarkBlue,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 4, bottom: 4),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  user!=null ? user['tcount'].toString() : '0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: FitnessAppTheme.darkText,
                                  ),
                                ),
                                Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child:  Icon(
                                        Icons.info_rounded,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                        size: 20.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                    ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      user!=null ? user['ncount'].toString() : '0',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child:  Icon(
                                        Icons.notifications_active,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                        size: 20.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      '0',
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.darkText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child:  Icon(
                                          Icons.money_sharp,
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                          size: 20.0,
                                          semanticLabel: 'Text to announce in accessibility modes',
                                        ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
