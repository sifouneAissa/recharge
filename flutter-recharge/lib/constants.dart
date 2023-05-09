import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;
const double defaultAcceleratorToken = 190000;
const double defaultHeight = 10.0;

getBoxBackgroud() {
  return BoxDecoration(
    color: FitnessAppTheme.nearlyDarkREd,
    gradient: getGradianBg(),
    // shape: BoxShape.circle,
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: FitnessAppTheme.nearlyDarkREd.withOpacity(0.0),
          offset: const Offset(8.0, 16.0),
          blurRadius: 16.0),
    ],
  );
}

getLinearGradianBg(){
  return [
      HexColor(FitnessAppTheme.gradiantFc),
      HexColor(FitnessAppTheme.gradiantFc),
      // HexColor('#4F1516'),
      HexColor(FitnessAppTheme.gradiantSc),
      HexColor(FitnessAppTheme.gradiantSc),
    ];
}

getGradianBg(){
  return LinearGradient(colors: getLinearGradianBg(), begin: Alignment.topLeft, end: Alignment.bottomRight);
}