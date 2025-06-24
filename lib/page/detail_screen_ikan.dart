import 'package:flutter/material.dart';
import 'package:resep_makanan/model/model_olahan_ikan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DetailScreenIkan extends StatefulWidget {
  final ModelIkan ikan;

  const DetailScreenIkan({Key? key, required this.ikan}) : super(key: key);
  @override
  _DetailScreenIkanState createState() => _DetailScreenIkanState();
}

class _DetailScreenIkanState extends State<DetailScreenIkan> {
  // Flag untuk menentukan apakah resep sudah disimpan atau tidak
  bool isResepDisimpan = false;

  @override
  void initState() {
    super.initState();
    // Cek apakah resep sudah disimpan saat inisialisasi
    cekResepDisimpan();
  }

  Future<void> simpanResep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar resep yang sudah ada di penyimpanan lokal
    List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

    // Konversi objek Resep menjadi JSON
    String resepJson = jsonEncode(widget.ikan.toJson());

    // Cek apakah resep sudah ada di daftar resep yang disimpan
    bool isDisimpan = daftarResepString.contains(resepJson);

    if (isDisimpan) {
      // Jika resep sudah disimpan, hapus dari daftar yang disimpan
      daftarResepString.remove(resepJson);
    } else {
      // Jika resep belum disimpan, tambahkan ke daftar yang disimpan
      daftarResepString.add(resepJson);
    }

    // Simpan kembali daftar resep ke penyimpanan lokal
    prefs.setStringList('daftarResep', daftarResepString);

    // Set flag berdasarkan apakah resep sudah disimpan atau tidak
    setState(() {
      widget.ikan.toggleSavedStatus(); // Perbarui status isSaved
    });

    // Tambahkan pesan log atau penanganan lain yang diperlukan
    print(
        'Resep ${widget.ikan.isSaved ? "disimpan" : "dihapus"}: ${widget.ikan.nama}');
  }

  // Fungsi untuk cek apakah resep sudah disimpan atau tidak
  Future<void> cekResepDisimpan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

    // Cek apakah resep sudah ada di daftar resep yang disimpan
    String resepJson = jsonEncode(widget.ikan.toJson());
    bool isDisimpan = daftarResepString.contains(resepJson);

    setState(() {
      isResepDisimpan = isDisimpan;
    });
  }

  // Fungsi untuk menghapus resep
  Future<void> hapusResep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil daftar resep yang sudah ada di penyimpanan lokal
    List<String> daftarResepString = prefs.getStringList('daftarResep') ?? [];

    // Konversi objek Resep menjadi JSON
    String resepJson = jsonEncode(widget.ikan.toJson());

    // Hapus JSON resep dari daftar resep
    daftarResepString.remove(resepJson);

    // Simpan daftar resep kembali ke penyimpanan lokal
    prefs.setStringList('daftarResep', daftarResepString);

    // Set flag bahwa resep tidak disimpan
    setState(() {
      isResepDisimpan = false;
    });

    // Tambahkan pesan log atau penanganan lain yang diperlukan
    print('Resep dihapus dari penyimpanan: ${widget.ikan.nama}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
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
              widget.ikan.nama!,
              style: TextStyle(
                fontSize: 17.5,
                fontFamily: 'Poppins-SemiBold',
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black, size: 15),
        actions: [
          // Tambahkan ikon Simpan di AppBar
          IconButton(
            icon:
                Icon(isResepDisimpan ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () async {
              if (isResepDisimpan) {
                await hapusResep();
                // Tambahkan logika lain yang diperlukan, seperti notifikasi bahwa resep telah dihapus
              } else {
                await simpanResep();
                // Tambahkan logika lain yang diperlukan, seperti notifikasi bahwa resep telah disimpan
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan gambar resep dengan border radius circular
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(widget.ikan.gambar.toString()),
                  fit: BoxFit.cover,
                ),
              ),
              height: 200,
              width: double.infinity,
            ),
            SizedBox(height: 16.0),
            // Menampilkan ikon dan informasi tambahan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Waktu Masak
                buildInfoItem(Icons.access_time, widget.ikan.waktuMasak!),
                // Porsi
                buildInfoItem(Icons.restaurant, widget.ikan.porsi!),
                // Tingkat Kesulitan
                buildInfoItem(Icons.star, widget.ikan.tingkatKesulitan!),
              ],
            ),
            SizedBox(height: 16.0),
            // Menampilkan bahan-bahan
            buildSectionTitle('Bahan-bahan'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.ikan.bahan!
                  .map((bahan) => buildIngredientCard(bahan))
                  .toList(),
            ),
            SizedBox(height: 16.0),
            // Menampilkan langkah-langkah
            buildSectionTitle('Langkah-langkah'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.ikan.langkah!
                  .asMap()
                  .map((index, langkah) =>
                      MapEntry(index, buildStepCard(index + 1, langkah)))
                  .values
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        // Membuat ikon sedikit dikecilkan
        Icon(icon, size: 30),
        SizedBox(height: 8),
        Text(text),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }

  Widget buildIngredientCard(String ingredient) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '- $ingredient',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget buildStepCard(int stepNumber, String stepText) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          'Langkah $stepNumber',
          style: TextStyle(fontSize: 16.0),
        ),
        subtitle: Text(
          stepText,
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }
}
