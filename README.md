Nama: Aimee E.

NPM: 2306165963

Kelas: PBP C

E-Commerce: Clothing

Nama e-commerce: BeliBaju


# Tugas 9
## Pentingnya model untuk pengambilan atau pengiriman data JSON
Uuntuk menjaga struktur data yang dipertukarkan antara aplikasi dan server, model akan berfungsi sebagai representasi data sehingga mempermudah proses parsing (saat menerima data) dan encoding (saat mengirim data). Tanpa model, developer harus melakukan parsing dan validasi secara manual, yang berisiko menimbulkan error, terutama jika format JSON yang diterima berbeda dari ekspektasi.

Jika model tidak dibuat terlebih dahulu, aplikasi mungkin tetap dapat berjalan, namun berpotensi mengalami error saat format JSON berubah, seperti field yang hilang atau tipe data yang tidak sesuai, yang biasanya dapat menyebabkan exception, seperti NoSuchMethodError atau TypeError di Flutter.

## Library http
Library http dalam Flutter digunakan untuk mengirim permintaan (request) HTTP ke server dan menerima responnya. Fungsi utamanya mencakup:
- Mengirimkan GET request untuk mengambil data dari server.
- Mengirimkan POST request untuk mengirim data ke server.
- Mengatur header dan parameter permintaan untuk mendukung autentikasi atau format data tertentu (misalnya JSON).
Dalam tugas 9 saya, library http menjadi penghubung komunikasi antara aplikasi Flutter dan server Django. 

## CookieRequest
CookieRequest merupakan kelas yang digunakan untuk mengelola sesi user dengan cara menyimpan dan mengelola cookie secara otomatis. Beberapa fungsinya mencakup:
- Menyimpan informasi sesi user setelah login, sehingga user tidak perlu memasukkan ulang kredensial setiap kali aplikasi digunakan.
- Mengirim cookie yang relevan bersama setiap permintaan HTTP untuk memastikan server mengenali sesi user saat ini.
- Menghapus cookie saat user logout untuk mengakhiri sesi.

Instance CookieRequest perlu dibagikan ke semua komponen dalam aplikasi Flutter agar semua komponen dapat mengakses informasi sesi yang sama. Melalui approach tersebut, semua permintaan HTTP ke server akan menggunakan cookie yang konsisten, lalu data sesi user, seperti token autentikasi, dapat digunakan di berbagai modul tanpa perlu meminta pengguna untuk login ulang.

## Mekanisme pengiriman data
1) Input dari user  
Melalui UI Flutter, misalnya user akan mengisi form atau memilih opsi pada app. Data tersebut kemudian diolah ke dalam bentuk objek menggunakan kelas model yang telah dibuat. Misalnya, jika ada kelas `Lagu`, input user dapat digunakan untuk membuat sebuah instance dari kelas tersebut. Contoh:
```
Lagu laguBaru = Lagu(judul: "Judul Lagu", penyanyi: "Nama Penyanyi");
```
2) Konversi data dengan `toJson` untuk dikirim ke server 
Sebelum data dapat dikirim ke server, objek dari kelas (contohnya `Lagu`) harus dikonversi ke dalam format JSON dengan menggunakan method `toJson` yang telah didefinisikan di dalam kelas tersebut. Contoh:  
```
Map<String, dynamic> jsonLagu = laguBaru.toJson();
```
3) Mengirimkan data ke server dengan HTTP request  
Setelah data dikonversi menjadi JSON, app mengirimkannya ke server menggunakan library HTTP, biasanya dengan metode POST untuk pengiriman data baru atau PUT untuk pembaruan data. Contoh:  
```
   final response = await http.post(
     Uri.parse('https://example.com/api/lagu'),
     body: jsonEncode(jsonLagu),
     headers: {'Content-Type': 'application/json'},
   );
```
4) Pemrosesan di server
Server, dalam hal ini Django, menerima data JSON, memparsenya, dan memprosesnya sesuai kebutuhan, seperti menyimpan data ke database atau memvalidasi input. Server kemudian mengembalikan respons dalam bentuk JSON yang mencerminkan hasil pemrosesan (misalnya status sukses atau data yang baru saja disimpan).
5) Menerima respons dari server
Flutter menerima respons server, yang biasanya berupa JSON, berupa data yang perlu ditampilkan atau status yang menunjukkan apakah permintaan berhasil. Respons tersebut diproses dengan metode fromJson, yang bertugas mengonversi JSON menjadi objek model di Flutter, seperti objek `Lagu`. Contoh:
```
   if (response.statusCode == 200) {
     final laguDariServer = Lagu.fromJson(jsonDecode(response.body));
   }
```
6) Menampilkan data di UI
Objek yang telah diubah dari JSON ke model Flutter dapat langsung digunakan untuk memperbarui UI menggunakan mekanisme seperti setState atau state management lainnya.  
```
   setState(() {
     daftarLagu.add(laguDariServer);
   });
```

## Mekanisme autentikasi dari login, register, hingga logout
1) Register
- Proses Input di Flutter
    - User mengisi form pendaftaran dengan data yang akan divalidasi secara lokal untuk memastikan kelengkapan dan kesesuaian, seperti kecocokan password. - Mengirim data ke Django
    - Data pendaftaran dikonversi menjadi JSON menggunakan fungsi bawaan dari pbp_django_auth atau dengan manual menggunakan jsonEncode.
    - Permintaan dikirim ke endpoint Django `/auth/register/` menggunakan metode POST.
    - Contoh:  
     ```
     final response = await request.postJson(
       "http://[APP_URL_KAMU]/auth/register/",
       jsonEncode({
         "username": username,
         "password1": password1,
         "password2": password2,
       }),
     );
     ```
- Proses di Django
    - Django memvalidasi apakah username sudah ada dan apakah password cocok.
    - Jika valid, pengguna baru disimpan ke database dan respons JSON diberikan dengan status sukses.
    - Jika tidak valid, Django mengembalikan pesan error dalam format JSON.  
- Tampilan di Flutter
    - Jika pendaftaran berhasil, aplikasi akan menampilkan notifikasi sukses dan mengarahkan user ke halaman login. Jika gagal, pesan error ditampilkan di UI.

2) Login 
- Proses Input di Flutter
    - User memasukkan username dan password pada form login. Data ini diambil dari input teks.  
- Mengirim data ke Django
    - Data login dikirim ke endpoint Django `/auth/login/` menggunakan metode POST. Contoh:  
     ```
     final response = await request.login(
       "http://[APP_URL_KAMU]/auth/login/",
       {'username': username, 'password': password},
     );
     ```
- Proses di Django
    - Django memvalidasi kredensial menggunakan `authenticate()`.
    - Jika valid, Django membuat sesi dan mengembalikan status berhasil bersama data user (misalnya, username) sebagai JSON.
    - Jika gagal, Django mengembalikan pesan error seperti "Invalid username or password".  
- Tampilan di Flutter
    - Jika berhasil, aplikasi menyimpan sesi menggunakan `CookieRequest` untuk autentikasi pada permintaan berikutnya.
    - User diarahkan ke halaman utama (menu).
    - Jika gagal, pesan error ditampilkan di dialog atau snackbar.
      
3) Logout  
- Proses Input di Flutter
    - Ketika user memilih logout, Flutter mengirimkan permintaan ke endpoint Django `/auth/logout/`. Contoh:  
     ```
     final response = await request.logout("http://[APP_URL_KAMU]/auth/logout/");
     ```
- Proses di Django
    - Django menghancurkan sesi pengguna yang aktif.
    - Django mengembalikan respons sukses dalam format JSON.  
- Tampilan di Flutter
    - Setelah logout berhasil, sesi dihapus dari memori lokal aplikasi yang dikelola oleh CookieRequest.
    - User diarahkan kembali ke halaman login.

4) Integrasi autentikasi di Flutter dengan CookieRequest
Library ini memudahkan manajemen sesi antara Flutter dan Django. Instance CookieRequest disediakan secara global menggunakan Provider, memungkinkan semua widget di aplikasi untuk mengakses status login dan melakukan autentikasi tanpa harus membuat ulang objek. Contoh:
```
     class MyApp extends StatelessWidget {
       @override
       Widget build(BuildContext context) {
         return Provider(
           create: (_) => CookieRequest(),
           child: MaterialApp(
             home: LoginPage(),
           ),
         );
       }
     }
```

## Step-by-step
- Pertama, saya membuat fungsi baru di Django untuk menerima data registrasi, seperti username dan password. Saya memastikan password cocok dan username belum digunakan. Jika semuanya benar, saya membuat akun pengguna baru dan mengirimkan respons berhasil.
- Lalu, saya menambahkan rute baru untuk fungsi registrasi agar aplikasi bisa mengaksesnya.
- Saya membuat page baru bernama RegisterPage. Di sini, saya merancang formulir untuk username, password, dan konfirmasi password. Ketika formulir dikirim, data dikirim ke server menggunakan HTTP POST, lalu aplikasi menampilkan pesan keberhasilan atau kegagalan.
- Saya memastikan aplikasi Flutter bisa mengakses internet dengan mengaktifkan izin di file konfigurasi Android.
- Saya membuat endpoint untuk mengambil data mood yang disimpan di database.
- Saya menambahkan layar baru untuk menampilkan daftar produk. Flutter akan mengambil data dari server Django, mengolahnya, lalu menampilkan daftar dengan desain yang menarik.
- Saya membuat fungsi di Django yang menerima data baru dari aplikasi Flutter. Data ini disimpan di database, dan saya mengirimkan konfirmasi keberhasilan.
- Saya memodifikasi tombol tambah agar bisa mengirim data baru ke Django. Setelah data berhasil ditambahkan, saya menampilkan pesan konfirmasi.
- Kemudian, saya membuat fungsi logout yang menghapus sesi pengguna di server.
- Terakhir, saya menambahkan opsi logout di aplikasi Flutter. Ketika logout berhasil, aplikasi menampilkan pesan perpisahan dan kembali ke halaman login.


# Tugas 8
## const di Flutter
Sebagai keyword untuk mendeklarasikan objek yang bersifat immutable dan compiled-time constant, nilai objek ditentukan pada saat kompilasi, bukan pada runtime. Ketika const ditandai pada widget atau objek, Flutter dideklarasikan bahwa objek tidak akan berubah setelah dibuat, sehingga Flutter dapat mengoptimalkan cara widget tersebut diproses.

Beberapa keuntungan Flutter adalah:
1) Mengurangi penggunaan memori dan meningkatkan performa aplikasi -> Ketika objek diberi tanda const, Flutter hanya akan membuat satu instance dari objek tersebut, meskipun objek tersebut digunakan berkali-kali dalam aplikasi.
2) Widget const akan disimpan di dalam const pool dan digunakan kembali ketika dibutuhkan. 
3) Tidak perlu merender ulang widget yang sudah di-const karena Flutter tahu bahwa widget tidak akan berubah. 

- Kapan const dapat digunakan
const dapat digunakan pada widget yang tidak mengalami perubahan nilai atau tidak tergantung pada state dinamis, misalnya pada Text, Icon, dan Padding. Contoh pada kode saya:
```
const Text('BeliBaju', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
```
Tujuan diberikan const adalah agar tidak ada instance baru yang dibuat setiap kali widget dibuat kembali.

- Kapan const sebaiknya tidak digunakan
Pada widget seperti InkWell yang berinteraksi dengan pengguna, sebaiknya tidak diberi const karena widget memerlukan pembaruan saat ada interaksi, contoh ketika tombol ditekan. Contoh pada kode saya:
```
InkWell(
  onTap: () {
  },
  child: Container(
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(item.icon, color: Colors.white, size: 30.0),
        const Padding(padding: EdgeInsets.all(3)),
        Text(item.name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
      ],
    ),
  ),
);

```

## Penggunaan Column dan Row pada Flutter
1) Column

Column digunakan untuk menyusun elemen secara vertikal, satu per satu dari atas ke bawah. Properti utamanya mencakup:
- children: List dari widget yang akan ditata secara vertikal.
- mainAxisAlignment: Untuk mengatur penataan elemen di sepanjang sumbu utama (vertikal untuk Column).
- crossAxisAlignment: Untuk mengatur penataan elemen di sepanjang sumbu silang (horizontal untuk Column).

Contoh penggunaan Column:
```
Column(
  mainAxisAlignment: MainAxisAlignment.center, // Menata elemen secara vertikal di tengah
  crossAxisAlignment: CrossAxisAlignment.start, // Menata elemen secara horizontal ke kiri
  children: <Widget>[
    Text('First Item'),
    Text('Second Item'),
    Text('Third Item'),
  ],
)
```
Lalu untuk contoh layoutnya adalah form dengan input teks, tombol vertikal.

2) Row 

Row digunakan untuk menyusun elemen secara horizontal, satu per satu dari kiri ke kanan. Properti utamanya mencakup:
- children: List dari widget yang akan ditata secara horizontal.
- mainAxisAlignment: Untuk mengatur penataan elemen di sepanjang sumbu utama (horizontal untuk Row).
- crossAxisAlignment: Untuk mengatur penataan elemen di sepanjang sumbu silang (vertikal untuk Row).

Contoh penggunaan Row:
```
Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround, // Menata elemen secara horizontal dengan jarak merata
  crossAxisAlignment: CrossAxisAlignment.center, // Menata elemen secara vertikal di tengah
  children: <Widget>[
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.settings),
  ],
)
```
Lalu untuk contoh layoutnya adalah menu dengan item horizontal, seperti tab.

## Elemen input pada product_form.dart
Semua elemen input saya memanfaatkan TextFormField, dilengkapi dengan validasi untuk memastikan bahwa input pengguna sesuai dengan format yang diinginkan. 

Dalam form, pilihan yang diminta, seperti nama produk, harga, deskripsi, jumlah, ukuran, dan warna lebih sesuai untuk input teks yang dibebaskan sesuai preferensi pengguna. Maka, penggunaan     `DropdownButtonFormField` akan lebih relevan jika pilihannya terbatas yang sudah ditentukan sebelumnya. Lalu, penggunaan `Radio` lebih cocok untuk kasus di mana pengguna diminta memilih satu opsi dari beberapa pilihan yang terbatas (seperti memilih kategori produk atau jenis pengiriman). Pada form, lagi-lagi semua input bersifat bebas.

## Tema (theme) dalam aplikasi Flutter
Saya sudah menerapkan tema pada aplikasi dengan mengatur warna pada beberapa elemen, seperti di bagian `AppBar` pada menu.dart dengan menggunakan:
```
backgroundColor: Theme.of(context).colorScheme.primary,
Pada bagian ini, warna latar belakang AppBar disesuaikan dengan tema yang diterapkan pada aplikasi, yang menunjukkan bahwa tema warna sudah diterapkan pada bagian tertentu.
```
Pada main.dart, saya telah melakukan:
- Pemanfaatan colorScheme warna primer (primarySwatch: Colors.deepPurple) dan warna sekunder (secondary: Colors.deepPurple[400]) untuk mendefinisikan palet warna utama aplikasi.
- Penggunaan `useMaterial3: true`, yang berarti menunjukkan bahwa aplikasi menggunakan Material Design 3 untuk memberi lebih banyak fleksibilitas dalam tampilan dan desain.

## Navigasi pada Flutter
1) Penggunaan Navigator.push()

Pada kode saya, saya menggunakan Navigator.push() untuk berpindah antar halaman. Contoh kode:
```
IconButton(
  icon: Icon(Icons.add),
  onPressed: () {
    // Navigasi ke halaman tambah produk
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductFormPage()),
    );
  },
)
```
2) Penggunaan Navigator.pushReplacement() di Drawer

Saya menggunakan Navigator.pushReplacement() untuk mengganti halaman yang sedang aktif dengan halaman baru. Contoh kode:
```
ListTile(
  leading: const Icon(Icons.add),
  title: const Text('Tambah Produk'),
  onTap: () {
    // Mengganti halaman yang sedang aktif dengan ProductFormPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProductFormPage()),
    );
  },
)
```

# Tugas 7


## Langkah Pengerjaan
----------------------------
### Langkah Pertama
- Pada file main.dart, saya adjust MaterialApp dengan tema warna yang saya inginkan:
```
theme: ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
    .copyWith(secondary: Colors.deepPurple[400]),
  useMaterial3: true,
),
```
### Langkah Kedua
- Pada file menu.dart, saya edit MyHomePage agar sifatnya menjadi StatelessWidget:
```
class MyHomePage extends StatelessWidget {
  final String npm = '2306165963';
  final String name = 'Aimee E.';
  final String className = 'PBP C';

  MyHomePage({super.key});
}
```
### Langkah Ketiga
- Di menu.dart, saya menambahkan InfoCard untuk menampilkan NPM, Nama, dan Kelas.
```
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}
```
### Langkah Keempat
- Saya kemudian membuat model ItemHomepage untuk setiap tombol.
```
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}
```
- Lalu saya mendeklarasikan daftar tombol di MyHomePage:
```
final List<ItemHomepage> items = [
  ItemHomepage("Lihat Daftar Produk", Icons.list, Color.fromARGB(255, 189, 151, 238)),
  ItemHomepage("Tambah Produk", Icons.add, Color.fromARGB(255, 237, 124, 162)),
  ItemHomepage("Logout", Icons.logout, Color.fromARGB(255, 152, 213, 247)),
];
```
- Saya kemudian mengimplementasikan ItemCard yang akan menampilkan setiap tombol:
```
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}")),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const SizedBox(height: 3),
                Text(item.name, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```
### Langkah Kelima
- Dalam build method di MyHomePage, saya menggabungkan semua komponen InfoCard dan ItemCard:
```
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'BeliBaju',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InfoCard(title: 'NPM', content: npm),
              InfoCard(title: 'Name', content: name),
              InfoCard(title: 'Class', content: className),
            ],
          ),
          const SizedBox(height: 16.0),
          Center(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: items.map((item) => ItemCard(item)).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
```


## Definisi & Perbedaan Stateless dan Stateful widget
Stateless widget merupakan jenis widget yang tidak memiliki state atau kondisi yang dapat berubah. Ketika widget ditampilkan, tampilannya tetap sesuai dengan yang sudah didefinisikan, tanpa memerlukan pembaruan akibat perubahan data atau interaksi pengguna. Misalnya, jika ada teks yang hanya ditampilkan tanpa perubahan atau tombol yang selalu terlihat sama meskipun diklik, stateless widget dapat digunakan. Stateless widget biasanya digunakan untuk elemen-elemen interface yang bersifat tetap, sehingga performanya cenderung lebih efisien karena tidak perlu memantau perubahan apapun.

Sebaliknya, stateful widget merupakan widget yang mampu mempertahankan dan memperbarui kondisinya seiring berjalannya aplikasi. Widget ini cocok digunakan ketika ada elemen yang membutuhkan pembaruan berdasarkan tindakan user atau perubahan data yang bersifat dinamis. Misalnya, tombol yang menampilkan jumlah "like" yang akan berubah setiap kali diklik atau formulir yang menampilkan pesan validasi. Dalam Flutter, pembaruan biasanya dilakukan dengan memanggil metode setState(), yang memberitahu Flutter untuk memperbarui tampilan sesuai dengan perubahan data atau kondisi terbaru.

Perbedaan utama antara stateless widget dan stateful widget adalah kemampuannya untuk mempertahankan dan memperbarui kondisi internal. Stateless widget digunakan untuk elemen statis, sementara stateful widget dirancang untuk elemen yang membutuhkan pembaruan antarmuka secara dinamis.

Dalam konteks kode saya, MyHomePage didefinisikan sebagai stateless widget karena hanya menampilkan informasi statis seperti NPM, Nama, dan Kelas melalui kartu (InfoCard) serta menampilkan daftar tombol tindakan (Lihat Daftar Produk, Tambah Produk, Logout). Tampilan tidak mengalami perubahan kondisi yang membutuhkan pembaruan setelah elemen-elemen tersebut di-render. Sekalipun user berinteraksi dengan tombol, tampilan dari MyHomePage tetap sama dan hanya memunculkan snackbar sebagai bentuk respons.

## Widget yang digunakan
1) MaterialApp

Widget utama dalam aplikasi Flutter yang berfungsi untuk mengatur tema dan struktur dasar dari aplikasi. Saya mendefinisikannya di main.dart pada class MyApp, di mana title untuk aplikasi diatur dan skema warna disesuaikan. Parameter theme mengatur tema tampilan, sementara home menunjuk halaman utama aplikasi, yaitu MyHomePage.

2) Scaffold

Widget yang menyediakan kerangka halaman dasar, termasuk AppBar dan body. Pada MyHomePage, Scaffold digunakan untuk membuat struktur tampilan aplikasi dengan appBar, body, dan pengaturan padding di dalamnya.

3) AppBar

Widget untuk menampilkan bagian atas halaman yang memiliki judul, yang saya deklarasikan "BeliBaju". Warna latar belakangnya diambil dari skema warna utama, dan teksnya berwarna putih tebal.

4) Padding

Widget yang menambahkan jarak atau ruang di sekitar widget tertentu. Dalam MyHomePage, Padding digunakan pada seluruh body dan juga pada beberapa elemen di dalam Column, untuk membuat tampilan lebih rapi dengan jarak yang teratur.

5) Column

Widget yang menyusun anak-anaknya secara vertikal. Column di MyHomePage mengatur layout bagian dalam Scaffold dan memuat beberapa widget seperti Row, Text, dan GridView. crossAxisAlignment diatur untuk membuat elemen-elemen tetap berada di tengah secara horizontal.

6) Row

Widget yang menyusun widget anaknya secara horizontal. Digunakan di dalam MyHomePage untuk menampilkan InfoCard dalam baris yang sejajar.

7) Text

Widget dasar untuk menampilkan teks. Dalam AppBar, Text digunakan untuk judul, dan di Column digunakan untuk menampilkan pesan sambutan "Welcome to BeliBaju!". Pada InfoCard, Text juga digunakan untuk menampilkan judul dan konten dari setiap kartu informasi.

8) GridView.count

Widget yang menampilkan widget anak dalam bentuk grid (tabel). GridView.count dipakai di MyHomePage untuk menyusun ItemCard dengan tiga kolom, menggunakan crossAxisCount untuk menentukan jumlah kolom. Dengan shrinkWrap diatur ke true, GridView menyesuaikan tingginya agar sesuai dengan jumlah elemen yang ada.

9) Card

Widget yang menampilan berbentuk kotak dengan bayangan, sehingga tampak lebih menonjol dari latar belakang. Di InfoCard, Card digunakan untuk menampilkan setiap informasi NPM, Nama, dan Kelas dengan desain kotak yang sederhana.

9) Container

Widget yang menyediakan pengaturan dasar seperti ukuran, padding, margin, dan dekorasi. Di dalam InfoCard, Container digunakan untuk mengatur ukuran dan padding dari Card, serta pada ItemCard untuk mengatur posisi icon dan teks.

10) Center

Widget yang enyusun widget anaknya agar berada tepat di tengah, baik secara horizontal maupun vertikal. Dalam MyHomePage, Center dipakai untuk memposisikan Column yang berisi teks sambutan dan GridView.

11) InfoCard

Custom widget StatelessWidget yang saya buat untuk menampilkan kartu informasi. InfoCard menampilkan title dan content yang diberikan, dalam bentuk teks yang tersusun vertikal, dengan sedikit bayangan untuk menonjolkan tampilan kartu.

12) ItemCard

Custom widget lainnya yang berfungsi untuk menampilkan kartu dengan icon dan teks. ItemCard menggunakan Material untuk membuat tampilan yang mengikuti skema tema warna aplikasi dan menggunakan InkWell untuk memberikan efek interaktif saat ditekan.

13) Material

Latar belakang kartu yang dapat diwarnai. Dengan color yang mengambil nilai dari item.color.

14) InkWell

Widget interaktif yang menampilkan efek animasi ketika ditekan. Dalam ItemCard, InkWell membungkus Container untuk memberikan efek sentuhan saat kartu ditekan.

15) Icon

Widget untuk menampilkan icon. Di dalam ItemCard, Icon digunakan untuk menampilkan ikon sesuai dengan icon yang diberikan pada setiap ItemHomepage.

16) SnackBar

Menampilkan pesan singkat di bagian bawah layar. Ketika setiap ItemCard ditekan, SnackBar menampilkan pesan yang menunjukkan tombol apa yang telah ditekan pengguna.

17) ScaffoldMessenger

Mengatur penampilan SnackBar pada Scaffold. Dalam ItemCard, ScaffoldMessenger digunakan untuk memunculkan dan menyembunyikan SnackBar saat kartu ditekan.

## setState()
setState() berfungsi untuk memperbarui tampilan ketika ada perubahan pada data atau status dalam sebuah stateful widget. Secara teknis, ketika setState() dipanggil, Flutter diberitahu bahwa ada perubahan pada data atau kondisi internal yang memerlukan render ulang untuk menampilkan tampilan terbaru. Artinya, metode build() akan dipanggil ulang oleh framework agar seluruh elemen di widget tersebut dapat memperbarui tampilannya sesuai dengan nilai-nilai yang telah diubah.

Variabel-variabel yang terdampak oleh setState() biasanya adalah variabel dinamis yang sifatnya dapat berubah selama aplikasi berjalan. Variabel-variabel tersebut dideklarasikan dalam kelas yang mewarisi State dari widget tersebut. Contoh dari variabel yang terdampak bisa berupa status login user, teks yang berubah berdasarkan aksi user, atau nilai-nilai lain yang mempengaruhi tampilan visual di layar.

## Perbedaan const dan final
final merupakan penanda bahwa variabel hanya dapat diberikan nilai satu kali, artinya nilai variabel ini tetap setelah pertama kali diinisialisasi. Akan tetapi, nilai tersebut baru diatur saat aplikasi berjalan (runtime). Jadi, final cocok untuk data yang diperoleh atau diproses saat aplikasi berjalan, tetapi yang tetap tidak akan berubah setelah itu. Contohnya adalah mengambil data dari user atau server dan menyimpannya dalam variabel yang bersifat tetap.

const memastikan bahwa nilai variabel sudah ditentukan dan disimpan langsung di kode sebelum aplikasi dijalankan (compile-time constant). Artinya, nilai tersebut sudah harus ditentukan pada saat kompilasi dan tidak dapat diubah, bahkan oleh lingkungan runtime. const lebih cocok digunakan untuk nilai-nilai yang benar-benar tetap dan bisa dipastikan sebelumnya, seperti angka tetap, warna tertentu, atau string yang tidak akan berubah.

Perbedaan antara const dan final berkaitan dengan kapan nilai dari sebuah variabel ditentukan dan sifat ketetapannya setelah itu. Keduanya digunakan untuk nilai yang tidak akan berubah setelah dideklarasikan, namun ada perbedaan mendasar dalam penggunaannya.

Dalam kode saya, penggunaan final terdapat pada deklarasi variabel seperti npm, name, dan className di dalam kelas MyHomePage. Variabel-variabel tersebut ditandai dengan final karena nilainya hanya ditentukan satu kali saat objek MyHomePage dibuat dan tidak akan berubah setelah itu, meskipun selama aplikasi berjalan (runtime). Misalnya, nilai npm akan tetap sama sepanjang waktu aplikasi berjalan.

Untuk const, contohnya seperti Text dan Padding dalam kode MyHomePage. Pada kode saya, Text yang menampilkan "Welcome to BeliBaju!" ditandai sebagai const, yang berarti teks tidak akan berubah, sehingga Flutter dapat menghemat memori dan waktu komputasi dengan hanya membuatnya satu kali saja di awal.
