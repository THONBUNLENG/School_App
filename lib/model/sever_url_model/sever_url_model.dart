

import 'package:school_app/model/model.dart';


class NewsService {
  Future<List<NewsModel>> fetchNews() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      NewsModel(
        id: 1,
        title: 'Congratulations on the Graduation Ceremony of BELTEI Senior High School...',
        imageUrl: 'https://www.beltei.edu.kh/uploaded/university/news/images/536/f5bf0529-b.jpg',
        date: '1 week ago',
        views: 86,
        link: 'https://www.beltel.edu.kh/eng/news1.html',
      ),
      NewsModel(
        id: 2,
        title: 'The Graduation Ceremony of BELTEI ESL DIPLOMA to 448 level 12 students...',
        imageUrl: 'https://www.beltei.edu.kh/uploaded/university/news/images/516/9b31feae-6.jpg',
        date: '2 weeks ago',
        views: 111,
        link: 'https://www.beltei.edu.kh/news/detail/516',
      ),
      NewsModel(
        id: 3,
        title: 'BELTEI International School organized the 15th Study Tour to Siem Reap...',
        imageUrl: 'https://www.beltei.edu.kh/uploaded/university/news/images/515/259e6219-4.jpg',
        date: '3 weeks ago',
        views: 245,
        link: 'https://www.beltei.edu.kh/news/detail/515',
      ),
      NewsModel(
        id: 4,
        title: '" Congratulations on the Graduation Ceremony of BELTEI Senior High School Diploma to 2680 Grade 12 Students in General Education Program, Batch 20, in Academic Year 2024-2025"',
        imageUrl: 'https://www.beltei.edu.kh/uploaded/university/news/images/499/7f0a2815-6.jpg',
        date: '3 weeks ago',
        views: 245,
        link: 'https://www.beltei.edu.kh/news/detail/499',
      ),
    ];
  }
}
