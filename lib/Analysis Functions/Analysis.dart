import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proda/Providers/SessionProvider.dart';

import 'package:proda/Providers/TaskProvider.dart';

enum SessionStatus { tab, session, efficiency }

abstract class Analysis {
  List<String> getFeedback();
  CollectionReference getMetaData(String uid);
}

class TabAnalysis implements Analysis {
  @override
  CollectionReference getMetaData(String uid) {
    CollectionReference collectMetaData = TaskProvider().getTabMetaData(uid);
    return collectMetaData;
  }

  @override
  List<String> getFeedback() {
    String differenceAnalyzePrimaryHigh =
        "Might consider completing the Primary tasks to control the pace of your work";

    String differenceAnalyzeSecondaryHigh =
        "Might consider making some time to focus on completing some Secondary tasks";

    String differenceAnalyzeBalanced =
        "Workload seems to be balanced at the moment\nMight consider mixing focus between Secondary and Primary";

    String high =
        "Workload: HIGH\n\nFeedback: More effort needed in completing tasks";
    String veryHigh =
        "Workload: VERY HIGH\n\nFeedback: There is risk of procrastination or being overwhelmed\nNeed to go ballistic mate";
    String low =
        "Workload: SMALL\n\nFeedback: Addition of more tasks in the Primary tab is possible";

    List<String> feedback = [
      differenceAnalyzePrimaryHigh,
      differenceAnalyzeSecondaryHigh,
      differenceAnalyzeBalanced,
      high,
      veryHigh,
      low,
    ];

    return feedback;
  }
}

class SessionAnalysis implements Analysis {
  @override
  CollectionReference getMetaData(String uid) {
    CollectionReference collect = SessionProvider().getSessionData(uid);
    return collect;
  }

  @override
  List<String> getFeedback() {
    String differenceAnalyzePrimaryHigh =
        "Too much focus spent on completing Primary Tasks compared to Secondary Tasks\nNeed to make mored time to focus on completing Secondary Tasks\n Could be due to procrastination or bad scheduling";

    String differenceAnalyzeSecondaryHigh =
        "Primary tasks not given enough importance\nImportant tasks left alone might hamper overall result more than if the situation was reversed\nInference: Could be due to procastination or bad scheduling";

    String differenceAnalyzeBalanced =
        "Task management seems to be up to the mark";

    String high =
        "Efficiency: HIGH\n\nFeedback: Well done! Keep it up in the next session!";
    String veryHigh =
        "Efficiency: VERY HIGH\n\nFeedback: Might consider adding more tasks outside your comfort zone";
    String low =
        "Efficiency: LOW\n\nFeedback: Need to step it up and make more time to complete more tasks\nInference: May be due to lack of initiative or procrastination";

    List<String> feedback = [
      differenceAnalyzePrimaryHigh,
      differenceAnalyzeSecondaryHigh,
      differenceAnalyzeBalanced,
      high,
      veryHigh,
      low
    ];

    return feedback;
  }
}

class EfficiencyAnalysis implements Analysis {
  @override
  CollectionReference getMetaData(String uid) {
    CollectionReference collect = SessionProvider().getAverageSessionData(uid);
    return collect;
  }

  @override
  List<String> getFeedback() {
    String diffHigh = "Need to work extra harder to get the ";
    String feedbackDiffHigh =
        "Might consider finishing some backlog tasks or adding more tasks in ";
    String differenceAnalyzePrimaryHigh = diffHigh +
        "Secondary avg Efficiency up\n" +
        feedbackDiffHigh +
        "Secondary";

    String differenceAnalyzeSecondaryHigh =
        diffHigh + "Primary avg Efficiency up\n" + feedbackDiffHigh + "Primary";
    String differenceAnalyzeBalanced =
        "Task management seems to be up to the mark consistently";

    String high =
        "Avg Efficicency: HIGH\n\nFeedback: Well done! Keep it up Consistency is key!";
    String veryHigh =
        "Avg Efficiency: VERY HIGH\n\nFeedback: Might consider adding more tasks outside your comfort zone";
    String low =
        "Avg Efficiency: LOW\n\nFeedback: Work harder and try for improvements by bigger margins to get the Avg Efficicency up\n\nInference: May be due to lack of initiative or procrastination";

    List<String> feedback = [
      differenceAnalyzePrimaryHigh,
      differenceAnalyzeSecondaryHigh,
      differenceAnalyzeBalanced,
      high,
      veryHigh,
      low
    ];

    return feedback;
  }
}
