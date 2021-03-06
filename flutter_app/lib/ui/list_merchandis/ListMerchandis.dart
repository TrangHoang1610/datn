import 'package:flutter/material.dart';
import 'package:init_app/common/Common.dart';
import 'package:init_app/ui/list_merchandis/ListMerchandisView.dart';
import 'package:init_app/utils/BlogEvent.dart';
import 'package:init_app/utils/IntentAnimation.dart';

import 'ListMerchandisPresenter.dart';
import 'ListMerchandisViewModel.dart';

class ListMerchandis extends StatefulWidget {
  @override
  _ListMerchandisState createState() => _ListMerchandisState();
}

class _ListMerchandisState extends State<ListMerchandis>
    implements ListMerchandisView {
  var isLoading = false;
  ListMerchandisViewModel _viewModel;
  ListMerchandisPresenter _presenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = new ListMerchandisViewModel();
    _presenter = new ListMerchandisPresenter(_viewModel);
    _presenter.intiView(this);
    _presenter.getData();
    _presenter.getMerchandise();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _presenter.onDispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _viewModel.scaffState,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            IntentAnimation.intentBack(context: context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 17,
            color: Colors.white,
          ),
        ),
        title: Text("Danh sách sản phẩm"),
        centerTitle: true,
        actions: <Widget>[
          Visibility(
            visible: Common.user["idRole"] == 2,
            child: IconButton(
              onPressed: () {
                addMerchandise(context);
              },
              icon: Icon(
                Icons.add,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _presenter.showScanBarCode(context);
            },
            icon: Icon(
              Icons.flip,
              size: 25,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: _presenter.getStream(ListMerchandisPresenter.CATEGORY),
          builder: (ctx, snap) => snap.data is BlocLoading
              ? Container(
                  alignment: Alignment.center,
                  width: Common.widthOfScreen,
                  height: Common.heightOfScreen,
                  color: Colors.white,
                  child: Image.asset(
                    "assets/icons/loading.gif",
                    width: 30,
                    height: 30,
                  ))
              : Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: ListView.builder(
                          itemBuilder: (ctx, index) => categoryItem(index),
                          itemCount: _viewModel.categories.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.grey,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                      ),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            ListView.builder(
                              itemBuilder: (ctx, index) =>
                                  merchandisItem(index),
                              itemCount:
                                  _viewModel.selectedListMerchandise.length,
                              scrollDirection: Axis.vertical,
                            ),
                            Visibility(
                              visible:
                                  _viewModel.selectedListMerchandise.length ==
                                      0,
                              child: Container(
                                  height: Common.heightOfScreen,
                                  width: Common.widthOfScreen,
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: Common.user["idRole"] == 2
                                      ? GestureDetector(
                                          onTap: () {
                                            addMerchandise(context);
                                          },
                                          child: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  height:
                                                      Common.heightOfScreen / 5,
                                                  child: Image.asset(
                                                      "assets/icons/add_merchandis.png"),
                                                ),
                                                Text(
                                                  "Loại hàng này chưa có hàng\n Click để thêm...",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                height:
                                                    Common.heightOfScreen / 5,
                                                child: Image.asset(
                                                    "assets/icons/empty.png"),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Loại hàng này không có hàng",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                        )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
    );
  }

  categoryItem(int index) {
    return GestureDetector(
      onTap: () {
        selectCategory(index);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        color: _viewModel.categories[index]["selected"]
            ? Colors.blue
            : Colors.white,
        child: Container(
          alignment: Alignment.center,
          height: 20,
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Text(
            "${_viewModel.categories[index]["nameCategory"]}",
            style: TextStyle(
                color: _viewModel.categories[index]["selected"]
                    ? Colors.white
                    : Colors.blue,
                fontSize: 15),
          ),
        ),
      ),
    );
  }

  merchandisItem(int index) {
    return GestureDetector(
      onTap: () {
        _presenter.merchandiseDetail(context, index);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Container(
          height: 90,
          color: Colors.transparent,
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 7, offset: Offset(4, 4))
                  ],
                ),
                child: _viewModel.selectedListMerchandise[index]["image"] != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage.assetNetwork(
                          image: Common.rootUrl +
                              _viewModel.selectedListMerchandise[index]
                                  ["image"],
                          placeholder: "assets/images/default_image.png",
                          fit: BoxFit.cover,
                          height: Common.heightOfScreen / 10,
                          width: Common.heightOfScreen / 10,
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          "assets/images/default_image.png",
                          height: Common.heightOfScreen / 10,
                          width: Common.heightOfScreen / 10,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "${_viewModel.selectedListMerchandise[index]["nameMerchandise"]}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w400),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Số lượng: ",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            "${_viewModel.selectedListMerchandise[index]["count"]}",
                            style: TextStyle(fontSize: 11, color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/icons/in_price.png",
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  "${Common.CURRENCY_FORMAT.format(_viewModel.selectedListMerchandise[index]["inputPrice"])} VND",
                                  style: textItemPriceMerchandise(),
                                )
                              ],
                            ),
                          ),
//                          SizedBox(
//                            width: 50,
//                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  "assets/icons/out_price.png",
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.fill,
                                ),
                                Text(
                                  "${Common.CURRENCY_FORMAT.format(_viewModel.selectedListMerchandise[index]["outputPrice"])} VND",
                                  style: textItemPriceMerchandise(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Container(
                  child: Icon(
                    Icons.navigate_next,
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void themSanPham() {}

  @override
  void updateUI(dynamic) {
    print("okok UPDATE UI");
    setState(() {});
    // TODO: implement updateUI
  }

  void selectCategory(int index) {
    _viewModel.categories.every((element) {
      element["selected"] = false;
      return true;
    });
    _viewModel.categories[index]["selected"] = true;
    _viewModel.selectedCategory = _viewModel.categories[index];
    _viewModel.selectedListMerchandise = _viewModel.merchandises
        .where((element) =>
            element["idCategory"] ==
                _viewModel.selectedCategory["idCategory"] &&
            element["status"] == 1)
        .toList();
    setState(() {});
  }

  void addMerchandise(context) {
    _presenter.addMerchandise(context);
  }

  textItemPriceMerchandise() {
    return TextStyle(fontSize: 11, color: Colors.black45);
  }
}
