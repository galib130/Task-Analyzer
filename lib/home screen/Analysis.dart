List<String> AnalyzeTaskPad(int Primary, int Secondary) {
  String TotalAnalyze;
  String DifferenceAnalyze = "Difference is stable";
  String PrimaryAnalyze = "Status: stable";
  String SecondaryAnalyze = "Status: stable";
  int difference = (Primary - Secondary).abs();
  List<String> Analysis = [];
  if (difference >= 5) {
    switch (Primary > Secondary) {
      case true:
        {
          DifferenceAnalyze =
              "Might consider completing the Primary tasks to control the pace of your work";
        }
        break;

      case false:
        {
          if (Secondary > Primary)
            DifferenceAnalyze =
                "Might consider making some time to focus on completing some Secondary tasks";
        }
        break;
    }
  } else
    DifferenceAnalyze =
        "Workload seems to be balanced at the moment, might consider mixing focus between Secondary and Primary";

  if (Primary > 5) {
    if (Primary < 15)
      PrimaryAnalyze =
          "Workload of your urgent tasks in primary is high, more effort needed in completing tasks";
    if (Primary >= 15)
      PrimaryAnalyze =
          "Workload of your urgent tasks is very high, there is risk of procrastination or being overwhelmed, need to go ballistic mate";
  } else
    PrimaryAnalyze =
        "Workload is small,addition of more tasks in the Primary tab is possible";

  if (Secondary > 5) {
    if (Secondary < 15)
      SecondaryAnalyze =
          "Workload of your secondary tasks are high, more effort needed in completing those tasks";
    if (Secondary >= 15)
      SecondaryAnalyze =
          "Workload of your secodnary tasks are very high, there is risk of procrastination or being overwhelmed and backlog, need to go ballistic mate";
  } else
    SecondaryAnalyze =
        "Workload is small,addition of more tasks in the Secondary tab is possible";

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
