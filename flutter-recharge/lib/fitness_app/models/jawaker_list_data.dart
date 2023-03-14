class JawakerListData {
  JawakerListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;
  int kacl;

  static List<JawakerListData> tabIconsList = <JawakerListData>[
    JawakerListData(
      imagePath: 'assets/fitness_app/jawaker100.png',
      titleTxt: 'Point accelerators',
      kacl: 100,
      meals: <String>['100 %'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    JawakerListData(
      imagePath: 'assets/fitness_app/jawaker150.png',
      titleTxt: 'Point accelerators',
      kacl: 150,
      meals: <String>['Recommend','150 %'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    JawakerListData(
      imagePath: 'assets/fitness_app/jawaker300.png',
      titleTxt: 'Point accelerators',
      kacl: 300,
      meals: <String>['300 %'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    // JawakerListData(
    //   imagePath: 'assets/fitness_app/dinner.png',
    //   titleTxt: 'Dinner',
    //   kacl: 0,
    //   meals: <String>['Recommend:', '703 kcal'],
    //   startColor: '#6F72CA',
    //   endColor: '#1E1466',
    // ),
  ];
}
