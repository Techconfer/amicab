
import 'package:chopper/chopper.dart';

part 'api_service.chopper.dart';

@ChopperApi(baseUrl: 'http://api.cabandcargo.com/v1.0')
abstract class ApiService extends ChopperService {
  @Post(path: '/register')
  Future<Response> postRegister(@Body() Map<String,dynamic> body);
  @Post(path: '/login')
  Future<Response> postLogin(@Body() Map<String,dynamic> body);
  @Get(path: '/get-user-profile/{id}')
  Future<Response> getProfile(@Path("id") String id);

  @Get(path: '/driver-online-offline/{id}')
  Future<Response> changeOnlineStatus(@Path("id") String id,@Query("type") type);
  @Post(path: '/profile-update/{id}')
  Future<Response> postProfileUpdate(@Path("id") String id,@Body() Map<String,dynamic> body);
  @Post(path: '/verify-otp')
  Future<Response> verifyOtp(@Body() Map<String,dynamic> body);
  @Post(path: '/register')

  @Post(path: '/driver-login')
  Future<Response> postDriverLogin(@Body() Map<String,dynamic> body);
  @Get(path: '/get-driver-profile/{id}')
  Future<Response> getDriverProfile(@Path("id") String id);
  @Post(path: '/edit-driver/{id}')
  Future<Response> postDriverProfileUpdate(@Path("id") String id,@Body() Map<String,dynamic> body);
  @Get(path: '/verify-driver-otp')
  Future<Response> verifyDriverOtp(@Body() Map<String,dynamic> body);


  @Post(path: '/add-transporter')
  Future<Response> postTransporterRegister(@Body() Map<String,dynamic> body);
  @Post(path: '/transporter-login')
  Future<Response> postTransporterLogin(@Body() Map<String,dynamic> body);
  @Get(path: '/edit-transporter/{id}')
  Future<Response> getTransporterProfile(@Path("id") String id);
  @Post(path: '/edit-transporter/{id}')
  Future<Response> postTransporterProfileUpdate(@Path("id") String id,@Body() Map<String,dynamic> body);
  @Get(path: '/verify-transporter-otp')
  Future<Response> verifyTransporterOtp(@Body() Map<String,dynamic> body);
  static ApiService create() {
    final _client = ChopperClient(
      converter: JsonConverter(),
      errorConverter: JsonConverter(),
      interceptors: [HttpLoggingInterceptor()],
      services: [
        _$ApiService(),
      ],

    );

    return _$ApiService(_client);
  }
}
