
import 'package:fitee/cache/local_storage.dart';
import 'package:fitee/config/config.dart';
import 'package:fitee/model/search/search_db_table.dart';
import 'package:fitee/model/setting/setting_db_table.dart';
import 'package:fitee/pages/search/search_page.dart';
import 'package:fitee/plugin/auth/fingerprint_util.dart';
import 'package:fitee/theme/app_theme.dart';
import 'package:fitee/utils/nav_util.dart';
import 'package:fitee/utils/screen.dart';
import 'package:fitee/utils/utils.dart';
import 'package:fitee/widgets/top/app_bar_widget.dart';
import 'package:flutter/material.dart';

import 'login/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState()=> _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _hasDeleteIcon = false;
  String _inputText = "";
  List<String> history = new List<String>();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async{
    // 查看是否登录
    bool isLogin = await LocalStorage.getBool(AppConfig.LOGIN_KEY) ?? false;
    if(!isLogin){
      NavUtil.pushAndRemove(LoginPage(enableArrow: false));
    }
    _initHistory();
  }

  _initHistory() async {
    Set<String>  list = await SearchTable().query();
    setState(() {
      history = list.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController(text: _inputText);
    _searchController.selection = (
      TextSelection.fromPosition(TextPosition(offset: _searchController.text.length))
    );
    return Container(
      color: AppTheme.white,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppBarWidget(
              title: 'Fitee',
              callBack: () async {
                print(await LocalStorage.get(AppConfig.TOKEN_KEY));
                print("click homePage title right icon.");
              },
              icon: Icon(Icons.dashboard),
            ),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: duSetHeight(60),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[100],
                            offset: Offset(15, 4.0),
                            blurRadius: 16,
                            spreadRadius: .6
                          )
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            color: HexColor('#BEDCFD')
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: duSetWidth(10)),
                            Icon(Icons.search, color: Colors.white, size: duSetHeight(24)),
                            SizedBox(width: duSetWidth(10)),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: '输入关键字搜索仓库/用户...',
                                  hintStyle: TextStyle(
                                    fontSize: duSetFontSize(16),
                                    color: Colors.black45
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: _hasDeleteIcon
                                      ? new Container(
                                    width: 20.0,
                                    height: 20.0,
                                    child: new IconButton(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(0.0),
                                      iconSize: 18.0,
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        setState(() {
                                          _inputText = "";
                                          _hasDeleteIcon = (_inputText.isNotEmpty);
                                        });
                                      },
                                    ),
                                  ) : new Text(""),
                                ),
                                maxLines: 1,
                                textInputAction: TextInputAction.search,
                                style: TextStyle(
                                  fontSize: duSetFontSize(16)
                                ),
                                onSubmitted: (value) async {
                                  _forward(value, _searchController);
                                },
                                onChanged: (val) {
                                  setState(() {
                                    _inputText = val;
                                    _hasDeleteIcon = (_inputText.isNotEmpty);
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: duSetWidth(10))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: history.length > 0 ? Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: duSetHeight(15)),
                            _historyWidget(_searchController),
                            SizedBox(height: duSetHeight(10)),
                            GestureDetector(
                              child: Text('Clear All',
                                style: TextStyle(
                                  color: HexColor('#6FA0FB'),
                                  fontSize: duSetFontSize(18)
                                ),
                              ),
                              onTap: () async{
                                setState(() {
                                  history = new List<String>();
                                  _inputText = '';
                                });
                                _searchController.clear();
                                SearchTable().delete();
                              },
                            )
                          ],
                        ),
                      ) : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: duSetHeight(85)),
                          Image.asset('assets/logo.png', width: duSetWidth(110), height: duSetHeight(110)),
                          SizedBox(height: duSetHeight(15)),
                          Text(
                            'Fitee For 码云',
                            style: TextStyle(
                              fontSize: duSetFontSize(32),
                              color: Colors.black87,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: duSetHeight(30),),
          ]
      ),
    );
  }

  void _forward(String value, TextEditingController _searchController) {
    if(value != '') {
      SearchTable().insert(value);
      _searchController.clear();
      _initHistory();
      NavUtil.push(SearchPage(searchTxt: value));
    }
  }

  ///搜索历史
  Widget _historyWidget(TextEditingController _searchController) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: duSetWidth(20),),
              Text(
                "搜索历史",
                style: TextStyle(
                  color: AppTheme.nearlyBlack,
                  fontSize: duSetFontSize(18)
                ),
              )
            ],
          )),
        SizedBox(height: duSetHeight(10)),
        SingleChildScrollView(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(history.length, (index) {
              return InkWell(
                onTap: () {
                  _forward(history[index], _searchController);
                },
                child: Chip(
                  backgroundColor: HexColor('#6FA0FB'),
                  label: Text(history[index], style: TextStyle(
                    color: AppTheme.nearlyWhite,
                    fontSize: duSetFontSize(16)
                  )),
                  labelPadding: EdgeInsets.symmetric(horizontal: duSetWidth(18), vertical: duSetHeight(1)),
                ),
              );
            }),
          ),
        )
      ],
    );
  }

}