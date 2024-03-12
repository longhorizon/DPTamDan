import 'package:flutter/material.dart';

class Blog {
  final String title;
  final String imageUrl;
  final String description;

  Blog(
      {required this.title, required this.imageUrl, required this.description});
}

class BlogScreen extends StatelessWidget {
  final List<Blog> blogs = [
    Blog(
      title: 'Đái tháo đường',
      imageUrl: 'https://via.placeholder.com/150',
      description: 'Intro',
    ),
    Blog(
      title: 'Viêm phổi',
      imageUrl: 'https://via.placeholder.com/150',
      description: 'Intro',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Thư viện bệnh lý',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xffc34238),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          return _blogItem(index);
        },
      ),
    );
  }

  Widget _blogItem(int index) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(blogs[index].imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blogs[index].title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                blogs[index].description,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
