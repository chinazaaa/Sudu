import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:starter_project/models/api_response_variants/changeSalonOwnerPassword_response.dart';
import 'package:starter_project/models/api_response_variants/customer_login_response.dart';
import 'package:starter_project/models/api_response_variants/salon_login_response.dart';
import 'package:starter_project/models/api_response_variants/update_customer_response.dart';
import 'package:starter_project/models/api_response_variants/update_salon_owner_response.dart';
import 'package:starter_project/models/api_response_variants/update_salon_response.dart';

import '../../../index.dart';
import '../api_utils/api_helper.dart';
import '../api_utils/api_routes.dart';
import '../api_utils/network_exceptions.dart';
import 'profile_api.dart';
import '../../../infrastructure/user_info_cache.dart';

import '../../../locator.dart';

class ProfileApiImpl implements ProfileApi {
  //API client
  var server = locator<API>();

  @override
  Future<ChangeSalonOwnerPasswordResponse> changeSalonOwnerPassword(
      {String oldPassword, String newPassword, String confirmPassword}) async {
    Map val = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      // 'confirmPassword': confirmPassword,
    };
    print(val);

    print(
        '${ApiRoutes.changeSalonOwnerPassword}/${locator<UserInfoCache>().salon.data.user.id}');
    var responsebody = await server.put(
      '${ApiRoutes.changeSalonOwnerPassword}/${locator<UserInfoCache>().salon.data.user.id}',
      xheader,
      body: jsonEncode(val),
    );

    ChangeSalonOwnerPasswordResponse response =
        ChangeSalonOwnerPasswordResponse.fromJson(responsebody);
    return response;
  }

  @override
  Future<CustomerLoginResponse> changeCustomerPassword(
      {String oldPassword, String newPassword, String confirmPassword}) async {
    Map val = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    var responsebody = await server.put(
        '${ApiRoutes.changeCustomerPassword}/${locator<UserInfoCache>().customer.data.id}',
        header,
        body: jsonEncode(val));

    CustomerLoginResponse response =
        CustomerLoginResponse.fromJson(responsebody);
    return response;
  }

  @override
  Future<ApiResponse> getSalonOwnerProfile({String id}) async {
    var responsebody =
        await server.get(ApiRoutes.getSalonOwnerProfile + '$id', header);
    ApiResponse response = ApiResponse.fromJson(responsebody);
    return response;
  }

  @override
  Future<ApiResponse> getSalonProfile({String id}) async {
    var responsebody =
        await server.get(ApiRoutes.getSalonProfile + '$id', header);
    ApiResponse response = ApiResponse.fromJson(responsebody);
    return response;
  }

  @override
  Future<ApiResponse> getCustomerProfile({String id}) async {
    var responsebody = await server.get(ApiRoutes.getCustomerProfile, header);
    ApiResponse response = ApiResponse.fromJson(responsebody);
    return response;
  }

  @override
  Future<ApiResponse> togglePushNotification({int value}) async {
    //data
    Map val = {
      'push_notification': value.toString(),
    };

    var responsebody = await server.post(
        ApiRoutes.togglePushNotification, header, jsonEncode(val));

    ApiResponse response = ApiResponse.fromJson(responsebody);
    return response;
  }

//update salon profile
  @override
  Future<UpdateSalonResponse> updateSalonProfile(
      {String nameOfSalon,
      String description,
      // File image,
      String category,
      String address}) async {
    Map<String, String> header = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'x-access-token': locator<UserInfoCache>().token
    };

    print('${locator<UserInfoCache>().salon.data.salon.id}');
    Map val = {
      'nameOfSalon': nameOfSalon,
      'description': description,
      //'image': image,
      'category': category,
      'address': address,
    };

    var responsebody = await server.put(
      '${ApiRoutes.updateSalonProfile}/${locator<UserInfoCache>().salon.data.salon.id}',
      header,
      body: jsonEncode(val),
    );

    UpdateSalonResponse response = UpdateSalonResponse.fromJson(responsebody);
    return response;
  }

//update salon owner profile
  @override
  Future<UpdateSalonOwnerResponse> updateSalonUserProfile(
      {String userName, String phone}) async {
    Map<String, String> val = {
      // 'email' : email,
      'phone': phone,
      'userName': userName,
    };
    var responsebody = await server.put(
        '${ApiRoutes.updateSalonOwnerProfile}/${locator<UserInfoCache>().salon.data.user.id}',
        xheader,
        body: jsonEncode(val));
    UpdateSalonOwnerResponse response =
        UpdateSalonOwnerResponse.fromJson(responsebody);
    return response;
  }

  @override
  Future<ApiResponse> updateGallery(List<String> images) async {
    List<MultipartFile> files = [];
    //generate a list of image formData
    for (int i = 0; i < images.length; i++) {
      String imgName = DateTime.now().millisecondsSinceEpoch.toString();
      MultipartFile file = await MultipartFile.fromFile(
        images[i],
        filename: '$imgName/${images[i]}',
        contentType: MediaType('image', 'jpg'),
      );
      //add to files
      files.add(file);
    }

    FormData formData = FormData.fromMap({
      "image": files,
    });

    // print(files.map((e) => e.filename).toList());

    var responsebody = await server.put(
        '${ApiRoutes.salonGallery}/${locator<UserInfoCache>().salon.data.salon.id}',
        mediaHeader,
        multimediaRequest: formData);
    ApiResponse res = ApiResponse.fromJson(responsebody);
    return res;
  }

  //update customer
  @override
  Future<UpdateCustomerResponse> updateCustomerProfile(
      {String userName, String phone}) async {
    Map<String, String> val = {
      // 'email' : email,
      'phone': phone,
      'userName': userName,
    };

    var responsebody = await server.put(
        '${ApiRoutes.updateCustomerProfile}/${locator<UserInfoCache>().customer.data.id}',
        header,
        body: jsonEncode(val));
    UpdateCustomerResponse response =
        UpdateCustomerResponse.fromJson(responsebody);
    return response;
  }

  Map<String, String> get header => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-access-token': locator<UserInfoCache>().token
      };

  Map<String, String> get xheader => {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'x-access-token': locator<UserInfoCache>().token
      };

  Map<String, String> get mediaHeader => {
    'Accept': 'application/json',
    // 'Content-Type': 'application/x-www-form-urlencoded',
    'x-access-token': locator<UserInfoCache>().token
  };
}
