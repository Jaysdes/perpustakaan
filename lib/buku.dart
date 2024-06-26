import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Buku {
  final int id;
  final String judul;
  final String gambar;
  String status;

  Buku({
    required this.id,
    required this.judul,
    required this.gambar,
    required this.status,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json["id"],
      judul: json["judul"] ?? "No Title",
      gambar: json["gambar"] ?? "https://via.placeholder.com/150",
      status: json["status"] ??
          "In Stock", // Sesuaikan dengan nilai default dari database
    );
  }

  Future<void> pinjamBuku() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8100/buku/${this.id}/pinjam'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'status':
              'Dipinjam', // Sesuaikan dengan value yang digunakan di API Golang
        }),
      );

      if (response.statusCode == 200) {
        this.status = 'Dipinjam';
      } else {
        throw Exception('Failed to borrow Buku - ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class BukuList extends StatefulWidget {
  @override
  _BukuListState createState() => _BukuListState();
}

class _BukuListState extends State<BukuList> {
  late Future<List<Buku>> futureBukus;

  @override
  void initState() {
    super.initState();
    futureBukus = fetchBukus();
  }

  Future<List<Buku>> fetchBukus() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8100/buku'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> BukusJson = jsonResponse['data'];

      return BukusJson.map((json) => Buku.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Buku');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Buku>>(
        future: futureBukus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Data Available"));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Buku buku = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          buku.gambar,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          buku.judul,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          'Status: ${buku.status}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await buku.pinjamBuku();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Buku ${buku.judul} berhasil dipinjam!',
                                ),
                              ),
                            );
                            setState(() {
                              // Refresh UI jika peminjaman berhasil
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal meminjam buku ${buku.judul}: $e',
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Pinjam'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
