import 'package:best_flutter_ui_templates/fitness_app/models/tabIcon_data.dart';
import 'package:best_flutter_ui_templates/fitness_app/screens/dash_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/screens/history_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/screens/jawaker_acceleration_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/screens/notification_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/screens/token_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/screens/transaction_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'fitness_app_theme.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = DashScreen(animationController: animationController,onChangeBody: (param) {
                      setState(() {
                        setBody(param);
                      });
                    });
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void setBody(name) {
    print('name');
    print(name);
    if (name == 'dash')
      tabBody = DashScreen(
          animationController: animationController,
          onChangeBody: (param) {
            setState(() {
              setBody(param);
            });
          });
    else if (name == 'jawaker_acceleration')
      tabBody = JawakerAccelerationScreen(animationController: animationController);
    else if (name == 'token')
      tabBody = TokenScreen(animationController: animationController);
    else if (name == 'notification')
      tabBody = NotificationScreen(animationController: animationController);
    else if (name == 'transaction')
      tabBody = TransactionScreen(animationController: animationController);
    else if (name == 'history')
      tabBody = HistoryScreen(animationController: animationController);

    tabIconsList.forEach((element) {
      element.isSelected = false;
      if (element.name == name) element.isSelected = true;
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            String name = tabIconsList[index].name;
            if (name == 'dash') {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = DashScreen(
                    animationController: animationController,
                    onChangeBody: (param) {
                      setState(() {
                        setBody(param);
                      });
                    },
                  );
                });
              });
            } else if (name == 'jawaker_acceleration') {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = JawakerAccelerationScreen(
                      animationController: animationController);
                });
              });
            } else if (name == 'token') {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TokenScreen(animationController: animationController);
                });
              });
            } else if (name == 'notification') {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = NotificationScreen(
                      animationController: animationController);
                });
              });
            } else if (name == 'transaction') {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = TransactionScreen(
                      animationController: animationController);
                });
              });
            } else if (name == 'history') {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      HistoryScreen(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
