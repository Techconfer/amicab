// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ApiService extends ApiService {
  _$ApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiService;

  @override
  Future<Response<dynamic>> postRegister(Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/register';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postLogin(Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/login';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getProfile(String id) {
    final $url = 'http://api.cabandcargo.com/v1.0/get-user-profile/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> changeOnlineStatus(String id, dynamic type) {
    final $url = 'http://api.cabandcargo.com/v1.0/driver-online-offline/$id';
    final $params = <String, dynamic>{'type': type};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postProfileUpdate(
      String id, Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/profile-update/$id';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> verifyOtp(Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/verify-otp';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postDriverLogin(Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/register';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getDriverProfile(String id) {
    final $url = 'http://api.cabandcargo.com/v1.0/get-driver-profile/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postDriverProfileUpdate(
      String id, Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/edit-driver/$id';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> verifyDriverOtp(Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/verify-driver-otp';
    final $body = body;
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postTransporterRegister(Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/add-transporter';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postTransporterLogin(Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/transporter-login';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTransporterProfile(String id) {
    final $url = 'http://api.cabandcargo.com/v1.0/edit-transporter/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> postTransporterProfileUpdate(
      String id, Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/edit-transporter/$id';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> verifyTransporterOtp(Map<String, dynamic> body) {
    final $url = 'http://api.cabandcargo.com/v1.0/verify-transporter-otp';
    final $body = body;
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
