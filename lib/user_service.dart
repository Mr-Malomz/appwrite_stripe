import 'package:appwrite/appwrite.dart';
import 'package:appwrite_stripe/utils.dart';

class UserService {
  Client client = Client();
  Databases? db;

  UserService() {
    _init();
  }

  //initialize the application
  _init() async {
    client
        .setEndpoint(AppConstant().endpoint)
        .setProject(AppConstant().projectId);

    db = Databases(client);

    //get current session
    Account account = Account(client);

    try {
      await account.get();
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        account
            .createAnonymousSession()
            .then((value) => value)
            .catchError((e) => e);
      }
    }
  }

  Future createSubcription() async {
    Functions functions = Functions(client);
    try {
      var result =
          await functions.createExecution(functionId: AppConstant().functionId);
      return result;
    } catch (e) {
      throw Exception('Error creating subscription');
    }
  }

  Future<User> getUserDetails() async {
    try {
      var data = await db?.getDocument(
          databaseId: AppConstant().databaseId,
          collectionId: AppConstant().collectionId,
          documentId: AppConstant().userId);
      var user = data?.convertTo((doc) => User.fromJson(doc));
      return user!;
    } catch (e) {
      throw Exception('Error getting user details');
    }
  }

  Future subcribeUser(String name) async {
    try {
      User updateUser = User(name: name, is_subscribed: true);
      var data = await db?.updateDocument(
        databaseId: AppConstant().databaseId,
        collectionId: AppConstant().collectionId,
        documentId: AppConstant().userId,
        data: updateUser.toJson(),
      );
      return data;
    } catch (e) {
      throw Exception('Error subscribing user');
    }
  }

  Future unSubcribeUser(String name) async {
    try {
      User updateUser = User(name: name, is_subscribed: false);
      var data = await db?.updateDocument(
        databaseId: AppConstant().databaseId,
        collectionId: AppConstant().collectionId,
        documentId: AppConstant().userId,
        data: updateUser.toJson(),
      );
      return data;
    } catch (e) {
      throw Exception('Error unsubscribing user');
    }
  }
}
