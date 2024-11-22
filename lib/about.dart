import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/catbook.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildSection(
                        title: 'About TFF Flower Identifier',
                        content:
                            'The TFF Flower Identifier app aims to assist visitors of The Flower Farm in identifying various flowers found on the site. The app uses image recognition technology, allowing users to take a photo of any flower they come across and instantly receive information about it.',
                      ),
                      SizedBox(height: 20),
                      _buildSection(
                        title: 'About The Flower Farm',
                        content:
                            'The Flower Farm Corporation is considered one of the premier florists in the Philippines. They grow their own flowers primarily in their farm located in Tagaytay City. They are recognized as one of the pioneers in the cut flower industry of the Philippines for having introduced floral varieties never before grown in the country.',
                      ),
                      SizedBox(height: 20),
                      _buildSection(
                        title: 'About the Team',
                        content:
                            'This app was developed by a team of students in City College of Tagaytay as part of their capstone project.\n\n'
                            'Mariah Ray Rint – Project Manager/Developer\n'
                            'Andrea Paet – Developer\n'
                            'Eina Monique Angcaya – UI Designer\n'
                            'Jade Cezar – Quality Assurance',
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              height: 1.4,
              color: Colors.black87,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
