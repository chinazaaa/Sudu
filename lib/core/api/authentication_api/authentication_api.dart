
import 'package:starter_project/models/api_response.dart';

abstract class AuthenticationApi {
  // //Fcm
  // Future<ApiResponse> updateFcmToken(String token);

  /// Registration
  //SALOON
  Future<ApiResponse> registerSaloon({
    String userName,
    String email,
    String phone,
    String password,
    String nameOfSalon,
    String typeOfSalon,
    String address,
  });
  Future<ApiResponse> loginSaloon({
    String email,
    String password,
  });
  Future<ApiResponse> confirmSaloonOTP({
    String otp,
  });



  //CUSTOMER
  Future<ApiResponse> registerCustomer({
    String userName,
    String email,
    String phone,
    String password,
  });

  Future<ApiResponse> loginCustomer({
    String email,
    String password,
  });

  Future<ApiResponse> confirmCustomerOTP({
    String otp,
  });

 Future<ApiResponse> resendOTPSalon({
    String email
  });

   Future<ApiResponse> resendOTPCustomer({
    String email
  });

   Future<ApiResponse> forgotPasswordSalon({
    String email
  });

  Future<ApiResponse> resetSalonPassword({
    String otp, String newPassword, String email
  });

  Future<ApiResponse> resetCustomerPassword({
    String otp, String newPassword, String email
  });

    Future<ApiResponse> forgotPasswordCustomer({
    String email
  });
}
