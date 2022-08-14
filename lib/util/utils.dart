class IDUtil{
  static String getObscureID(String id){
    return id.replaceRange(4, id.length-4, '***********');
  }
}