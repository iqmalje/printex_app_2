import 'package:supabase_flutter/supabase_flutter.dart';

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
