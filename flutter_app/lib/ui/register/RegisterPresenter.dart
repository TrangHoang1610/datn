import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:init_app/common/Common.dart';
import 'package:init_app/data/AppDataHelper.dart';
import 'package:init_app/utils/BasePresenter.dart';
import 'package:init_app/utils/CallNativeUtils.dart';

import 'RegisterView.dart';
import 'RegisterViewModel.dart';

class RegisterPresenter<V extends RegisterView> extends BasePresenter<V> {
  RegisterViewModel _viewModel;
  IAppDataHelper appDataHelper;

  RegisterPresenter(this._viewModel) {
    appDataHelper = new AppDataHelper();
  }

  void register() {
    dynamic data = {
      "username": _viewModel.usernameController.text,
      "password": _viewModel.passwordController.text,
      "email": _viewModel.emailController.text,
      "name": _viewModel.fullNameController.text,
      "image": _viewModel.avatarImage != null ? _viewModel.base64Image : "",
      "role": "2"
    };
    print(data);
    appDataHelper.registerAccount(jsonEncode(data)).then((onvalue) {
      print(onvalue);
      baseView.backView(data);
      print(onvalue);
    }).catchError((err) {
      baseView.showSnackbar(err, "w");
    });
  }

  void createPersonnel() {
    dynamic data = {
      "username": _viewModel.usernameController.text,
      "password": _viewModel.passwordController.text,
      "email": _viewModel.emailController.text,
      "name": _viewModel.fullNameController.text,
      "image": _viewModel.avatarImage != null ? _viewModel.base64Image : "",
      "role": "1",
      "idShop": Common.selectedShop["idShop"],
      "status": 1
    };
    print(data);
    appDataHelper.createPersonnel(jsonEncode(data)).then((onvalue) {
      baseView.backView(data);
    }).catchError((err) {
//      if(err["message"])
      baseView.showSnackbar(err, "w");
      print(err + "eeeeeeeeeeeeeeeeeeee");
    });
  }

  void setImage(callBack) {
    CallNativeUtils.invokeMethod(method: "getImage").then((value) {
      Uint8List image = base64.decode(value);
      callBack(image);
    });
  }

  void getImage(calback) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 640, maxWidth: 480);
    _viewModel.avatarImage = FileImage(image);
    List<int> imageBytes = image.readAsBytesSync();
    print(imageBytes);
    _viewModel.base64Image = base64Encode(imageBytes);
    calback();
  }

  void nameSummit() {
    _viewModel.fcEmail.requestFocus();
  }

  void emailSummit() {
    _viewModel.fcUsername.requestFocus();
  }

  void userNameSummit() {
    _viewModel.fcPassword.requestFocus();
  }

  void passSumit() {
    _viewModel.fcConfirmPass.requestFocus();
  }

  void disposeView() {
    if (_viewModel.fcConfirmPass != null) _viewModel.fcConfirmPass.dispose();
    if (_viewModel.fcEmail != null) _viewModel.fcEmail.dispose();
    if (_viewModel.fcUsername != null) _viewModel.fcUsername.dispose();
    if (_viewModel.fcPassword != null) _viewModel.fcPassword.dispose();
    if (_viewModel.fcName != null) _viewModel.fcName.dispose();
  }

  void setEnableEdit() {
    _viewModel.enableEdit = true;
    baseView.updateUI({});
  }

  void updateUser() {
    dynamic data = {
      "idUser": _viewModel.user != null
          ? _viewModel.user["idPersonnel"]
          : Common.user["idUser"],
      "username": _viewModel.usernameController.text,
      "password": _viewModel.passwordController.text,
      "email": _viewModel.emailController.text,
      "name": _viewModel.fullNameController.text,
      "image": _viewModel.avatarImage != null
          ? _viewModel.base64Image
          : _viewModel.user != null
              ? _viewModel.user["image"]
              : Common.user["image"],
    };
    appDataHelper.updateUser(jsonEncode(data)).then((onValue) {
      print(onValue);
      print("1234567890");
      baseView.showSnackbar("Sửa thông tin thành công.", "");
    }).catchError((err) {
      baseView.showSnackbar(err["error"], "w");
    });
  }
}
