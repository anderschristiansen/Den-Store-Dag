import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // App Data
  static final String title = 'Fireship';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  // Data Models
  static final Map models = {
    Gift: (data) => Gift.fromMap(data),
    Guest: (data) => Guest.fromSnapshot(data),
    User: (data) => User.fromMap(data)
  };

  // Firestore References for Writes
  static final Collection<Gift> giftsRef = Collection<Gift>(path: 'gifts');
  static final Collection<Guest> guestsRef = Collection<Guest>(path: 'guests');
  static final UserData<User> userRef = UserData<User>(collection: 'users');

  // static final UserData<Report> reportRef = UserData<Report>(collection: 'reports');
  // static final Collection<Topic> topicsRef = Collection<Topic>(path: 'topics');
}
