import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contact_page.dart';

class ProductDetails extends StatefulWidget {
  final String thumbnail;
  final String title;
  final String description;

  const ProductDetails({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.description,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              Hero(
                tag: widget.thumbnail,
                child: Image.network(widget.thumbnail,height: screenHeight/2,width: double.infinity,),
              ),
              SizedBox(height: 10), // Example of adding space
              Column(
                children: [
                  Text(
                    'Product Name: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white, // Changed color for better visibility on gradient
                      fontStyle: GoogleFonts.poppins().fontStyle,
                      overflow: TextOverflow.ellipsis,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white, // Changed color for better visibility on gradient
                      fontStyle: GoogleFonts.poppins().fontStyle,
                      overflow: TextOverflow.ellipsis,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Example of adding space
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Description: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white70, // Changed color for better visibility on gradient
                      fontStyle: GoogleFonts.poppins().fontStyle,
                      overflow: TextOverflow.ellipsis,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white70, // Changed color for better visibility on gradient
                      fontStyle: GoogleFonts.poppins().fontStyle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
