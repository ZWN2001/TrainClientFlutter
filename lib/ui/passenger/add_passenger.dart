import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:train_client_flutter/api/api.dart';
import 'package:train_client_flutter/bean/bean.dart';

import '../../util/string_util.dart';

class AddPassengerPage extends StatefulWidget{
  const AddPassengerPage({Key? key}) : super(key: key);
  static const routeName = '/passenger_add';

  @override
  State<StatefulWidget> createState() => AddPassengerState();
}

class AddPassengerState extends State<AddPassengerPage>{

  List<String> certificateTypes = ["中国居民身份证"];
  List<String> passengerRoles = ['成人','学生'];
  List<DropdownMenuItem<String>> _certificateTypeMenuItems = [];
  List<DropdownMenuItem<String>> _passengerRolesMenuItems = [];
  String _selectedCertificateType = "";
  String _selectedRole = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController certificateController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();

  String? nameErrorText;
  String? certificateErrorText;
  String? phoneNumErrorText;


  @override
  void initState() {
    super.initState();
    _selectedCertificateType = certificateTypes[0];
    _selectedRole = passengerRoles[0];
    _updateSubrouteMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('添加乘员信息'),
          actions: [
            TextButton(
                onPressed: _getRandomPassenger,
                child: const Text('随机生成',
                  style: TextStyle(color: Colors.white),))
          ],),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                child: Row(
                  children: const [
                    Text('基本信息', style: TextStyle(fontSize: 20),),
                    SizedBox(width: 8,),
                    Text('(用于身份核验，请务必正确填写)', style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              basicInfo(),
              const Padding(padding: EdgeInsets.all(12),
                child: Text('联系方式', style: TextStyle(fontSize: 20),),),
              Container(
                color: Colors.white,
                child: _phoneNumRow(),
              ),
              const SizedBox(height: 32,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 32,),
                  Expanded(child: ElevatedButton(onPressed: _submit,
                      child: const Padding(padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
                        child: Text('提交',style: TextStyle(fontSize: 18),),))),
                  const SizedBox(width: 32,),
                ],),
              const SizedBox(height: 16,),
              const Padding(padding: EdgeInsets.all(12),
                child: Text('温馨提示：',style: TextStyle(fontSize: 15),),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
                child: Text(tips,style: const TextStyle(fontSize: 15, color: Colors.grey),),
              ),
            ],
          ),
        )
    );
  }

  Widget basicInfo(){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _certificateTypesRow(),
          const Divider(),
          _roleRow(),
          const Divider(),
          _nameRow(),
          const Divider(),
          _certificateRow()
        ],
      ),
    );
  }

  Widget _certificateTypesRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        children: [
          const Expanded(flex:2, child: Text('证件类型:', style: TextStyle(fontSize: 16),)),
          Expanded(flex:5, child: _certificateTypesSelector())
        ],
      ),
    );
  }

  Widget _roleRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        children: [
          const Expanded(flex:2, child: Text('乘员类型:', style: TextStyle(fontSize: 16),)),
          Expanded(flex:5, child: _passengerRoleSelector())
        ],
      ),
    );
  }

  Widget _nameRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: [
          const Expanded(flex: 2, child: Padding(
            padding: EdgeInsets.only(bottom: 16,),
            child: Text('姓    名:', style: TextStyle(fontSize: 16),),)),
          Expanded(flex: 5, child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "请输入真实姓名，以方便购票",
              contentPadding: const EdgeInsets.all(4),
              isDense: true,
              hintStyle: const TextStyle(color: Colors.grey,textBaseline: TextBaseline.ideographic,),
              helperText: '',
              errorText: nameErrorText,
              errorStyle: const TextStyle(color: Colors.red),
            ),
          ))
        ],
      ),
    );
  }

  Widget _certificateRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: [
          const Expanded(flex: 2, child: Padding(
            padding: EdgeInsets.only(bottom: 16,),
            child: Text('证件号码:', style: TextStyle(fontSize: 16),),)),
          Expanded(flex: 5, child: TextField(
            controller: certificateController,
            decoration: InputDecoration(
              hintText: "用于身份核验，请正确填写",
              contentPadding: const EdgeInsets.all(4),
              isDense: true,
              hintStyle: const TextStyle(color: Colors.grey,textBaseline: TextBaseline.ideographic,),
              helperText: '',
              errorText: certificateErrorText,
              errorStyle: const TextStyle(color: Colors.red),
            ),
          ))
        ],
      ),
    );
  }

  Widget _phoneNumRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: [
          const Expanded(flex: 2, child: Padding(
            padding: EdgeInsets.only(bottom: 16,),
            child: Text('手机号码:', style: TextStyle(fontSize: 16),),)),
          Expanded(flex: 5, child: TextField(
            controller: phoneNumController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "请准确填写乘车人手机号码",
              contentPadding: const EdgeInsets.all(4),
              isDense: true,
              hintStyle: const TextStyle(color: Colors.grey,textBaseline: TextBaseline.ideographic,),
              helperText: '',
              errorText: phoneNumErrorText,
              errorStyle: const TextStyle(color: Colors.red),
            ),
          ))
        ],
      ),
    );
  }

  Widget _certificateTypesSelector() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: _certificateTypeMenuItems,
        value: _selectedCertificateType,
        selectedItemBuilder: (BuildContext context) {
          return certificateTypes.map<Widget>((String routeName) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                routeName,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            );
          }).toList();
        },
        iconEnabledColor: Colors.black,
        onChanged: (newValue) {
          setState(() {
            _selectedCertificateType = newValue.toString();
          });
        },
      ),
    );
  }

  Widget _passengerRoleSelector() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: _passengerRolesMenuItems,
        value: _selectedRole,
        selectedItemBuilder: (BuildContext context) {
          return passengerRoles.map<Widget>((String routeName) {
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                routeName,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            );
          }).toList();
        },
        iconEnabledColor: Colors.black,
        onChanged: (newValue) {
          setState(() {
            _selectedRole = newValue.toString();
          });
        },
      ),
    );
  }

  void _updateSubrouteMenuItems() {
    _certificateTypeMenuItems =
        certificateTypes.map<DropdownMenuItem<String>>((String routeName) {
          return DropdownMenuItem(
            value: routeName,
            child: Text(
              routeName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: _selectedCertificateType == routeName
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList();

    _passengerRolesMenuItems =
        passengerRoles.map<DropdownMenuItem<String>>((String routeName) {
          return DropdownMenuItem(
            value: routeName,
            child: Text(
              routeName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: _selectedRole == routeName
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList();
  }

  Future<void> _submit() async {
    if(nameController.text.length < 2 || nameController.text.length > 8 ||
        !StringUtil.allChinese(nameController.text)){
      if(mounted){
        setState((){
          nameErrorText = '姓名不合法';
        });
      }
    }else{
      if(mounted){
        setState((){
          nameErrorText = null;
        });
      }
    }

    if(!StringUtil.verifyCardId(certificateController.text)){
      if(mounted){
        setState((){
          certificateErrorText = '身份证不合法';
        });
      }
    }else{
      if(mounted){
        setState((){
          certificateErrorText = null;
        });
      }
    }

    if(!StringUtil.phoneNumLegal(phoneNumController.text)){
      if(mounted){
        setState((){
          phoneNumErrorText = '手机号非法';
        });
      }
    }else{
      if(mounted){
        setState((){
          phoneNumErrorText = null;
        });
      }
    }

    if(nameErrorText == null && certificateErrorText == null && phoneNumErrorText == null){
      Passenger passenger = Passenger();
      passenger.role = _selectedRole == '成人'? 'common' : 'student';
      passenger.passengerName = nameController.text;
      passenger.passengerId = certificateController.text;
      passenger.phoneNum = phoneNumController.text;
      passenger.userId = UserApi.getUserId()!;
      ResultEntity resultEntity = await PassengerApi.addPassenger(passenger);
      if(resultEntity.result){
        Get.back(result: passenger);
      }
      Fluttertoast.showToast(msg: resultEntity.message);
    }
  }

  Future<void> _getRandomPassenger() async {
    ResultEntity resultEntity = await PassengerApi.randomPassenger();
    if(resultEntity.result){
      Passenger passenger = Passenger.fromJson(resultEntity.data);
      _selectedRole = passenger.role == 'common'? '成人':'学生';
      nameController.text = passenger.passengerName;
      certificateController.text = passenger.passengerId;
      phoneNumController.text = passenger.phoneNum;
      setState((){});
    }else{
      Fluttertoast.showToast(msg: resultEntity.message);
    }
  }

  String tips = '1．为配合做好新冠疫情常态化防控工作，同时便于乘车人及时接收到车运行'
      '变更信息，购票时需登记每名乘车旅客中国大陆手机号码，请惩提前填报并通知乘车人协'
      '助完戌手机号码核验。对于未成年人、老年人等重点旅客以及无手机的旅客，可提供监护'
      '人或能及时联系的亲友手机号码。铁路部门将依法保护旅客个人信息安全。\n'
      '2．互联网售票实行实名制，请准确填写乘车人基本信息。\n3如旅客身份信息未能在添加后的24'
      '小时内通过核验，请乘车人持有效身份证件原件到车站办理身份核验。\n'
      '4．联系方式仅用于配合疫情常态化防控工作及通知到车运行变更信息，铁貉部门将采取相应措'
      '施保护您的个人隐私信息安全。';
}