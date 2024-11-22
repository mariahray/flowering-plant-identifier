import 'package:flutter/material.dart';
import 'favorite.dart';

class FlowerDetail extends StatefulWidget {
  final Map<String, dynamic> flower;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  FlowerDetail({
    required this.flower,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  _FlowerDetailState createState() => _FlowerDetailState();
}

class _FlowerDetailState extends State<FlowerDetail> {
  late bool isFavorite;
  late List<String> additionalImages;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    String imagesString = widget.flower['additional_images'] ?? '';
    additionalImages = imagesString.isNotEmpty ? imagesString.split(',') : [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            if (widget.flower['coverphoto'] != null)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (widget.flower['coverphoto'] != null)
                    Container(
                      height: 279,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.flower['coverphoto']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  Positioned(
                    bottom: -22,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                            if (isFavorite) {
                              FavoriteManager().addFavorite(widget.flower['image']);
                            } else {
                              FavoriteManager().removeFavorite(widget.flower['image']);
                            }
                            widget.onFavoriteChanged(isFavorite);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isFavorite ? 'Added to bookmarks' : 'Removed from bookmarks'),
                            ),
                          );
                        },
                        icon: Icon(
                          isFavorite ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.green,
                        ),
                        label: Text(
                          isFavorite ? 'Remove from Bookmarks' : 'Add to Bookmarks',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(147, 218, 157, 1),
                          padding: EdgeInsets.all(0),
                          minimumSize: Size(209, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 25),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.flower['name'],
                      style: TextStyle(
                        fontFamily: "Mazzard-Medium",
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: Color.fromRGBO(56, 101, 58, 0.85),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Text(
                    'More Images',
                    style: TextStyle(
                      fontFamily: "Mazzard",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  additionalImages.isNotEmpty
                      ? GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: additionalImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullscreenGalleryView(
                                images: additionalImages,
                                initialIndex: index,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            additionalImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  )
                      : Text(
                    'No additional images available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 23.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(
                        fontFamily: "Mazzard",
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.flower['description'],
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}


class FullscreenGalleryView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  FullscreenGalleryView({required this.images, this.initialIndex = 0});

  @override
  _FullscreenGalleryViewState createState() => _FullscreenGalleryViewState();
}

class _FullscreenGalleryViewState extends State<FullscreenGalleryView> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  void _nextImage() {
    if (currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _prevImage() {
    if (currentIndex > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Large Image - the first image
          Positioned(
            top: 20,
            child: widget.images.isNotEmpty
                ? Image.asset(
              widget.images[0],
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.6,
            )
                : Center(child: CircularProgressIndicator()),
          ),
          // Smaller images (2nd to 5th)
          Positioned(
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length > 1 ? 4 : 0,
                    (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index + 1;
                          _pageController.jumpToPage(currentIndex);
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          widget.images[index + 1],
                          fit: BoxFit.cover,
                          height: 100.0,
                          width: 100.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // PageView for swiping images
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container();
            },
          ),
          if (currentIndex > 0)
            Positioned(
              left: 16.0,
              top: MediaQuery.of(context).size.height * 0.5,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 40),
                onPressed: _prevImage,
              ),
            ),
          if (currentIndex < widget.images.length - 1)
            Positioned(
              right: 16.0,
              top: MediaQuery.of(context).size.height * 0.5,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
                onPressed: _nextImage,
              ),
            ),
          Positioned(
            bottom: 30.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${currentIndex + 1}/${widget.images.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}