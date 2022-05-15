List<String> ProvideAnalysis(
    int Primary, int Secondary, List<String> Feedback) {
  String TotalAnalyze;
  String DifferenceAnalyze = "Difference is stable";
  String PrimaryAnalyze = "Status: stable";
  String SecondaryAnalyze = "Status: stable";
  int difference = (Primary - Secondary).abs();
  int initial_threshold = 5;
  int high_threshold = 15;
  List<String> Analysis = [];

  if (difference >= initial_threshold) {
    switch (Primary > Secondary) {
      case true:
        {
          DifferenceAnalyze = Feedback[0];
        }
        break;

      case false:
        {
          if (Secondary > Primary) DifferenceAnalyze = Feedback[1];
        }
        break;
    }
  } else
    DifferenceAnalyze = Feedback[2];

  if (Primary > initial_threshold) {
    if (Primary < high_threshold) PrimaryAnalyze = Feedback[3];
    if (Primary >= high_threshold) PrimaryAnalyze = Feedback[4];
  } else
    PrimaryAnalyze = Feedback[5];

  if (Secondary > initial_threshold) {
    if (Secondary < high_threshold) SecondaryAnalyze = Feedback[3];
    if (Secondary >= high_threshold) SecondaryAnalyze = Feedback[4];
  } else
    SecondaryAnalyze = Feedback[5];
  TotalAnalyze = "Status of Primary:  " +
      PrimaryAnalyze +
      "\n\n" +
      "Status of Secondary: " +
      SecondaryAnalyze +
      "\n\n" +
      "Workload balance: " +
      DifferenceAnalyze;

  Analysis.add(PrimaryAnalyze);
  Analysis.add(SecondaryAnalyze);
  Analysis.add(DifferenceAnalyze);

  return Analysis;
}
