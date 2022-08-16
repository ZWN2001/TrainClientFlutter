class IDUtil{
  static String getObscureID(String id){
    if(id == 'unKnown'){
      return id;
    }
    return id.replaceRange(4, id.length-4, '***********');
  }
}