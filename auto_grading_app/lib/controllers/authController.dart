class AuthController{
  // private constructor
  AuthController._() : super();

  // singleton
  static final AuthController _instance = AuthController._();

  static AuthController get instance => _instance;

  String _token="";

  void setToken(String token){
    _token=token;
  }

  String getToken(){
    return _token;
  }

  Map<String,String> getHeader(){
    Map<String, String> headers = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json', 
    };

    return headers;
  }


}