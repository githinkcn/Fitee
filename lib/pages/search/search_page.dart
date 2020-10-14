import 'package:fitee/config/config.dart';
import 'package:fitee/plugin/toast.dart';
import 'package:fitee/theme/app_theme.dart';
import 'package:fitee/utils/nav_util.dart';
import 'package:fitee/utils/screen.dart';
import 'package:fitee/utils/utils.dart';
import 'package:fitee/widgets/dashes_separator.dart';
import 'package:fitee/widgets/picker/picker_tool.dart';
import 'package:fitee/widgets/top/app_bar_widget.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {

  String searchTxt;

  SearchPage({Key key, @required this.searchTxt}): super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {

  TabController _controller;

  AnimationController _animationController;
  Animation<Color> _animation;

  int tabIndex = 0;
  int page = 1;

  String descTxt = '最佳匹配';
  String languageTxt = 'All';

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: ScrollableState(),
    );
    _controller.addListener(() {
      setState(() {
        tabIndex = _controller.index;
        page = 1;
        _initData();
      });
    });

    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);

    _animation = Tween<Color>(begin: AppTheme.dismissibleBackground.withOpacity(.3), end: AppTheme.dismissibleBackground)
        .animate(_animationController);

  }

  _initData() async {
    if(tabIndex == 0) {

    }else {

    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppBarWidget(
            title: widget.searchTxt,
            back: true,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: TabBar(
                        controller: _controller,
                        labelColor: AppTheme.darkText,
                        unselectedLabelColor: AppTheme.descText,
                        indicatorColor: Colors.transparent,
                        indicatorWeight: duSetHeight(1.0),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                        unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.w400
                        ),
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                //Tab(icon: Icon(Icons.local_florist)),
                                Image.asset("assets/icon/repository.png", width: duSetWidth(21), height: duSetHeight(21),
                                  color: tabIndex == 0 ? HexColor('#171717') : AppTheme.descText,
                                ),
                                const SizedBox(width: 12,),
                                Text('Repos',
                                  style: TextStyle(
                                      fontSize: duSetFontSize(18),
                                      fontWeight: FontWeight.w400
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("assets/icon/my_feed.png", width: duSetWidth(21), height: duSetHeight(21),
                                  color: tabIndex == 1 ? HexColor('#171717') : AppTheme.descText,
                                ),
                                const SizedBox(width: 12,),
                                Text('Users',
                                  style: TextStyle(
                                      fontSize: duSetFontSize(18),
                                      fontWeight: FontWeight.w400
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: TabBarView(
                          controller: _controller,
                          children: <Widget>[
                            Container(
                              child: Center(
                                child: Image.asset("assets/icon/repository.png", width: duSetWidth(100), height: duSetHeight(100)),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Image.asset("assets/icon/my_feed.png", width: duSetWidth(100), height: duSetHeight(100)),
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
                Positioned(
                  width: MediaQuery.of(context).size.width - duSetWidth(72),
                  bottom: MediaQuery.of(context).padding.bottom + 40,
                  left: MediaQuery.of(context).size.width * 0.1,
                  child: GestureDetector(
                    child: Container(
                      height: duSetHeight(40),
                      padding: EdgeInsets.symmetric(horizontal: duSetWidth(36)),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            color: HexColor('#BEDCFD')
                        ),
                        child: Center(
                          child: Text(
                            descTxt + ' & ' + languageTxt,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: duSetFontSize(18)
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: (){
                      //_openSearchPicker(context: context);
                      _openSearchSheet(context);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  _openSearchPicker({@required BuildContext context}) {
    PickerTool.showArrayPicker(context,
      title: '',
      data: AppConfig.SEARCH_DATA,
      clickCallBack: (var index, var strData){
        print(index);
        print(strData);
      });
  }

  _openSearchSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setBottomState) {
            return AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              child: Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height / 1.9,
                    maxHeight: MediaQuery.of(context).size.height / 1.9
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),color: Colors.white
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: duSetHeight(60),
                      child: Center(
                        child: Text(descTxt + ' & ' + languageTxt,
                          style: TextStyle(
                              color: AppTheme.darkText,
                              fontSize: duSetFontSize(18.0),
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                    DashesSeparator(color: Colors.grey[300].withOpacity(.8)),
                    SizedBox(height: duSetHeight(6)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _itemWidget(context, title: AppConfig.SEARCH_DATA[0][index], index: index,
                                    callBack: (title) {
                                      setBottomState((){
                                        descTxt = title;
                                      });
                                      setState(() {
                                        descTxt = title;
                                      });
                                    }
                                  );
                                },
                                itemCount: AppConfig.SEARCH_DATA[0].length,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _itemWidget(context, title: AppConfig.SEARCH_DATA[1][index], index: index,
                                    callBack: (title) {
                                      setBottomState((){
                                        languageTxt = title;
                                      });
                                      setState(() {
                                        languageTxt = title;
                                      });
                                    }
                                  );
                                },
                                itemCount: AppConfig.SEARCH_DATA[1].length,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: duSetHeight(MediaQuery.of(context).padding.bottom)),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget _itemWidget(BuildContext context, {@required String title, int index, Function callBack}){
    return Column(
      children: [
        GestureDetector(
          child: Container(
            height: duSetHeight(50),
            child: Center(
              child: Text(title,
                style: TextStyle(
                    fontSize: duSetFontSize(18),
                    color: AppTheme.darkText
                ),
              ),
            ),
          ),
          onTap: (){
            callBack(title);
          },
        )
        //index != (AppConfig.SEARCH_DATA[0].length -1) ? _divider() : SizedBox(),
      ],
    );
  }

  Widget _divider() {
    return Divider(
      height: 1.2,
      indent: 12,
      endIndent: 12,
      thickness: 1,
      color: Colors.grey.withOpacity(.15),
    );
  }
}