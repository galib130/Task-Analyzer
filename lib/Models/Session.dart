import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proda/Service/SessionService.dart';

class SessionCommand {
  var sessionService = SessionService();
  Future<DocumentSnapshot> getSessionTimeReference(String uid) {
    return sessionService.getSessionTimeReference(uid);
  }

  void updateSessionTick(DocumentSnapshot documentSnapshot, bool? value) {
    sessionService.updateSessionTick(documentSnapshot, value);
  }

  void updateSecondarySession(String uid) {
    DocumentReference collectSecondarySession =
        sessionService.getSecondarySession(uid);
    sessionService.updateSessionValueComplete(collectSecondarySession);
  }

  void updatePrmarySessionCompleteTask(String uid) {
    DocumentReference collectPrimarySession =
        sessionService.getPrimarySession(uid);
    sessionService.updateSessionValueComplete(collectPrimarySession);
  }

  void updatePrimaryAverageSessionCompleteTask(String uid) {
    DocumentReference collectPrimaryAverageSession =
        sessionService.getPrimaryAverageSession(uid);
    sessionService.updateSessionValueComplete(collectPrimaryAverageSession);
  }

  void updateSecondaryAverageSessionCompleteTask(String uid) {
    DocumentReference collectSecondaryAverageSession =
        sessionService.getSecondaryAverageSession(uid);
    sessionService.updateSessionValueComplete(collectSecondaryAverageSession);
  }

  void updatePrimarySessionAdd(String uid) {
    DocumentReference collectPrimarySession =
        sessionService.getPrimarySession(uid);
    DocumentReference collectPrimaryAverageSession =
        sessionService.getPrimaryAverageSession(uid);
    sessionService.updateSessionValueAdd(collectPrimarySession);
    sessionService.updateSessionValueAdd(collectPrimaryAverageSession);
  }

  void updateSecondarySessionAdd(String uid) {
    DocumentReference collectSecondarySession =
        sessionService.getSecondarySession(uid);
    DocumentReference collectSecondaryAverageSession =
        sessionService.getSecondaryAverageSession(uid);
    sessionService.updateSessionValueAdd(collectSecondarySession);
    sessionService.updateSessionValueAdd(collectSecondaryAverageSession);
  }
}
