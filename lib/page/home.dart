import 'package:flutter/material.dart';
import 'package:resep_makanan/page/olahan_ayam_page.dart';
import 'package:resep_makanan/page/olahan_daging_page.dart';
import 'package:resep_makanan/page/olahan_ikan_page.dart';
import 'package:resep_makanan/page/olahan_sayur_page.dart';
import 'package:resep_makanan/page/about_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resep_makanan/model/model_olahan_ayam.dart';
import 'package:resep_makanan/model/model_olahan_daging.dart';
import 'package:resep_makanan/model/model_olahan_ikan.dart';
import 'package:resep_makanan/model/model_olahan_sayur.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fungsi untuk mendapatkan daftar resep yang disimpan
Future<List<dynamic>> ambilResepDisimpan() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

  List<dynamic> daftarResep = daftarResepString.map((json) {
    Map<String, dynamic> decoded = jsonDecode(json);
    if (decoded.containsKey('jenis') && decoded['jenis'] == 'ikan') {
      return ModelIkan.fromJson(decoded);
    } else if (decoded.containsKey('jenis') && decoded['jenis'] == 'ayam') {
      return ModelAyam.fromJson(decoded);
    } else if (decoded.containsKey('jenis') && decoded['jenis'] == 'sayur') {
      return ModelSayur.fromJson(decoded);
    }else {
      return ModelDaging.fromJson(decoded);
    }
  }).toList();

  return daftarResep;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/home.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              "assets/images/icon.png",
              height: 30,
              width: 30,
            ),
            SizedBox(width: 8),
            Text(
              "Resepku",
              style: TextStyle(
                fontSize: 17.5,
                fontFamily: 'Poppins-SemiBold',
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Tambahkan ikon untuk melihat resep yang disimpan di AppBar
          IconButton(
            icon: Icon(Icons.bookmark),
            color: Colors.black,
            onPressed: () async {
              // Tampilkan halaman untuk melihat resep yang disimpan
              List<dynamic> daftarResepDisimpan = await ambilResepDisimpan();
              // Implementasikan logika untuk menampilkan daftar resep yang disimpan
              // Contoh: Tampilkan daftar resep disimpan dalam dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Resep yang Disimpan'),
                    content: Column(
                      children: daftarResepDisimpan
                          .map((resep) => ListTile(
                                title: Text(resep.nama ?? ''),
                              ))
                          .toList(),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          padding: EdgeInsets.all(20.0),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanAyam()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_ayam.jpg"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Ayam",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanDaging()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_daging.jpg"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Daging",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanIkan()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_ikan.jpg"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Ikan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OlahanSayur()),
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: AssetImage("assets/images/olahan_sayur.jpg"),
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Olahan Sayur",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
