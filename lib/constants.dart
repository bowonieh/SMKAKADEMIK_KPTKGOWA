class constantsApi{
  static const String baseUrl = 'http://203.175.11.144/';
  //===========Login dan Register
  static const String login = 'indexapi/login';
  static const String register = 'indexapi/apiregister';
  //Dashboard Api
  static const String countSiswa = 'dashboardapi/countsiswa';
  static const String countSiswaByJenkel = 'dashboardapi/countjenkel';
  static const String countSiswaByKota = 'dashboardapi/countsiswabykota';
  static const String countSiswaByYear = 'dashboardapi/countsiswabyyear';
  //===account 
  static const String accountInfo = 'account/getaccount';
  //===Siswa
  static const String siswaList = 'siswaapi/apilist?search=';
  static const String siswaAdd = 'siswaapi/apiadd';
  static const String siswaEdit = 'siswaapi/apiedit/';
  static const String siswaHapus = 'siswaapi/apidelete/';
  //===kota
  static const String kotaList = 'kotaapi/apilist';
  static const String kotaAdd = 'kotaapi/apiadd';
  //====================
  static const String versiApp = '1';
  static const String versiAppDetil = '1.0.0';
  static const String namaInstansi = 'PT. Universal Big Data (UBIG)';

}