import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  List<dynamic>? postsData;
  List<dynamic>? galleriesData;
  bool isLoading = true;

  String getBaseUrl() {
    try {
      if (kIsWeb) {
        return 'http://127.0.0.1:8000';
      } else if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000';
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
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Future.wait([
        fetchPosts(),
        fetchGalleries(),
      ]);
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/api/posts')
      );
      
      if (response.statusCode == 200) {
        if (mounted) {
          final allPosts = json.decode(response.body)['data'];
          final agendaPosts = (allPosts as List).where((post) => 
            post['category_id'] == 4 && post['status'] == 'publish'
          ).toList();
          
          setState(() {
            postsData = agendaPosts;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Gagal mengambil data posts');
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    }
  }

  Future<void> fetchGalleries() async {
    try {
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/api/galleries')
      );
      
      if (response.statusCode == 200) {
        if (mounted) {
          final allGalleries = json.decode(response.body)['data'];
          final agendaGalleries = (allGalleries as List).where((gallery) => 
            gallery['post']['category_id'] == 4 && gallery['status'] == 'aktif'
          ).toList();
          
          setState(() {
            galleriesData = agendaGalleries;
          });
        }
      } else {
        throw Exception('Gagal mengambil data galleries');
      }
    } catch (e) {
      debugPrint('Error fetching galleries: $e');
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
        : postsData == null || postsData!.isEmpty
          ? const Center(child: Text('Tidak ada agenda tersedia'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: postsData?.length ?? 0,
                  itemBuilder: (context, index) {
                    final post = postsData![index];
                    final postGalleries = galleriesData?.where(
                      (gallery) => gallery['post_id'] == post['id']
                    ).toList() ?? [];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post['image'] != null && post['image'].isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: '${getBaseUrl()}/images/${post['image']}',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 200,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ],
                          if (postGalleries.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            ...postGalleries.map((gallery) {
                              if (gallery['images'] != null && 
                                  (gallery['images'] as List).isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: GridView.builder(
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
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: '${getBaseUrl()}/images/${image['file']}',
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            color: Colors.grey[200],
                                            child: const Center(child: CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }).toList(),
                          ],
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.event,
                                      color: Color(0xFF1A237E),
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        post['title'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      post['created_at'] != null
                                          ? DateFormat('dd MMMM yyyy', 'id_ID').format(
                                              DateTime.parse(post['created_at']))
                                          : '-',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  post['content'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
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
