import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proda/Service/SessionService.dart';

class SessionCommand {
  var sessionService = SessionService();
  Future<DocumentSnapshot> getSessionReference(String uid) {
    return sessionService.getSessionReference(uid);
  }

  void updateSessionTick(DocumentSnapshot documentSnapshot, bool? value) {
    sessionService.updateSessionTick(documentSnapshot, value);
  }

  void updateSecondarySession(String uid) {
    DocumentReference collectSecondarySession =
        sessionService.getSecondarySession(uid);
    sessionService.updateSession(collectSecondarySession);
  }

  void updatePrmarySession(String uid) {
    DocumentReference collectPrimarySession =
        sessionService.getPrimarySession(uid);
    sessionService.updateSession(collectPrimarySession);
  }

  void updatePrimaryAverageSession(String uid) {
    DocumentReference collectPrimaryAverageSession =
        sessionService.getPrimaryAverageSession(uid);
    sessionService.updateSession(collectPrimaryAverageSession);
  }

  void updateSecondaryAverageSession(String uid) {
    DocumentReference collectSecondaryAverageSession =
        sessionService.getSecondaryAverageSession(uid);
    sessionService.updateSession(collectSecondaryAverageSession);
  }
}
