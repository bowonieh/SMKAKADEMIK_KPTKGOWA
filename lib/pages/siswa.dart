import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kptkfrontendluring/pages/dashboard_screen.dart';
import 'package:kptkfrontendluring/pages/siswa_edit.dart';
import 'package:kptkfrontendluring/pages/siswa_tambah.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Siswa extends StatefulWidget {
  const Siswa({super.key});

  @override
  State<Siswa> createState() => _SiswaState();
}

class SiswaData {
  final int id;
  final String nama;
  final String nis;
  final String alamat;
  final String tgl_lahir;
  final int jenkel;
  final int kotaid;
  final String nmKota;

  SiswaData(
      {required this.id,
      required this.nama,
      required this.nis,
      required this.alamat,
      required this.tgl_lahir,
      required this.jenkel,
      required this.kotaid,
      required this.nmKota});

  factory SiswaData.fromJson(Map<String, dynamic> json) {
    return SiswaData(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'],
      nis: json['nis'],
      alamat: json['alamat'],
      tgl_lahir: json['tgl_lahir'],
      jenkel: int.tryParse(json['jenkel'].toString()) ?? 0,
      kotaid: int.tryParse(json['kota_id'].toString()) ?? 0,
      nmKota: json['nm_kota'] == null ? "" : json["nm_kota"],
    );
  }
}

class _SiswaState extends State<Siswa> {
  final TextEditingController searchController = TextEditingController();
  List<SiswaData> searchData = [];
  Widget loadingListView = const Center(
    child: CircularProgressIndicator(),
  );

  @override
  void initState() {
    super.initState();
    fetchDataSiswa("");
  }

  void fetchDataSiswa(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('tokenJwt') ?? '';

    setState(() {
      loadingListView = const Center(
        child: CircularProgressIndicator(),
      );
    });

    try {
      final response = await http.get(
        Uri.parse(
            "http://203.175.11.144/siswaapi/apilist?search=$query"),
        headers: {
          'Cookie': token,
        },
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decodedData = jsonDecode(response.body);

        if (decodedData is List) {
          List<SiswaData> newDataList =
              decodedData.map((item) => SiswaData.fromJson(item)).toList();
          if (mounted) {
            setState(() {
              searchData = newDataList;
              if (newDataList.isEmpty) {
                Get.snackbar(
                  'Kosong',
                  "Siswa tersebut tidak ada",
                  colorText: Colors.white,
                  backgroundColor: Colors.orange,
                  icon: const Icon(Icons.add_alert),
                );
                loadingListView = ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      color: const Color(0xff3b57e6),
                      shadowColor: const Color(0x4d939393),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color(0x4d9e9e9e), width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Siswa tidak ditemukan",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xffffffff),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffffffff),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                loadingListView = ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final jenkel = searchData[index].jenkel;
                    // searchData.sort((a, b) => a.nama.compareTo(b.nama));

                    return GestureDetector(
                      onTap: () {
                        Get.to(()=>
                          SiswaEdit(
                           Id: searchData[index].id,
                           Nama: searchData[index].nama,
                           Nis: searchData[index].nis,
                           Alamat: searchData[index].alamat,
                           tgl_lahir: searchData[index].tgl_lahir,
                           jenkel: searchData[index].jenkel,
                           kota_id: searchData[index].kotaid,
                           nmKota: searchData[index].nmKota,
                        ));
                      },
                      child: Card(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        color: const Color(0xff3b57e6),
                        shadowColor: const Color(0x4d939393),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              color: Color(0x4d9e9e9e), width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                jenkel == 1 ? Icons.male : Icons.female,
                                color: jenkel == 1 ? Colors.white : Colors.red,
                                size: 24,
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        searchData[index].nama,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 4, 0, 0),
                                        child: Text(
                                          searchData[index].nis,
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        searchData[index].nmKota,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xffffffff),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: searchData.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                );
              }
            });
          }
        } else {
          Get.snackbar(
            'Gagal mencari data',
            "Invalid Data Format",
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add_alert),
          );
        }
      } else {
        Get.snackbar(
          'Gagal mencari data',
          "Error ${response.reasonPhrase}",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.add_alert),
        );
      }
    } catch (e) {
      if (e
          .toString()
          .contains("Connection closed before full header was received")) {
        // Handle the specific error condition here
        // You can add custom handling logic for this case
        Get.snackbar(
          'Gagal meload data',
          "Error:{$e} Connection closed before full header was received",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.add_alert),
        );
      }
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff3b58ec),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Siswa",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 22,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.to(const DashboardScreen());
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () {
                  //Get.to(SiswaTambah());
                },
                child: Icon(
                  Icons.add_circle,
                  color: Color(0xffffffff),
                  size: 24,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: TextField(
                  controller: searchController,
                  obscureText: false,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  onSubmitted: (value) {
                    var query = searchController.text;
                    fetchDataSiswa(query);
                  },
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Color(0xffa9aec3), width: 1),
                    ),
                    hintText: "Pencarian",
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xffabb0c4),
                    ),
                    filled: true,
                    fillColor: const Color(0xffeef1f5),
                    isDense: false,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 24,
                      ),
                      onPressed: () {
                        var query = searchController.text;
                        fetchDataSiswa(query);
                      },
                      color: const Color(0xffa9aec2),
                    ),
                  ),
                ),
              ),
              loadingListView,
              // ListView(
              //   scrollDirection: Axis.vertical,
              //   padding: const EdgeInsets.all(0),
              //   shrinkWrap: true,
              //   physics: const ScrollPhysics(),
              //   children: [
              //     Card(
              //       margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              //       color: const Color(0xff3b57e6),
              //       shadowColor: const Color(0x4d939393),
              //       elevation: 1,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //         side:
              //             const BorderSide(color: Color(0x4d9e9e9e), width: 1),
              //       ),
              //       child: const Padding(
              //         padding: EdgeInsets.all(7),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           mainAxisSize: MainAxisSize.max,
              //           children: [
              //             Icon(
              //               Icons.person,
              //               color: Color(0xffffffff),
              //               size: 24,
              //             ),
              //             Expanded(
              //               flex: 1,
              //               child: Padding(
              //                 padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       "Ahmad Fauzan Arif",
              //                       textAlign: TextAlign.start,
              //                       maxLines: 1,
              //                       overflow: TextOverflow.clip,
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.w500,
              //                         fontStyle: FontStyle.normal,
              //                         fontSize: 16,
              //                         color: Color(0xffffffff),
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              //                       child: Text(
              //                         "098888288811",
              //                         textAlign: TextAlign.start,
              //                         maxLines: 1,
              //                         overflow: TextOverflow.ellipsis,
              //                         style: TextStyle(
              //                           fontWeight: FontWeight.w400,
              //                           fontStyle: FontStyle.normal,
              //                           fontSize: 14,
              //                           color: Color(0xffffffff),
              //                         ),
              //                       ),
              //                     ),
              //                     Text(
              //                       "Pasuruan",
              //                       textAlign: TextAlign.start,
              //                       overflow: TextOverflow.clip,
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.w400,
              //                         fontStyle: FontStyle.normal,
              //                         fontSize: 12,
              //                         color: Color(0xffffffff),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             Icon(
              //               Icons.arrow_forward_ios,
              //               color: Color(0xffffffff),
              //               size: 24,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SiswaTambah());
        },
        hoverElevation: 40,
        hoverColor: const Color(0xFFF9F871),
        backgroundColor: const Color(0xFFFFC253),
        child: const Icon(
          Icons.add,
          size: 24,
          color: Colors.black,
        ),
      ),
    );
  }
}