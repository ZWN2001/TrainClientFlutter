import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/bean/bean.dart';

class Constant {

  static Map<String, Station> stationIdToNameMap = {};
  static Map<String, Station> stationNameToIdMap = {};
  static List<Station> allStationList = [];

  static Future<void> initStationInfo() async {
    allStationList = await DataApi.getAllStationList();
    if(allStationList.isNotEmpty){
      _initMap(allStationList);
    }
  }

  static void _initMap(List<Station> stationList){
    for (var element in stationList) {
      stationIdToNameMap[element.stationId] = element;
      stationNameToIdMap[element.stationName] = element;
    }
  }

  static List hotStationIdList = ['BJP','CCT','CDW','CQW','CSQ','HBB','HZH','SHH','TJP'];

  static List<String> hotelNameList = [
    "宝利精品酒店（北京首都三里屯店）",
    "喆·啡酒店（北京小红门店）",
    "喆·啡酒店（北京三里屯店）",
    "如家精选酒店",
    "如家酒店·neo",
    "喆·啡酒店（北京国贸店）",
    "麓枫酒店（北京天坛店）",
    "麓枫酒店（北京丽泽店）"
  ];

  static List<double> hotelMarks = [4.6,4.8,4.6,4.8,4.6,4.7,4.7,4.8];
  static List<int> price = [370,356,470,329,392,338,380,328];
  static List<int> originPrice = [729,370,530,379,408,359,380,328];
}