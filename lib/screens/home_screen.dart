import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/auth/firebase_auth_service.dart';
import 'package:flutter_firebase/global/toast.dart';
import 'package:flutter_firebase/providers/remote_config_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> productsList = [];
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool discountEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchConfig();
  }

  Future<void> _fetchConfig() async {
    final remoteConfigProvider = Provider.of<RemoteConfigProvider>(context, listen: false);
    await remoteConfigProvider.fetchRemoteConfig();
    setState(() {
      discountEnabled = remoteConfigProvider.enableDiscount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "e-Shop",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "Poppins",
            ),
          ),
          backgroundColor: Color(0xff0C54BE),
          actions: [
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.logout),
              onPressed: _signOut,
            ),
          ],
        ),
        body: FutureBuilder(
          future: getProductsData("https://dummyjson.com/products"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final productsList = snapshot.data;
            return Container(
              color: Color(0xffF5F9FD),
              padding: EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 5,
                ),
                itemCount: productsList.length,
                itemBuilder: (context, index) {
                  final product = productsList[index];
                  final title = product['title'];
                  final thumbnail = product['thumbnail'];
                  final description = product['description'];
                  final price = product['price'];
                  final discountPercentage = product['discountPercentage'];
                  final discountedPrice = (price - (price * discountPercentage / 100)).toStringAsFixed(2);
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 170,
                            width: double.infinity,
                            child: Image.network(thumbnail, fit: BoxFit.cover),
                          ),
                          SizedBox(height: 8),
                          Text(
                            title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Poppins",
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          discountEnabled
                              ? Row(
                                  children: [
                                    Text(
                                      '\$${price}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2.0,
                                        decorationColor: Colors.black,
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "\$${discountedPrice}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${discountPercentage}% off',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '\$${price}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> getProductsData(String url) async {
    print("Fetching product data");
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      productsList = json['products'];
      return productsList;
    } else {
      throw Exception('Failed to load products');
    }
  }

    Future<void> _signOut() async {
    await _auth.signOut();
    showToast(message: "SignOut successful");
    Navigator.pushNamed(context, "/");
  }
}
