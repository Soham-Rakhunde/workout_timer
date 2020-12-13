String stringFormatter(String s){
  String a;
  a = s.toLowerCase();
  a = a[0].toUpperCase() + s.substring(1);
  return a;
}
