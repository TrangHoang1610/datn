import 'package:flutter/material.dart';
import 'package:init_app/common/Common.dart';
import 'package:init_app/ui/homepage/HomePageViewModel.dart';
import 'package:init_app/utils/BlogEvent.dart';

// ignore: must_be_immutable
class FillDate extends StatelessWidget {
  var title, fromDate, toDate;
  var data;
  HomePageViewModel _viewModel;
  var onClickFromDate;
  var onClickToDate;

  FillDate(this.data, this._viewModel,
      {this.onClickFromDate, this.onClickToDate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        width: Common.widthOfScreen - 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      alignment: Alignment.center,
                      child: Text(
                        "Trong khoảng",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      alignment: Alignment.centerLeft,
                      child: data is BlocLoading
                          ? Text("")
                          : data is BlocLoaded
                              ? TextDate(
                                  Common.DATE_FORMAT(_viewModel.firstDay),
                                  Common.DATE_FORMAT(_viewModel.endDay))
                              : Text(
                                  "${Common.DATE_FORMAT(_viewModel.firstDay)}   -   ${Common.DATE_FORMAT(_viewModel.endDay)}",
                                  style: TextStyle(fontSize: 13),
                                ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextDate(String date_format, String date_format2) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (onClickFromDate != null) {
                onClickFromDate();
              }
            },
            child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.date_range),
                    Text(
                      "${date_format}",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                )),
          ),
          Container(
            child: Text("-"),
          ),
          GestureDetector(
            onTap: () {
              if (onClickToDate != null) {
                onClickToDate();
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.date_range),
                  Text(
                    "${date_format2}",
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
