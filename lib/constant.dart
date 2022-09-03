import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/bean/bean.dart';
import 'package:train_client_flutter/util/store.dart';

class Constant {

  static Map<String, Station> stationIdMap = {};
  static Map<String, Station> stationNameMap = {};
  static List<Station> allStationList = [];

  static Map<String, String> seatIdToTypeMap = {};
  static Map<String, String> seatTypeToIdMap = {};
  static List<SeatType> allSeatTypeList = [];

  static Future<void> initStationInfo() async {
    allStationList = await DataApi.getAllStationList();
    if(allStationList.isNotEmpty){
      _initStationMap(allStationList);
    }
  }

  static Future<void> initSeatInfo() async {
    allSeatTypeList = await DataApi.getAllSeatMap();
    if(allSeatTypeList.isNotEmpty){
      _initSeatTypeMap(allSeatTypeList);
    }
  }

  static void _initStationMap(List<Station> stationList){
    for (var element in stationList) {
      stationIdMap[element.stationId] = element;
      stationNameMap[element.stationName] = element;
    }
    stationNameMap['未选择'] = Station.name(stationName: '未选择');
  }

  static void _initSeatTypeMap(List<SeatType> seatTypeList){
    for (var element in seatTypeList) {
      seatIdToTypeMap[element.seatTypeId] = element.seatTypeName;
      seatTypeToIdMap[element.seatTypeName] = element.seatTypeId;
    }
  }

  static void initCatchedStationSelect(){
    Store.set('from_station_name', '未选择');
    Store.set('to_station_name', '未选择');
  }

  static List hotStationIdList = ['BJP','CCT','CDW','CQW','CSQ','HBB','HZH','SHH','TJP'];
  // ["天津", "北京", "上海", "重庆", "长沙", "长春", "成都",
  // "福州", "广州", "贵阳", "呼和浩特", "哈尔滨", "合肥", "杭州",
  // "海口", "济南", "昆明", "兰州", "南宁", "南京",
  // "南昌", "沈阳", "石家庄", "太原", "武汉", "西宁",
  // "西安", "银川", "郑州", "深圳", "厦门", "无锡", "苏州", "常州",
  // "宁波", "南通", "青岛"]

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