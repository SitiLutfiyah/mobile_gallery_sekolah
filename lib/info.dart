import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;  // Tambahkan import ini
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<dynamic>? galleriesData;
  bool isLoading = true;

  // Fungsi untuk mendapatkan base URL
  String getBaseUrl() {
    try {
      if (kIsWeb) {
        return 'http://127.0.0.1:8000';
      } else if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000'; // URL untuk emulator Android
      } else if (Platform.isIOS) {
        return 'http://127.0.0.1:8000';
      }
    } catch (e) {
      debugPrint('Platform error: $e');
    }
    return 'http://127.0.0.1:8000';
  }

  @override
  void initState() {
    super.initState();
    fetchGalleries();
  }

  Future<void> fetchGalleries() async {
    try {
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/api/galleries')
      );
      
      if (response.statusCode == 200) {
        if (mounted) {
          final allGalleries = json.decode(response.body)['data'];
          // Filter galeri yang terkait dengan post berkategori 3 (Informasi Terkini)
          final infoGalleries = (allGalleries as List).where((gallery) => 
            gallery['post']['category_id'] == 3 && gallery['status'] == 'aktif'
          ).toList();
          
          setState(() {
            galleriesData = infoGalleries;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Gagal mengambil data galeri');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8EAF6),
            Colors.white,
          ],
        ),
      ),
      child: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : galleriesData == null || galleriesData!.isEmpty
          ? const Center(child: Text('Tidak ada galeri untuk informasi terkini'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: galleriesData?.length ?? 0,
                  itemBuilder: (context, index) {
                    final gallery = galleriesData![index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Color(0xFF1A237E),
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        gallery['post']['title'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  gallery['post']['content'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (gallery['images'] != null && (gallery['images'] as List).isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                    itemCount: (gallery['images'] as List).length,
                                    itemBuilder: (context, imageIndex) {
                                      final image = gallery['images'][imageIndex];
                                      final imageUrl = '${getBaseUrl()}/images/${image['file']}';
                                      print('Platform: ${kIsWeb ? 'Web' : Platform.operatingSystem}');
                                      print('Base URL: ${getBaseUrl()}');
                                      print('URL Gambar: $imageUrl');
                                      
                                      return GestureDetector(
                                        onTap: () {
                                          debugPrint('Image tapped: $imageUrl');
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              color: Colors.grey[200],
                                              child: Center(child: CircularProgressIndicator()),
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.grey[200],
                                              child: Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      gallery['post']['created_at'] != null
                                          ? DateFormat('dd MMMM yyyy', 'id_ID').format(
                                              DateTime.parse(gallery['post']['created_at']))
                                          : '-',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}


