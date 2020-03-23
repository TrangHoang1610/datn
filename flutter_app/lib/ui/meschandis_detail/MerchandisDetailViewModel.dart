import 'package:flutter/material.dart';

class MerchandiseDetailViewModel {
  var isEditing = true;

  GlobalKey<FormState> formKey;

  TextEditingController tenSpControl,
      barcodeControl,
      descriptionController,
      inputPriceController,
      outputPriceController,
      totalMerchandiseController;
  dynamic categories = [];

  FileImage avatarImage;

  String base64Image = '';
  var selectedCategory = {};

  dynamic value = {};

  GlobalKey<ScaffoldState> scaffoldKey;
  MerchandiseDetailViewModel() {
    scaffoldKey = new GlobalKey();
    formKey = new GlobalKey();
    tenSpControl = new TextEditingController();
    barcodeControl = new TextEditingController();
    descriptionController = new TextEditingController();
    inputPriceController = new TextEditingController();
    outputPriceController = new TextEditingController();
    totalMerchandiseController = new TextEditingController();
  }
}
