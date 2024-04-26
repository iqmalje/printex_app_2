import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:path/path.dart';

class AuthenticationDAO {
  SupabaseClient supabase = Supabase.instance.client;
  Future<String> signIn(String email, String password) async {
    try {
      AuthResponse response = await supabase.auth
          .signInWithPassword(password: password, email: email);

      //if nothing
      return '';
    } on AuthException catch (e) {
      print('EMAIL IS NOT YET CONFIRMED LA CB');
      print(e.message);

      if (e.message == 'Invalid login credentials') {
        throw InvalidLoginCredentials('Wrong email and password');
      } else if (e.message == 'Email not confirmed') {
        throw EmailNotVerified('Email is not verified yet');
      }
      //else return
      return e.message;
    }
  }

  Future<void> resetPassword(String email) async {
    print("'$email' is the email, sent OTP");
    await supabase.auth.resetPasswordForEmail(email);
  }

  Future<bool> confirmResetPasswordToken(String email, String token) async {
    try {
      print("'$email' is the email");
      var approved = await supabase.auth
          .verifyOTP(email: email, token: token, type: OtpType.recovery);

      if (approved.user == null) {
        return false;
      }

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> setNewPassword(String email, String password) async {
    try {
      await supabase.auth
          .updateUser(UserAttributes(email: email, password: password));
    } on AuthException catch (e) {
      throw e.message;
    }
  }

  Future<void> resendOTP(String email) async {
    await supabase.auth.resend(type: OtpType.signup, email: email);
  }

  Future<bool> verifyOTP(String email, String OTP) async {
    try {
      await supabase.auth
          .verifyOTP(token: OTP, type: OtpType.email, email: email);

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> signUp(
      String fullname, String email, String phone, String password) async {
    AuthResponse response =
        await supabase.auth.signUp(email: email, password: password);

    try {
      await supabase.from('accounts').insert({
        'accountid': response.user!.id,
        'fullname': fullname,
        'email': email,
        'phone': phone,
      });
    } on PostgrestException {
      rethrow;
    } on AuthException {
      rethrow;
    }

    await supabase
        .from('wallet')
        .insert({'accountid': response.user!.id, 'balance': 0});
  }

  Future<dynamic> getProfileInfo() async {
    var result = await supabase.from('accounts').select('*');
    print(result);

    return result[0];
  }

  Future<void> updateProfilePic(File image) async {
    var userid = supabase.auth.currentUser!.id;

    //upload to storage
    await supabase.storage
        .from('profilepics')
        .upload('$userid/${basename(image.path)}', image);
    //get image url
    var imageurl = supabase.storage
        .from('profilepics')
        .getPublicUrl('$userid/${basename(image.path)}');

    //update db
    await supabase
        .from('accounts')
        .update({'profilepic': imageurl}).eq('accountid', userid);
  }

  Future<void> deleteAccount() async {
    var userid = supabase.auth.currentUser!.id;
    var data = await supabase.functions
        .invoke('delete_account', body: {'userid': userid});

    //later we log out

    await supabase.auth.signOut();
  }

  Future<void> updateFullName(String fullname) async {
    var userid = supabase.auth.currentUser!.id;

    await supabase
        .from('accounts')
        .update({'fullname': fullname}).eq('accountid', userid);
  }

  Future<void> updatePhone(String phone) async {
    var userid = supabase.auth.currentUser!.id;

    await supabase
        .from('accounts')
        .update({'phone': phone}).eq('accountid', userid);
  }

  Future<void> updateEmail(String email) async {
    var userid = supabase.auth.currentUser!.id;

    await supabase
        .from('accounts')
        .update({'email': email}).eq('accountid', userid);
  }
}

// errors

class EmailNotVerified implements Exception {
  String cause;
  EmailNotVerified(this.cause);
}

class InvalidLoginCredentials implements Exception {
  String cause;
  InvalidLoginCredentials(this.cause);
}
