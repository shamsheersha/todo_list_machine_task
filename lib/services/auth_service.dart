import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todo_list_machinetask/model/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null
          ? null
          : User(
              id: firebaseUser.uid,
              email: firebaseUser.email!,
              displayName: firebaseUser.displayName ??
                  firebaseUser.email!.split('@')[0]);
    });
  }

// Sign Ip
  Future<User?> signIn(String email, String password)async{
    try {
      final _firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final firebaseUser = _firebaseUser.user;
      if(firebaseUser == null)return null;

      return User(id: firebaseUser.uid, email: firebaseUser.email!, displayName: firebaseUser.displayName ?? firebaseUser.email!.split('@')[0]);
    }catch(e){
       rethrow;
    }
  }

// Sign Up 
  Future<User?> signUp(String email, String password)async{
    try {
      final _firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final firebaseUser = _firebaseUser.user;
      if(firebaseUser == null)return null;

      return User(id: firebaseUser.uid, email: firebaseUser.email!, displayName: firebaseUser.displayName ?? firebaseUser.email!.split('@')[0]);
    }catch(e){
       rethrow;
    }
  }

// Sign Out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

// Get Current User
  User? getCurrentUser() {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email!,
      displayName: firebaseUser.displayName ?? firebaseUser.email!.split('@')[0],
    );
  }
}
