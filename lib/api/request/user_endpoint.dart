
import 'package:project1/api/request/hydra.dart';
import 'package:project1/api/request/request_manager.dart';
class UserEndpoint {

  static Future<Hydra> get() async
  {
    return RequestManager().get('/api/users');
  }

  static Future<List> gett() async
  {
    return await RequestManager().get('/api/users').then((value) => value.hydraMember);
  }



}