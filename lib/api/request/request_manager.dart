import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project1/api/request/hydra.dart';
import 'package:project1/authentication/Adaptater/connexion/user_connexion.dart';
import 'package:project1/authentication/authentication_provider/authentication_provider.dart';
import '../../authentication/Adaptater/credential/user_credential.dart';

class RequestManager {

  static const String host = 'https://obione-lab.ovh/';
  static final Dio dio = client() as Dio;
  Hydra? hydra;

  static Dio client()
  {
    Map<String, dynamic> headers =  {
    "content-type": "application/ld+json",
    "accept": "application/ld+json",
    };

    BaseOptions baseOptions = BaseOptions(
      baseUrl: RequestManager.host,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 10),
      headers: headers,
    );


    final dio = Dio(
      BaseOptions(
        baseUrl: RequestManager.host,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 10),
        headers: headers,
      ),
    );
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          // Do something before request is sent.
          // If you want to resolve the request with custom data,
          // you can resolve a `Response` using `handler.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject with a `DioException` using `handler.reject(dioError)`.
          if (options.path != "authentication_token") {
            String token = UserCredential.fromJson(await SessionManager().get('user') as Map<String, dynamic>).token;
            options.headers["Authorization"] = "Bearer $token";
            return handler.next(options);
          }

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // Do something with response data.
          // If you want to reject the request with a error message,
          // you can reject a `DioException` object using `handler.reject(dioError)`.
          return handler.next(response);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          // Do something with response error.
          // If you want to resolve the request with some custom data,
          // you can resolve a `Response` object using `handler.resolve(response)`.
          if (false == await AuthenticationProvider.isUserLogged())
          {
            return handler.next(e);
          }

          if('{"code":401,"message":"Expired JWT Token"}' == e.response.toString()) {
              if (await AuthenticationProvider.isUserLogged())
              {
                UserCredential userCredential = UserCredential.fromJson(await SessionManager().get('user') as Map<String, dynamic>);
                AuthenticationProvider auth = AuthenticationProvider();
                UserConnexion userConnexion = UserConnexion(email: userCredential.email, password: userCredential.password);

                UserCredential credential = await auth.authUser(
                    userConnexion,
                    "myapi"
                );

                String token = credential.token;
                dio.options.headers["Authorization"]  = "Bearer $token";
                e.response?.requestOptions.headers.update('Authorization', (value) => "Bearer $token");
                Options options = Options().copyWith(
                  method: dio.options.method,
                  sendTimeout: dio.options.sendTimeout,
                  receiveTimeout: dio.options.receiveTimeout,
                  extra:  dio.options.extra,
                  headers:  dio.options.headers,
                  responseType:  dio.options.responseType,
                  contentType:  dio.options.contentType,
                  validateStatus:  dio.options.validateStatus,
                  receiveDataWhenStatusError:  dio.options.receiveDataWhenStatusError,
                  followRedirects:  dio.options.followRedirects,
                  maxRedirects:  dio.options.maxRedirects,
                  persistentConnection:  dio.options.persistentConnection,
                  requestEncoder:  dio.options.requestEncoder,
                  responseDecoder:  dio.options.responseDecoder,
                  listFormat:  dio.options.listFormat,
                );
                dio.request(
                    e.requestOptions.path,
                    data: e.response?.data,
                    queryParameters: e.requestOptions.queryParameters,
                    options: options
                );
                return;
              }

          }
          return handler.next(e);
        },
      ),
    );

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient dioClient = HttpClient();
      dioClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };

    return dio;
  }

  Future<Hydra> get(String uri) async
  {
    Hydra rr = await RequestManager.client().get(uri)
        .then((Response <dynamic> value) => fromJson(value))
        .onError((DioException error, StackTrace stackTrace) {
          print(error.message);
          print(error.requestOptions.headers.toString());
          print(error.response?.data);
          return fromJson(error.response?.data);
        });

     return rr;
  }

  Hydra fromJson(Response<dynamic>  data)
  {
    return Hydra(
      context: data.data["@context"],
      id: data.data["@id"],
      totalItems: data.data["hydra:totalItems"],
      type: data.data["@type"],
      hydraMember: data.data["hydra:member"]
    );
  }

}