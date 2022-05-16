import 'package:cloud_firestore/cloud_firestore.dart';

enum Status { tab, session, efficiency }

abstract class Analysis {
  List<String> getFeedback();
  CollectionReference GetMetaData(String uid);
}

class TabAnalysis implements Analysis {
  @override
  CollectionReference GetMetaData(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("MetaData");
  }

  @override
  List<String> getFeedback() {
    String DifferenceAnalyzePrimaryHigh =
        "Might consider completing the Primary tasks to control the pace of your work";

    String DifferenceAnalyzeSecondaryHigh =
        "Might consider making some time to focus on completing some Secondary tasks";

    String DifferenceAnalyzeBalanced =
        "Workload seems to be balanced at the moment\n Might consider mixing focus between Secondary and Primary";

    String High =
        "Workload: HIGH\n\nFeedback: More effort needed in completing tasks";
    String VeryHigh =
        "Workload: VERY HIGH\n\nFeedback: There is risk of procrastination or being overwhelmed\nNeed to go ballistic mate";
    String Low =
        "Workload: SMALL\n\nFeedback: Addition of more tasks in the Primary tab is possible";

    List<String> Feedback = [
      DifferenceAnalyzePrimaryHigh,
      DifferenceAnalyzeSecondaryHigh,
      DifferenceAnalyzeBalanced,
      High,
      VeryHigh,
      Low,
    ];

    return Feedback;
  }
}

class SessionAnalysis implements Analysis {
  @override
  CollectionReference GetMetaData(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("session");
  }

  @override
  List<String> getFeedback() {
    String DifferenceAnalyzePrimaryHigh =
        "Too much focus spent on completing Primary Tasks compared to Secondary Tasks\nNeed to make mored time to focus on completing Secondary Tasks\n Could be due to procrastination or bad scheduling";

    String DifferenceAnalyzeSecondaryHigh =
        "Primary tasks not given enough importance\nImportant tasks left alone might hamper overall result more than if the situation was reversed\nInference: Could be due to procastination or bad scheduling";

    String DifferenceAnalyzeBalanced =
        "Task management seems to be up to the mark";

    String High =
        "Efficiency: HIGH\n\nFeedback: Well done! Keep it up in the next session!";
    String VeryHigh =
        "Efficiency: VERY HIGH\n\nFeedback: Might consider adding more tasks outside your comfort zone";
    String Low =
        "Efficiency: LOW\n\nFeedback: Need to step it up and make more time to complete more tasks\nInference: May be due to lack of initiative or procrastination";

    List<String> Feedback = [
      DifferenceAnalyzePrimaryHigh,
      DifferenceAnalyzeSecondaryHigh,
      DifferenceAnalyzeBalanced,
      High,
      VeryHigh,
      Low
    ];

    return Feedback;
  }
}

class EfficiencyAnalysis implements Analysis {
  @override
  CollectionReference GetMetaData(String uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("average_session");
  }

  @override
  List<String> getFeedback() {
    String DiffHigh = "Need to work extra harder to get the ";
    String FeedbackDiffHigh =
        "Might consider finishing some backlog tasks or adding more tasks in ";
    String DifferenceAnalyzePrimaryHigh = DiffHigh +
        "Secondary avg Efficiency up\n" +
        FeedbackDiffHigh +
        "Secondary";

    String DifferenceAnalyzeSecondaryHigh =
        DiffHigh + "Primary avg Efficiency up\n" + FeedbackDiffHigh + "Primary";
    String DifferenceAnalyzeBalanced =
        "Task management seems to be up to the mark consistently";

    String High =
        "Avg Efficicency: HIGH\n\nFeedback: Well done! Keep it up Consistency is key!";
    String VeryHigh =
        "Avg Efficiency: VERY HIGH\n\nFeedback: Might consider adding more tasks outside your comfort zone";
    String Low =
        "Avg Efficiency: LOW\n\nFeedback: Work harder and try for improvements by bigger margins to get the Avg Efficicency up\n\nInference: May be due to lack of initiative or procrastination";

    List<String> Feedback = [
      DifferenceAnalyzePrimaryHigh,
      DifferenceAnalyzeSecondaryHigh,
      DifferenceAnalyzeBalanced,
      High,
      VeryHigh,
      Low
    ];

    return Feedback;
  }
}
