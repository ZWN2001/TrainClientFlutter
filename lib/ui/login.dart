import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/util/string_util.dart';

import '../api/api.dart';
import '../bean/bean.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/auth';

  const LoginPage({Key? key}) : super(key: key);

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) async {
    ResultEntity requestMap = await UserApi.login(data.name, data.password);
    if (requestMap.result) {
      Fluttertoast.showToast( msg: '登录成功');
      Get.back();
      return null;
    }else{
      return requestMap.message;
    }
  }

  Future<String?> _registerUser(LoginData data) async {
    User user = User.name(userId: data.name, pwd: data.password);
    ResultEntity requestMap = await UserApi.register(user);
    if (requestMap.result) {
      Fluttertoast.showToast( msg: '注册成功');
      return null;
    }else{
      return requestMap.message;
    }
  }

  Future<String> _recoverPassword(String name) async {
    return "fail";
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      loginAfterSignUp: false,
      title: 'Train 12306',
      logo: 'icons/app_icon.png',
      logoTag: 'near.huscarl.loginsample.logo',
      titleTag: 'near.huscarl.loginsample.title',
      navigateBackAfterRecovery: true,
      // hideProvidersTitle: false,
      // loginAfterSignUp: false,
      hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      // disableCustomPageTransformer: true,
      messages: LoginMessages(
        userHint: '账号',
        passwordHint: '密码',
        confirmPasswordHint: '确认密码',
        loginButton: '登录',
        signupButton: '注册',
        forgotPasswordButton: '忘记密码?',
        recoverPasswordButton: '密码提示',
        goBackButton: '返回',
        confirmPasswordError: '密码不匹配',
      ),
      loginProviders: [
        LoginProvider(
          icon: FontAwesomeIcons.qq,
          label: 'QQ',
          callback: () async {
            await Future.delayed(loginTime);
            Fluttertoast.showToast( msg: '暂不支持');
            return '';
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.weixin,
          label: '微信',
          callback: () async {
            await Future.delayed(loginTime);
            Fluttertoast.showToast( msg: '暂不支持');
                return '';
          },
        ),
      ],
      userValidator: (value) {
        if (value!.isEmpty) {
          return '密码为空';
        } else if(!StringUtil.isNumber(value) || value.length != 11){
          return '请输入手机号';
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return '密码为空';
        }
        return null;
      },
      onLogin: (loginData) {
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        return _registerUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        // Navigator.of(context).pushReplacement(FadePageRoute(
        //   builder: (context) => DashboardScreen(),
        // ));
      },
      onRecoverPassword: (name) {
        return _recoverPassword(name);
      },
      showDebugButtons: false,
    );
  }
}
