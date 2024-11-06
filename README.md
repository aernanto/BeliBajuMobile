Nama: Aimee E.

NPM: 2306165963

Kelas: PBP C

E-Commerce: Clothing

Nama e-commerce: BeliBaju


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
