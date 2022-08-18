
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../bean/bean.dart';
import '../constant.dart';

class StationPage extends StatefulWidget {
  const StationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  List<Station> suggestions = [];
  late List<Station> stationList;
  double susItemHeight = 36;

  @override
  void initState() {
    super.initState();
    stationList = List.from(Constant.allStationList);
    stationList.sort((a, b) {
      return (a.abbr.compareTo(b.abbr));
    });
    // SuspensionUtil.sortListBySuspensionTag(stationList);
    //加个tag
    stationList.insert(
        0, Station.name(stationName: 'unKnown')..tagIndex = '★');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('车站选择'), centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size(300, 50),
          child: _buildFloatingSearchBar(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: AzListView(
              padding: const EdgeInsets.only(left: 24),
              data: stationList,
              itemCount: stationList.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) return _buildHeader();
                Station model = stationList[index];
                return ListTile(
                    title: Text(model.stationName),
                    onTap: () {
                      Get.back(result: model);
                    });
              },
              susItemHeight: susItemHeight,
              susItemBuilder: (BuildContext context, int index) {
                Station model = stationList[index];
                String tag = model.getSuspensionTag();
                if ('★' == tag) {
                  return Container();
                }
                return Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 40.0),
                  color: const Color(0xFFF3F4F5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tag,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF666666),
                    ),
                  ),
                );
              },
              indexBarAlignment: Alignment.centerRight,
              indexBarData:
              SuspensionUtil.getTagIndexList(stationList),
              indexBarOptions: const IndexBarOptions(
                needRebuild: true,
                color: Colors.transparent,
                downColor: Color(0xFFEEEEEE),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(height: 60,
        child: FloatingSearchBar(
          hint: '搜索拼音或城市',
          scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOut,
          physics: const BouncingScrollPhysics(),
          axisAlignment: isPortrait ? 0.0 : -1.0,
          openAxisAlignment: 0.0,
          // width: isPortrait ? 600 : 500,
          debounceDelay: const Duration(milliseconds: 500),
          onQueryChanged: (query) {
            suggestions.clear();
            for (var s in stationList) {
              if (s.stationName == 'unKonwn') {
                continue;
              }
              if (s.stationName.contains(query))  {
                suggestions.add(s);
              }
            }
            setState(() {});
          },
          transition: CircularFloatingSearchBarTransition(),
          actions: [
            FloatingSearchBarAction(
              showIfOpened: false,
              child: CircularButton(
                icon: const Icon(Icons.place),
                onPressed: () {
                  Get.back(result: Constant.stationIdToNameMap['JNK']);
                },
              ),
            ),
            FloatingSearchBarAction.searchToClear(
              showIfClosed: false,
            ),
          ],
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: suggestions
                      .map(
                        (e) => ListTile(
                      title: Text(e.stationName),
                      onTap: () {
                        Get.back(result: e);
                      },
                    ),
                  )
                      .toList(),
                ),
              ),
            );
          },
        ));
  }

  Widget _buildHeader() {
    List<Station> hotCityList = [];
    // hotCityList.addAll([
    //   Station.fromJson(stations['xuzhoudong']!.toJson())..tagIndex = '★',
    //   Station.fromJson(stations['jinanxi']!.toJson())..tagIndex = '★',
    //   Station.fromJson(stations['beijingnan']!.toJson())..tagIndex = '★',
    //   Station.fromJson(stations['beijing']!.toJson())..tagIndex = '★',
    //   Station.fromJson(stations['shanghai']!.toJson())..tagIndex = '★',
    // ]);
    hotCityList.addAll(Constant.hotStationIdList.map((e) => Station.fromJson(
        Constant.stationIdToNameMap[e]!.toJson())..tagIndex = '★'));
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: 10.0,
        children: hotCityList.map((e) {
          return OutlinedButton(
            style: const ButtonStyle(
              //side: BorderSide(color: Colors.grey[300], width: .5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(e.stationName),
            ),
            onPressed: () {
              Get.back(result: e..tagIndex = '');
            },
          );
        }).toList(),
      ),
    );
  }
}
