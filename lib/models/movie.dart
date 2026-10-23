import 'dart:convert';
import 'package:flutter/services.dart';

class Movie {
  final String id;
  final String title;
  final String genre;
  final String rating;
  final String description;
  final String imageUrl;
  final String duration;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.description,
    required this.imageUrl,
    this.duration = '2j 15m',
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      genre: json['genre'] ?? '',
      rating: json['rating'] ?? '0.0',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      duration: json['duration'] ?? '2j 15m',
    );
  }
}

Future<List<Movie>> loadMoviesFromJson() async {
  String response;
  try {
    response = await rootBundle.loadString('assets/data/movies.json');
  } catch (_) {
    try {
      response = await rootBundle.loadString('assets/Data/movies.json');
    } catch (_) {
      return [
        Movie(
          id: "1",
          title: "Oppenheimer",
          genre: "Drama",
          rating: "8.3/10",
          duration: "3j 00m",
          description: "Di tengah gejolak Perang Dunia II yang membara, J. Robert Oppenheimer, seorang fisikawan teoritis jenius yang penuh dilema moral, ditunjuk memimpin proyek rahasia tingkat tinggi Amerika Serikat bernama Proyek Manhattan di Los Alamos. Bersama tim ilmuwan terbaik dunia, Oppenheimer berpacu dengan waktu untuk menciptakan senjata paling mematikan yang pernah ada dalam sejarah manusia: bom atom.\n\nKetika ujicoba Trinity berhasil mengguncang gurun New Mexico, dunia memasuki era nuklir yang tak terbalikkan. Namun, kemenangan ilmiah tersebut membawakan bayang-bayang kehancuran massa dan penderitaan batin bagi Oppenheimer. Usai perang berakhir, ia tidak hanya dihadapkan pada tuduhan pengkhianatan dalam intrik politik Perang Dingin, tetapi juga beban moral mendalam atas ciptaannya yang berpotensi memusnahkan peradaban manusia.",
          imageUrl: "assets/images/oppenheimer.jpg",
        ),
        Movie(
          id: "2",
          title: "Spider-Man: Across the Spider-Verse",
          genre: "Action",
          rating: "8.6/10",
          duration: "2j 20m",
          description: "Setelah berhasil menyelamatkan dunianya, Miles Morales kembali menjalani kehidupan ganda sebagai siswa biasa dan pahlawan bertopeng Spider-Man di Brooklyn. Suatu hari, Miles didekati kembali oleh Gwen Stacy dan dibawa melintasi Multiverse yang tak terbatas.\n\nDi sana, ia bertemu dengan Spider-Society, sebuah aliansi elit pahlawan laba-laba dari berbagai dimensi yang dipimpin oleh Miguel O'Hara (Spider-Man 2099) yang bertugas menjaga stabilitas takdir di setiap alam semesta. Konflik besar meletus ketika Miles menemukan kenyataan pahit bahwa untuk menyelamatkan alam semesta, sebuah tragedi tak terelakkan harus menimpa orang terdekatnya. Menolak takdir yang dipaksakan, Miles bertarung sendirian menentang ratusan Spider-People lainnya demi menyelamatkan sang ayah, membuktikan bahwa seorang pahlawan sejati menentukan jalurnya sendiri.",
          imageUrl: "assets/images/spiderman.jpg",
        ),
        Movie(
          id: "3",
          title: "Dune: Part Two",
          genre: "Sci-Fi",
          rating: "8.8/10",
          duration: "2j 46m",
          description: "Di planet padang pasir Arrakis yang kejam dan kaya akan rempah ajaib Melange, Paul Atreides melanjutkan perjalanan takdirnya yang penuh darah. Bersama ibunya, Lady Jessica, Paul bergabung dengan kaum pahlawan padang pasir Fremen dan menjalin hubungan erat dengan Chani. Paul belajar bertahan hidup di lingkungan ekstrem dan membuktikan dirinya sebagai sosok penunggang cacing pasir raksasa.\n\nNamun, saat dendamnya terhadap klan Harkonnen dan Kaisar Shaddam IV membara, benturan antara ramalan messiah 'Lisan al-Gaib' dan hasrat politik mengancam untuk memicu perang suci (jihad) yang akan menyebar ke seluruh galaksi. Paul harus memilih antara cinta sejati pada Chani atau menerima takdir tragis yang akan mengorbankan miliaran nyawa demi tahta kekaisaran.",
          imageUrl: "assets/images/dune.jpg",
        ),
        Movie(
          id: "4",
          title: "The Dark Knight",
          genre: "Action",
          rating: "9.0/10",
          duration: "2j 32m",
          description: "Kota Gotham berada di ambang keteraturan berkat kerja sama Batman, Letnan James Gordon, dan Jaksa Wilayah yang karismatik, Harvey Dent. Namun, kedamaian semu itu hancur berkat kemunculan sosok kriminal misterius dan anarkis bernama Joker.\n\nTanpa motif uang atau kekuasaan, Joker hanya ingin membuktikan bahwa manusia paling moral pun bisa berubah menjadi monster ketika dihadapkan pada kekacauan mutlak. Dalam permainan psikologis yang manipulatif dan sadis, Joker memaksa Batman melampaui batasan moralnya dan mendorong Harvey Dent ke jurang kegelapan sebagai 'Two-Face'. Demi menyelamatkan harapan warga Gotham, Batman bersedia mengorbankan reputasinya sendiri, menjadi buronan kegelapan yang dibenci kota yang ia lindungi.",
          imageUrl: "assets/images/dark_knight.jpg",
        ),
        Movie(
          id: "5",
          title: "Interstellar",
          genre: "Sci-Fi",
          rating: "8.7/10",
          duration: "2j 49m",
          description: "Di masa depan yang suram, Bumi diambang kepunahan akibat wabah tanaman dan krisis pangan global. Joseph Cooper, seorang mantan pilot NASA dan ayah tunggal, menemukan rahasia gravitasi di kamar putrinya, Murph, yang menuntunnya ke fasilitas rahasia NASA.\n\nDiberikan misi terakhir umat manusia, Cooper memimpin ekspedisi luar angkasa melintasi lubang cacing (wormhole) misterius dekat Planet Saturnus untuk mencari planet baru yang layak huni di galaksi lain. Melewati planet dengan ombak raksasa, dilatasi waktu di dekat lubang hitam supermasif Gargantua, serta pengkhianatan rekan sesama penjelajah, Cooper harus mengarungi dimensi kelima untuk mengirimkan sinyal gravitasi penyelamat kepada Murph melintasi ruang dan waktu.",
          imageUrl: "assets/images/interstellar.jpg",
        ),
        Movie(
          id: "6",
          title: "Parasite",
          genre: "Drama",
          rating: "8.5/10",
          duration: "2j 12m",
          description: "Keluarga Kim—sang ayah Ki-taek, ibu Chung-sook, serta dua anak mereka Ki-woo dan Ki-jung—hidup dalam kemiskinan ekstrem di sebuah rumah semi-basement yang sempit dan lembap di Seoul. Kehidupan mereka berubah drastis ketika Ki-woo mendapatkan kesempatan menjadi guru privat bahasa Inggris untuk putri dari keluarga Park yang sangat kaya raya.\n\nMelalui tipu daya yang cerdik dan manipulasi bertahap, seluruh anggota keluarga Kim berhasil menyusup bekerja di rumah mewah keluarga Park tanpa menyadari hubungan darah mereka. Namun, permainan parasitik ini berubah menjadi guncangan berdarah ketika sebuah rahasia kelam di bunker bawah tanah rumah mewah tersebut terbongkar pada suatu malam berhujan lebat.",
          imageUrl: "assets/images/parasite.jpg",
        ),
        Movie(
          id: "7",
          title: "Avengers: Endgame",
          genre: "Action",
          rating: "8.4/10",
          duration: "3j 02m",
          description: "Lima tahun setelah Thanos memusnahkan separuh populasi alam semesta dengan jentikan jarum Semesta, para pahlawan yang tersisa hidup dalam duka dan kehampaan. Kemunculan kembali Scott Lang (Ant-Man) dari Alam Kuantum membawa sekercah harapan baru: kemungkinan melakukan perjalanan waktu untuk mengumpulkan kembali enam Batu Keabadian sebelum Thanos menggunakannya.\n\nDipimpin oleh Steve Rogers dan Tony Stark, para Avengers bersatu kembali dalam misi pemungkas melintasi berbagai titik waktu masa lalu. Pertempuran klimaks yang megah pecah ketika Thanos masa lalu mengetahui rencana mereka, menuntut pengorbanan tertinggi demi mengembalikan kehidupan seluruh alam semesta.",
          imageUrl: "assets/images/avengers.jpg",
        ),
        Movie(
          id: "8",
          title: "Inception",
          genre: "Sci-Fi",
          rating: "8.8/10",
          duration: "2j 28m",
          description: "Dom Cobb adalah seorang pencuri ulung yang memiliki kemampuan langka untuk menyusup ke dalam alam mimpi seseorang dan mencuri rahasia paling berharga saat target sedang tidur. Namun, kemampuan ini membuatnya menjadi buronan internasional yang kehilangan hak untuk bertemu anak-anaknya.\n\nSebuah kesempatan emas datang dari pengusaha kaya Saito: alih-alih mencuri (extraction), Cobb ditugaskan melakukan hal sebaliknya yang hampir mustahil, yaitu menanamkan suatu ide ke dalam pikiran seorang pewaris perusahaan (inception). Bersama tim spesialis pemimpi, Cobb menyelami labirin mimpi tiga tingkat yang sangat berbahaya, di mana batas antara ilusi dan kenyataan mengabur akibat trauma masa lalu dengan mendiang istrinya, Mal.",
          imageUrl: "assets/images/inception.jpg",
        ),
        Movie(
          id: "9",
          title: "Joker",
          genre: "Drama",
          rating: "8.4/10",
          duration: "2j 02m",
          description: "Di kota Gotham awal 1980-an yang kumuh dan penuh ketimpangan sosial, Arthur Fleck adalah seorang pria kesepian yang bekerja sebagai badut sewaan sambil merawat ibunya yang sakit. Arthur mengidap gangguan mental unik yang membuatnya tertawa tak terkendali saat merasa cemas atau tertekan.\n\nDiabaikan oleh masyarakat, disiksa secara fisik di jalanan, dan dipotong akses obat-obatannya oleh pemerintah lokal, Arthur secara perlahan kehilangan pijakan kognitifnya. Sebuah insiden penembakan di kereta bawah tanah menjadi titik balik dramatis saat tindakan kekerasan Arthur justru menginspirasi gerakan protes anti-elit di seluruh kota Gotham, melahirkan sesosok ikon kriminal baru yang ikonik: Joker.",
          imageUrl: "assets/images/joker.jpg",
        ),
        Movie(
          id: "10",
          title: "The Conjuring",
          genre: "Horror",
          rating: "7.5/10",
          duration: "1j 52m",
          description: "Pada tahun 1971, keluarga Perron bersama lima putri mereka pindah ke sebuah rumah pertanian tua di Harrisville, Rhode Island. Tak lama setelah menempati rumah tersebut, kejadian-kejadian mistis yang mengerikan mulai mengintai kehidupan mereka setiap malam, mulai dari jam yang berhenti pukul 03.07 pagi, bau busuk menyengat, hingga teror fisik dari entitas tak kasat mata.\n\nDalam keputusasaan, mereka meminta bantuan pasangan penyelidik supranormal terkenal, Ed dan Lorraine Warren. Saat melakukan investigasi, Ed dan Lorraine menemukan kisah kelam masa lalu tanah tersebut yang dikutuk oleh seorang penyihir iblis bernama Bathsheba. Misi pengusiran setan (exorcism) yang mencekam pun digelar demi menyelamatkan nyawa ibu dan anak-anak Perron dari kegelapan abadi.",
          imageUrl: "assets/images/conjuring.jpg",
        ),
      ];
    }
  }

  final List<dynamic> data = jsonDecode(response);
  return data.map((json) => Movie.fromJson(json)).toList();
}
