import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/product_details.dart';

import 'form_page.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchProducts();
    debugPrint(widget.username);
  }

  List<Map<String, dynamic>> productList = [];
  int _counter = 0;
  bool isLoading = false;
  String errorMessage = '';
  bool _floatingLoading = false;
  String _messageAction = 'Upload';

  Future<void> _checkPrint() async {
    setState(() {
      _floatingLoading = true;
    });
    await Future.delayed(Duration(seconds: 3), () {
      debugPrint("Ronaldo");
    });

    setState(() {
      _floatingLoading = false;
      _messageAction = 'Uploaded';
    });
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('--------------Data-------------');
        debugPrint(data.toString());
        debugPrint('--------------Finish-------------');
        setState(() {
          productList = List<Map<String, dynamic>>.from(data['products']);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching products: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        centerTitle: true,
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () {
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage()));
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              if (_counter > 0) {
                setState(() {
                  _counter--;
                });
              }
              return;
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchProducts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchProducts,
              child: productList.isEmpty
                  ? const Center(child: Text('No products available'))
                  : ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        final product = productList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  thumbnail: product['thumbnail'].toString(),
                                  title: product['title'].toString(),
                                  description: product['description']
                                      .toString(),
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Hero(
                              tag: product['thumbnail'].toString(),
                              child: Image.network(
                                product['thumbnail'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                              ),
                            ),
                            title: Text(product['title']),
                            subtitle: Text(
                              product['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
