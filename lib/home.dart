import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? profileData;
  Map<String, dynamic>? visiData;
  Map<String, dynamic>? misiData;
  Map<String, dynamic>? kepalaSekolahData;
  List<Map<String, dynamic>> kompetensiList = [];
  final PageController _pageController = PageController();
  Timer? _timer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    // Setup auto-slide timer
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        if (_pageController.page?.round() == kompetensiList.length - 1) {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      // Tambahkan setState untuk menunjukkan loading
      setState(() {
        isLoading = true;
      });

      final profileResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/profiles/1'));
      final visiResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/profiles/2'));
      final misiResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/profiles/3'));
      final kepalaSekolahResponse = await http.get(Uri.parse('http://10.0.2.2:8000/api/profiles/8'));
      
      // Periksa setiap response secara terpisah
      if (profileResponse.statusCode == 200) {
        setState(() {
          profileData = json.decode(profileResponse.body);
        });
      }
      
      if (visiResponse.statusCode == 200) {
        setState(() {
          visiData = json.decode(visiResponse.body);
        });
      }
      
      if (misiResponse.statusCode == 200) {
        setState(() {
          misiData = json.decode(misiResponse.body);
        });
      }
      
      if (kepalaSekolahResponse.statusCode == 200) {
        setState(() {
          kepalaSekolahData = json.decode(kepalaSekolahResponse.body);
        });
      }

      // Fetch kompetensi keahlian dengan error handling
      try {
        final kompetensi1 = await http.get(Uri.parse('http://10.0.2.2:8000/api/profiles/10'));
        final kompetensi2 = await http.get(Uri.parse('http://10.0.2.2:8000/api/profiles/11'));
        final kompetensi3 = await http.get(Uri.parse('http://10.0.2.2:8000/api/profiles/12'));
        final kompetensi4 = await http.get(Uri.parse('http://10.0.2.2:8000/api/profiles/13'));

        List<Map<String, dynamic>> tempList = [];

        if (kompetensi1.statusCode == 200) {
          tempList.add(json.decode(kompetensi1.body));
        }
        if (kompetensi2.statusCode == 200) {
          tempList.add(json.decode(kompetensi2.body));
        }
        if (kompetensi3.statusCode == 200) {
          tempList.add(json.decode(kompetensi3.body));
        }
        if (kompetensi4.statusCode == 200) {
          tempList.add(json.decode(kompetensi4.body));
        }

        setState(() {
          kompetensiList = tempList;
        });
      } catch (e) {
        debugPrint('Error fetching kompetensi: $e');
      }

    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      // Pastikan loading indicator dimatikan
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hero Section
  Widget _buildHeroSection() {
    return Stack(
      children: [
        Container(
          height: 280,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/smkn4bogor_2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selamat Datang',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Di Website Gallery\nSMKN 4 BOGOR',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sourceSans3(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.3,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Profile Section
  Widget _buildProfileSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 8,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    color: Colors.blue[700],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Profil Sekolah',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (profileData != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Container
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blue[100]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.business,
                              color: Colors.blue[700],
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            profileData!['data']['judul'] ?? '',
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        profileData!['data']['isi'] ?? '',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Visi Container
                if (visiData != null)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue[100]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.lightbulb_outline,
                                color: Colors.blue[700],
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              visiData!['data']['judul'] ?? '',
                              style: GoogleFonts.raleway(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          visiData!['data']['isi'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Misi Container
                if (misiData != null)
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.blue[100]!,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.08),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flag_outlined, color: Colors.blue[700], size: 28),
                            SizedBox(width: 12),
                            Text(
                              misiData!['data']['judul'] ?? '',
                              style: GoogleFonts.montserrat(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          misiData!['data']['isi'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Kepala Sekolah Container
                if (kepalaSekolahData != null)
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue[50]!,
                          Colors.white,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Kepala Sekolah',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Foto Kepala Sekolah dengan efek
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.blue[300]!, Colors.blue[600]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              image: DecorationImage(
                                image: AssetImage('assets/images/kepsek.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          kepalaSekolahData!['data']['judul'] ?? '',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          kepalaSekolahData!['data']['isi'] ?? '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: Colors.grey[800],
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Kompetensi Keahlian Container
                if (kompetensiList.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue[100]!,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.08),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school_outlined, color: Colors.blue[700], size: 30),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Kompetensi Keahlian',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 300,  // Sesuaikan tinggi sesuai kebutuhan
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: kompetensiList.length,
                                itemBuilder: (context, index) {
                                  final kompetensi = kompetensiList[index];
                                  return GestureDetector(
                                    onTap: () => _showKompetensiDetail(kompetensi, index),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 180,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.asset(
                                                'assets/images/${_getKompetensiImage(index)}',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            kompetensi['data']['judul'] ?? '',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.raleway(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Tap untuk melihat detail',
                                            style: GoogleFonts.lato(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Indicator dots
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    kompetensiList.length,
                                    (index) => AnimatedBuilder(
                                      animation: _pageController,
                                      builder: (context, child) {
                                        double page = _pageController.hasClients
                                            ? (_pageController.page ?? 0)
                                            : 0;
                                        return Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4),
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: index == page.round()
                                                ? Colors.blue
                                                : Colors.grey[300],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[400],
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi kesalahan saat memuat data',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: fetchData,
                    icon: Icon(Icons.refresh),
                    label: Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(),

              // Profile Section
              _buildProfileSection(),

              // Contact Section
              _buildContactSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kontak
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[900]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.contact_phone_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Kontak Kami',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Konten Kontak
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildContactItemNew(
                  icon: Icons.map_outlined,
                  title: 'Alamat',
                  content: 'Jl. Raya Tajur, Kp. Buntar RT.02/RW.08, Muarasari, Kec. Bogor Sel., Kota Bogor, Jawa Barat 16137',
                  color: Colors.orange[700]!,
                ),
                const SizedBox(height: 24),
                const Divider(height: 30, thickness: 1),
                _buildContactItemNew(
                  icon: Icons.phone_outlined,
                  title: 'Telepon',
                  content: '+62 251 7547381',
                  color: Colors.green[600]!,
                  isPhone: true,
                ),
                const SizedBox(height: 16),
                const Divider(height: 30, thickness: 1),
                _buildContactItemNew(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  content: 'info@smkn4bogor.sch.id',
                  color: Colors.red[600]!,
                  isEmail: true,
                ),
                const SizedBox(height: 15),
                // Sosial Media Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(const FaIcon(FontAwesomeIcons.facebook), Colors.blue[900]!),
                    const SizedBox(width: 10),
                    _buildSocialButton(const FaIcon(FontAwesomeIcons.whatsapp), Colors.green[600]!),
                    const SizedBox(width: 10),
                    _buildSocialButton(const FaIcon(FontAwesomeIcons.instagram), Colors.pink[400]!),
                    const SizedBox(width: 10),
                    _buildSocialButton(const FaIcon(FontAwesomeIcons.youtube), Colors.red[600]!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItemNew({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    bool isPhone = false,
    bool isEmail = false,
  }) {
    return InkWell(
      onTap: () async {
        String url = '';
        if (isPhone) {
          url = 'tel:${content.replaceAll(' ', '')}';
        } else if (isEmail) {
          url = 'mailto:$content';
        }
        
        if (url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(FaIcon icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: () async {
            String url = '';
            switch (icon.icon) {
              case FontAwesomeIcons.facebook:
                url = 'https://www.facebook.com/people/SMK-NEGERI-4-KOTA-BOGOR/100054636630766/';
                break;
              case FontAwesomeIcons.whatsapp:
                url = 'https://wa.me/+6282111465865';
                break;
              case FontAwesomeIcons.instagram:
                url = 'https://www.instagram.com/smkn4bogor.official/';
                break;
              case FontAwesomeIcons.youtube:
                url = 'https://www.youtube.com/@smkn4kotabogor6324';
                break;
            }
            
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: FaIcon(
              icon.icon,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  // Tambahkan fungsi untuk menampilkan dialog detail
  void _showKompetensiDetail(Map<String, dynamic> kompetensi, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header dengan tombol close
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          image: DecorationImage(
                            image: AssetImage('assets/images/${_getKompetensiImage(index)}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5), // Background semi-transparan
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kompetensi['data']['judul'] ?? '',
                          style: GoogleFonts.raleway(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          kompetensi['data']['isi'] ?? '',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Fungsi helper untuk mendapatkan nama file gambar berdasarkan index
  String _getKompetensiImage(int index) {
    switch(index) {
      case 0:
        return 'pplg.jpg';
      case 1:
        return 'tjkt.jpg';
      case 2:
        return 'to.jpg';
      case 3:
        return 'tp.jpg';
      default:
        return 'pplg.jpg';
    }
  }
}