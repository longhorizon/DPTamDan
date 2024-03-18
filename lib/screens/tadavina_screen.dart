import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../const/const.dart';

class TadavinaScreen extends StatefulWidget {

  const TadavinaScreen({super.key});

  @override
  State<TadavinaScreen> createState() => _TadavinaScreenState();
}

class _TadavinaScreenState extends State<TadavinaScreen> {
  bool isLoading = false;
  String introduce = "";

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future fetchInfo() async {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('user_id').toString();
    String token = prefs.getString('token').toString();
    var uri = Uri.https(Constants.apiUrl, 'api/client/info');
    final Map<String, String> headers = {'Content-Type': 'text/plain'};
    final Map<String, dynamic> data = {
      "uid": uid,
      "token": token,
    };

    final http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 200) {
        setState(() {
          introduce = jsonResponse['result']['introduce'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load Tadavina info');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load Tadavina info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/home-bg.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          _buildHead(context),
          const SizedBox(height: 16.0),
          isLoading ? Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) :
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xfff7e7da),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(child: _builDetail(introduce)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _builDetail(String container) {
    return HtmlWidget(container);
  }



  Padding _buildHead(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            "Tadavina",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 40),
        ],
      ),
    );
  }

}

