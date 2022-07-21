List<String> provideAnalysis(
    int primary, int secondary, List<String> feedback) {
  String totalAnalyze;
  String differenceAnalyze = "Difference is stable";
  String primaryAnalyze = "Status: stable";
  String secondaryAnalyze = "Status: stable";
  int difference = (primary - secondary).abs();
  int initialThreshold = 5;
  int highThreshold = 15;
  List<String> analysis = [];

  if (difference >= initialThreshold) {
    switch (primary > secondary) {
      case true:
        {
          differenceAnalyze = feedback[0];
        }
        break;

      case false:
        {
          if (secondary > primary) differenceAnalyze = feedback[1];
        }
        break;
    }
  } else
    differenceAnalyze = feedback[2];

  if (primary > initialThreshold) {
    if (primary < highThreshold) primaryAnalyze = feedback[3];
    if (primary >= highThreshold) primaryAnalyze = feedback[4];
  } else
    primaryAnalyze = feedback[5];

  if (secondary > initialThreshold) {
    if (secondary < highThreshold) secondaryAnalyze = feedback[3];
    if (secondary >= highThreshold) secondaryAnalyze = feedback[4];
  } else
    secondaryAnalyze = feedback[5];
  totalAnalyze = "Status of Primary:  " +
      primaryAnalyze +
      "\n\n" +
      "Status of Secondary: " +
      secondaryAnalyze +
      "\n\n" +
      "Workload balance: " +
      differenceAnalyze;

  analysis.add(primaryAnalyze);
  analysis.add(secondaryAnalyze);
  analysis.add(differenceAnalyze);

  return analysis;
}
