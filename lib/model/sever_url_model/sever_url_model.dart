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
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTT9VB6Y3DVXoHetxqrgXLZnDpLoPH4mQ7z2w&s',
          'https://nuist.cucas.cn/uploads/school/2023/0303/64a198cb2cde6673cbfaa19cc97002ca.jpg',
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
          'https://youtu.be/ovlCpiNFFfY?si=8kZI5YcvsUlWsudl',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl3ut_Aqj2i-krOeRQkF0ziwpNIH9F0o8_4Q&s',
          'https://images.adsttc.com/media/images/6841/3d4e/c985/fd01/8a4f/9dfc/slideshow/nanjing-university-suzhou-affiliated-primary-school-tus-design_2.jpg?1749106042'

        ],
        date: '4 weeks ago',
        views: 4521,
        link: 'https://youtu.be/ovlCpiNFFfY?si=IxaNuZry0Jsi5lmp',
        category: 'Videos',
      ),

      // ================= NEWS 5 =================
      NewsModel(
        id: 5,
        title: 'My application experience for Juris Masters of Law at Peking and Tsinghua University',
        subtitle: 'Watch the full lecture online',
        description: 'How I got into Peking and Tsinghua University! (Application Process)',
        longDescription: 'Full video lecture on modern art...',
        images: [
          'https://youtu.be/fpmcFU85NN8?si=K9v2iNRxBGDSPQiX',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThMK9smRg4dz6G6RnArhat3bUsoslNMN2khw&s',
          'https://www.nju.edu.cn/__local/A/2C/23/C07058A1CA1FF3FDC06477DE1EF_9CE05339_45892.jpg',
          'https://www.nju.edu.cn/__local/7/10/0D/FD5660863B0F028F7BF8E9F2409_5D7AF834_431EE.jpg',


        ],
        date: '1 weeks ago',
        views: 6521,
        link: 'https://youtu.be/fpmcFU85NN8?si=K9v2iNRxBGDSPQiX',
        category: 'Videos',
      ),
      // ================= NEWS 6 =================
      NewsModel(
        id: 6,
        title: 'Life as a Tsinghua University student | Studying Chinese at China best university!',
        subtitle: 'Watch the full lecture online',
        description: 'Hey guys! Check out my life as a foreign student studying Chinese at China''s best university, Tsinghua University in Beijing. Currently, I''m in the short-term Chinese Language Program for one semester. The classes and homework take up a great deal of my time, but I won''t be focussing on that in the video. The video will be mostly showcasing the student life, the campus itself and the surrounding environment. Note that the content is filmed from multiple days. Enjoy!',
        longDescription: 'Full video lecture on modern art...',
        images: [
          'https://youtu.be/sAuMM8E5Yak?si=MYXARmf1lG-aNgDY',
          'https://njunju.nju.edu.cn/_upload/article/images/21/83/658f65994b36925ab995bf8d9730/2ee1c4dc-b290-4dbe-86a1-a8f55c5852a7.png',
          'https://upload.wikimedia.org/wikipedia/commons/4/47/%E5%8D%97%E4%BA%AC%E5%A4%A7%E5%AD%B8%E4%BB%99%E6%9E%97%E6%A0%A1%E5%8D%80%E5%9C%96%E6%9B%B8%E9%A4%A8.jpg',
          'https://lh6.googleusercontent.com/proxy/y3X9RE3LPc7x6jDrJ1YdKLGiJ49VTReE7U0b_L0jgHf3dRyC4pRCbJHBgiT-VeR3F65QeEL18Igl-bS0i52KfiHSiuiU63Qarw',


        ],
        date: '1 day',
        views: 521,
        link: 'https://youtu.be/sAuMM8E5Yak?si=MYXARmf1lG-aNgDY',
        category: 'Videos',
      ),
    ];
  }
}
