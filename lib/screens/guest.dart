import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:land_registration/providers/LandRegisterModel.dart';
import 'package:land_registration/constant/loadingScreen.dart';
import 'package:land_registration/screens/ChooseLandMap.dart';
import 'package:land_registration/screens/viewLandDetails.dart';
import 'package:land_registration/widget/land_container.dart';
import 'package:land_registration/widget/menu_item_tile.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:provider/provider.dart';
import '../providers/MetamaskProvider.dart';
import '../constant/constants.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import '../constant/utils.dart';

class UserDashBoard extends StatefulWidget {
  const UserDashBoard({Key? key}) : super(key: key);

  @override
  _UserDashBoardState createState() => _UserDashBoardState();
}

class _UserDashBoardState extends State<UserDashBoard> {
  var model, model2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int screen = 0;
  late List<dynamic> userInfo;
  bool isLoading = true, isUserVerified = false;
  bool isUpdated = true;
  List<List<dynamic>> LandGall = [];
  String name = "";

  final _formKey = GlobalKey<FormState>();
  late String area,
      landAddress,
      landPrice,
      propertyID,
      surveyNo,
      document,
      allLatiLongi;
  List<List<dynamic>> landInfo = [];
  List<List<dynamic>> receivedRequestInfo = [];
  List<List<dynamic>> sentRequestInfo = [];
  List<dynamic> prices = [];
  List<Menu> menuItems = [
    //Menu(title: 'Dashboard', icon: Icons.dashboard),
    //Menu(title: 'Add Lands', icon: Icons.add_chart),
    //Menu(title: 'My Lands', icon: Icons.landscape_rounded),
    Menu(title: 'Land Gallery', icon: Icons.landscape_rounded),
    //Menu(title: 'My Received Request', icon: Icons.request_page_outlined),
    //Menu(title: 'My Sent Land Request', icon: Icons.request_page_outlined),
    //Menu(title: 'Logout', icon: Icons.logout),
  ];
  Map<String, String> requestStatus = {
    '0': 'Pending',
    '1': 'Accepted',
    '2': 'Rejected',
    '3': 'Payment Done',
    '4': 'Completed'
  };

  List<MapBoxPlace> predictions = [];
  late PlacesSearch placesSearch;
  final FocusNode _focusNode = FocusNode();
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TextEditingController addressController = TextEditingController();

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => Positioned(
              width: 540,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(0.0, 40 + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: List.generate(
                        predictions.length,
                        (index) => ListTile(
                              title:
                                  Text(predictions[index].placeName.toString()),
                              onTap: () {
                                addressController.text =
                                    predictions[index].placeName.toString();

                                setState(() {});
                                _overlayEntry.remove();
                                _overlayEntry.dispose();
                              },
                            )),
                  ),
                ),
              ),
            ));
  }

  Future<void> autocomplete(value) async {
    List<MapBoxPlace>? res = await placesSearch.getPlaces(value);
    if (res != null) predictions = res;
    setState(() {});
    // print(res);
    // print(res![0].placeName);
    // print(res![0].geometry!.coordinates);
    // print(res![0]);
  }

  @override
  void initState() {
    placesSearch = PlacesSearch(
      apiKey: mapBoxApiKey,
      limit: 10,
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)!.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
    super.initState();
  }

  getLandInfo() async {
    setState(() {
      landInfo = [];
      isLoading = true;
    });
    List<dynamic> landList;
    if (!connectedWithMetamask) {
      landList = await model2.myAllLands();
    } else {
      landList = await model.myAllLands();
    }

    List<List<dynamic>> info = [];
    List<dynamic> temp;
    for (int i = 0; i < landList.length; i++) {
      if (!connectedWithMetamask) {
        temp = await model2.landInfo(landList[i]);
      } else {
        temp = await model.landInfo(landList[i]);
      }
      landInfo.add(temp);
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  getLandGallery() async {
    setState(() {
      isLoading = true;
      LandGall = [];
    });
    List<dynamic> landList;
    if (!connectedWithMetamask) {
      landList = await model2.allLandList();
    } else {
      landList = await model.allLandList();
    }

    // List<List<dynamic>> allInfo = [];
    List<dynamic> temp;
    for (int i = 0; i < landList.length; i++) {
      if (!connectedWithMetamask) {
        temp = await model2.landInfo(landList[i]);
      } else {
        temp = await model.landInfo(landList[i]);
      }
      LandGall.add(temp);
      setState(() {
        isLoading = false;
      });
    }
   // screen = 3;
    isLoading = false;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    model = Provider.of<LandRegisterModel>(context);
    model2 = Provider.of<MetaMaskProvider>(context);
    if (isUpdated) {
      getProfileInfo();
      isUpdated = false;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF272D34),
        leading: isDesktop
            ? Container()
            : GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ), //AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: _animationController,),
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
        title: const Text('User Dashboard'),
      ),
      drawer: drawer2(),
      drawerScrimColor: Colors.transparent,
      body: Row(
        children: [
          isDesktop ? drawer2() : Container(),
          // if (screen == 0)
          //   userProfile()
          // else if (screen == 1)
          //   addLand()
          // else if (screen == 2)
          //   myLands()
          if (screen == 3)
            landGallery()
          else if (screen == 4)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: receivedRequest(),
              ),
            )
          else if (screen == 5)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: sentRequest(),
              ),
            )
        ],
      ),
    );
  }
  Widget landGallery() {
    if (isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (LandGall.isEmpty) {
      return const Expanded(
          child: Center(
              child: Text(
        'No Lands Added yet',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
      )));
    }
    return Expanded(
      child: Center(
        child: SizedBox(
          width: isDesktop ? 900 : width,
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 440,
                crossAxisCount: isDesktop ? 2 : 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: LandGall.length,
            itemBuilder: (context, index) {
              return landWid2(
                  LandGall[index][10],
                  LandGall[index][1].toString(),
                  LandGall[index][2].toString(),
                  LandGall[index][3].toString(),
                  LandGall[index][9] == userInfo[0],
                  LandGall[index][8], () async {
                if (isUserVerified) {
                  SmartDialog.showLoading();
                  try {
                    if (!connectedWithMetamask) {
                      await model2.sendRequestToBuy(LandGall[index][0]);
                    } else {
                      await model.sendRequestToBuy(LandGall[index][0]);
                    }
                    showToast("Request sent",
                        context: context, backgroundColor: Colors.green);
                  } catch (e) {
                    print(e);
                    showToast("Something Went Wrong",
                        context: context, backgroundColor: Colors.red);
                  }
                  SmartDialog.dismiss();
                } else {
                  showToast("You are not verified",
                      context: context, backgroundColor: Colors.red);
                }
              }, () {
                List<String> allLatiLongi =
                    LandGall[index][4].toString().split('|');

                LandInfo landinfo = LandInfo(
                    LandGall[index][1].toString(),
                    LandGall[index][2].toString(),
                    LandGall[index][3].toString(),
                    LandGall[index][5].toString(),
                    LandGall[index][6].toString(),
                    LandGall[index][7].toString(),
                    LandGall[index][8],
                    LandGall[index][9].toString(),
                    LandGall[index][10]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => viewLandDetails(
                              allLatitude: allLatiLongi[0],
                              allLongitude: allLatiLongi[1],
                              landinfo: landinfo,
                            )));
              });
            },
          ),
        ),
      ),
    );
  }
  Widget drawer2() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)
        ],
        color: Color(0xFF272D34),
      ),
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.person,
            size: 50,
          ),
          const SizedBox(
            width: 30,
          ),
          Text(name,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 80,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, counter) {
                return const Divider(
                  height: 2,
                );
              },
              itemCount: menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                return MenuItemTile(
                  title: menuItems[index].title,
                  icon: menuItems[index].icon,
                  isSelected: screen == index,
                  onTap: () {
                    if (index == 6) {
                      Navigator.pop(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const home_page()));
                      Navigator.of(context).pushNamed(
                        '/',
                      );
                    }
                    if (index == 2) getLandInfo();
                    if (index == 3) getLandGallery();
                    if (index == 4) getMyReceivedRequest();
                    if (index == 5) getMySentRequest();
                    setState(() {
                      screen = index;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}