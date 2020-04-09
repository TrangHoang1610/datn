import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:init_app/common/Common.dart';
import 'package:init_app/ui/create_bill/CreateBillView.dart';
import 'package:init_app/utils/IntentAnimation.dart';

import 'CreateBillPresenter.dart';
import 'CreateBilllViewmodel.dart';
import 'ItemMerchandis.dart';

class CreateBill extends StatefulWidget {
  static final KEY_CHECK_IMPORT_MERCHANDISE = "import merchandise";
  static final KEY_CHECK_DETAIL = "detail";
  static final KEY_CHECK_EXPORT_MERCHANDISE = "export merchandis";
  var keyCheck;
  dynamic value;

  CreateBill({@required this.keyCheck, this.value}) {
    if (keyCheck == "detail") {
      if (value == null) throw "Value is null";
    }
  }

  @override
  _CreateBillState createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> implements CreateBillView {
  CreateBillViewmodel _viewmodel;
  CreateBillPresenter<CreateBillView> _presenter;
  BuildContext context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewmodel = new CreateBillViewmodel();
    _viewmodel.keyCheck = widget.keyCheck;
    _presenter = new CreateBillPresenter<CreateBillView>(_viewmodel);
    _presenter.intiView(this);
    if (widget.keyCheck == CreateBill.KEY_CHECK_DETAIL) {
      print("${widget.value}");
      _viewmodel.editEnable = false;
//      _viewmodel.listMerchandis = widget.value["listMer"];
      _viewmodel.tongTien = widget.value["totalPrice"].toDouble();
      _viewmodel.chietKhau = widget.value["discount"].toDouble();
      _viewmodel.ghiChuController.text = widget.value["description"];
      _presenter.getMerchandisesByBill(
          widget.value["idBill"], Common.selectedShop["idShop"]);
    } else {
      if (widget.keyCheck == CreateBill.KEY_CHECK_EXPORT_MERCHANDISE ||
          widget.keyCheck == CreateBill.KEY_CHECK_IMPORT_MERCHANDISE) {
        _presenter.getMerchandisesByShop(Common.selectedShop["idShop"]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: _viewmodel.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          onPressed: () {
            IntentAnimation.intentBack(context: context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
            color: Colors.grey[700],
          ),
        ),
        title: _viewmodel.editEnable
            ? Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey[300],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        searchSanPham(context);
                      },
                      child: Container(
                        width: Common.widthOfScreen - 150,
                        color: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: Colors.grey[700],
                              ),
                              padding: EdgeInsets.only(right: 10),
                            ),
                            Container(
                              child: Text(
                                "Nhập tên tìm kiếm",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showBarcode();
                      },
                      child: Container(
                        child: Icon(
                          Icons.flip,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Text("Thông tin hóa đơn"),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Card(
                  elevation: 6,
                  child: Container(
                      child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ListView.separated(
                        separatorBuilder: (ctx, index) => Container(
                          height: 0.5,
                          color: Colors.grey,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => ItemMerchandis(
                          index,
                          _viewmodel,
                          () {
                            tinhTongSo();
                            tinhTongTien();
                            setState(() {});
                          },
                          enable: _viewmodel.editEnable,
                        ),
                        itemCount: _viewmodel.listMerchandis.length,
                      ),
                      Visibility(
                        visible: _viewmodel.listMerchandis.length == 0,
                        child: GestureDetector(
                          onTap: () {
                            searchSanPham(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: Common.heightOfScreen / 4,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Image.asset(
                                    "assets/icons/ic_create_order_intro.png",
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  child: Text(
                                    "Đơn hàng này của bạn \n chưa có sản phẩm nào!",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                ),
                SizedBox(
                  height: 20,
                ),
                customItemButton("Tổng số lượng:", "${_viewmodel.tongSo}"),
                customItemButton("Tổng tiền hàng:",
                    "${Common.CURRENCY_FORMAT.format(_viewmodel.tongTien)}"),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context)
                        .requestFocus(_viewmodel.focusNodeChietKhau);
                  },
                  child: customItemButton("Chiết khấu:", "0"),
                ),
                customItemButton("Giá tạm tính:",
                    "${Common.CURRENCY_FORMAT.format(_viewmodel.tongTien - _viewmodel.chietKhau)}"),
                Container(
                  width: Common.widthOfScreen,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                          style: BorderStyle.solid)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Ghi chú",
                          style: lableStyle(),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _viewmodel.editEnable
                          ? TextField(
                              controller: _viewmodel.ghiChuController,
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                labelText: "Ghi chú",
                              ),
                            )
                          : Text("${_viewmodel.ghiChuController.text}")
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _viewmodel.editEnable
                    ? Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _viewmodel.listMerchandis.length > 0 &&
                                    _viewmodel.tongSo > 0
                                ? GestureDetector(
                                    onTap: () {
                                      if (widget.keyCheck ==
                                          CreateBill
                                              .KEY_CHECK_EXPORT_MERCHANDISE)
                                        _presenter.createBillExport();
                                      if (widget.keyCheck ==
                                          CreateBill
                                              .KEY_CHECK_IMPORT_MERCHANDISE)
                                        _presenter.createBillImport();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: 15, right: 50),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5,
                                                offset: Offset(3, 3))
                                          ]),
                                      alignment: Alignment.center,
                                      width: Common.widthOfScreen / 3,
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 15,
                                          right: 15),
                                      child: Text(
                                        "Thêm",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  )
                                : Container(),
                            GestureDetector(
                              onTap: () {
//                                _presenter.createBillExport();
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          offset: Offset(3, 3))
                                    ]),
                                alignment: Alignment.center,
                                width: Common.widthOfScreen / 3,
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 15, right: 15),
                                child: Text(
                                  "Hủy",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          )),
    );
  }

  customItemButton(String lable, String value) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(BorderSide(
            color: Colors.grey, style: BorderStyle.solid, width: 0.5)),
        color: Colors.transparent,
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Text(
            lable,
            style: lableStyle(),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            width: Common.widthOfScreen / 3,
            padding: EdgeInsets.all(10),
            child: lable == "Chiết khấu:"
                ? _viewmodel.editEnable
                    ? TextField(
                        enabled: _viewmodel.editEnable,
                        onSubmitted: (value) {
                          chietKhauSubmitted(value);
                        },
                        controller: _viewmodel.chietKhauController,
                        keyboardType: TextInputType.number,
                        style: valueStyle(),
                        focusNode: _viewmodel.focusNodeChietKhau,
                        decoration: InputDecoration(
                          hintText: "0",
                        ),
                      )
                    : Text(
                        "${_viewmodel.chietKhau}",
                        style: valueStyle(),
                      )
                : Text(
                    value,
                    style: valueStyle(),
                  ),
          )
        ],
      ),
    );
  }

  void showBarcode() async {
    _presenter.showBarcode();
  }

  void searchSanPham(context) {
    _presenter.searchMerchandise(context);
  }

  lableStyle() {
    return TextStyle(fontSize: 17);
  }

  valueStyle() {
    return TextStyle(fontSize: 17, color: Colors.blue);
  }

  void tinhTongSo() {
    _presenter.calculateTotalMerchandises();
  }

  void tinhTongTien() {
    _presenter.calculateTotalPrice();
  }

  @override
  void updateUI(dynamic) {
    setState(() {});
    // TODO: implement updateUI
  }

  void chietKhauSubmitted(String value) {
    _presenter.chietKhauSubmitted(value);
    setState(() {});
  }

  @override
  void backView(String status) {
    // TODO: implement backView
    Navigator.of(this.context).pop(status);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _presenter ?? _presenter.onDispose();
  }
}
