import 'package:school_app/model/model.dart';

class NewsService {
  Future<List<NewsModel>> fetchNews() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      // ================= NEWS 1 =================
      NewsModel(
        id: 1,
        title: 'Nanjing University 2025 Graduation Ceremony',
        subtitle: 'Tan Zhemin: "Be a pioneer in the age of AI"',
        description: 'On June 22, Nanjing University held the 2025 Postgraduate Graduation Ceremony...',
        longDescription: '''
On June 22, Nanjing University held the 2025 Postgraduate Graduation Ceremony.

At the ceremony, Tan Zhemin encouraged graduates to embrace innovation and become pioneers in the age of artificial intelligence...
''',
        images: [
          'https://www.nju.edu.cn/__local/8/83/4C/1EA0F7B41F03D2AB6314A1EA991_A6F47C77_6AC7C.jpg',
          'https://www.nju.edu.cn/__local/8/AC/5F/C1D95CB95AF02A5EA52E8980F72_83A65F3A_3F7FA.jpg',
        ],
        date: '1 week ago',
        views: 86,
        link: 'https://www.nju.edu.cn/',
        category: 'Daily New',
      ),

      // ================= NEWS 2 =================
      NewsModel(
        id: 2,
        title: 'Nanjing University of the Arts',
        subtitle: 'Admission is going on for March/September Intake',
        description: 'Nanjing University of the Arts is the only comprehensive arts institution...',
        longDescription: '''
Nanjing University of the Arts (南京艺术大学) is the only comprehensive arts institution in Jiangsu Province, China...
''',
        images: [
          'https://nuaa.cucas.cn/uploads/school/2018/1101/a1a0efcb3bddd0c5d0823da438c1aec3.jpg',
          'https://njunju.nju.edu.cn/_upload/article/images/16/11/bc1369544f6db218cfc888d75045/f4a869f4-37aa-4b58-b74b-0b8099d6ca12.jpg',
        ],
        date: '2 weeks ago',
        views: 11177,
        link: 'https://nuaa.cucas.cn/',
        category: 'Announcement',
      ),

      // ================= NEWS 3 =================
      NewsModel(
        id: 3,
        title: 'A Brief History of NJU',
        subtitle: 'Sincerity with Aspiration, Perseverance with Integrity',
        description: 'Nanjing University is one of China’s oldest comprehensive universities...',
        longDescription: '''
Nanjing University, located in the historic city of Nanjing, has played a significant role in the development of China for over 120 years...
''',
        images: [
          'https://www.nju.edu.cn/en/images/f3.jpg',
          'https://iscl.nju.edu.cn/_upload/article/images/ee/aa/e8e2b7654780bd2dea917968cc90/69f8c5a3-cf47-4164-8ef9-5c49501a5f64.jpg',
        ],
        date: '3 weeks ago',
        views: 2345,
        link: 'https://www.nju.edu.cn/',
        category: 'Daily New',
      ),

      // ================= NEWS 4 =================
      NewsModel(
        id: 4,
        title: 'Video Lecture on Modern Art',
        subtitle: 'Watch the full lecture online',
        description: 'A lecture on modern art trends...',
        longDescription: 'Full video lecture on modern art...',
        images: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl3ut_Aqj2i-krOeRQkF0ziwpNIH9F0o8_4Q&s',
          'https://youtu.be/ovlCpiNFFfY?si=8kZI5YcvsUlWsudl', // YouTube thumbnail

        ],
        date: '4 weeks ago',
        views: 4521,
        link: 'https://youtu.be/ovlCpiNFFfY?si=IxaNuZry0Jsi5lmp',
        category: 'Videos',
      ),

    ];
  }
}
