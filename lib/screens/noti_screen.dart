import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../models/notification_data.dart';
import '../blocs/noti_bloc.dart';
import '../events/noti_event.dart';
import '../states/noti_state.dart';

class ListNotiScreen extends StatefulWidget {
  const ListNotiScreen({super.key});

  @override
  State<ListNotiScreen> createState() => _ListNotiScreenState();
}

class _ListNotiScreenState extends State<ListNotiScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotiScreenBloc>().add(FetchDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<NotiScreenBloc, NotiScreenState>(
      listener: (context, state) {
        if (state is ErrorState && state.errorsCode == 419) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Phiên đăng nhập đã hết hạn'),
              content: Text('Vui lòng đăng nhập lại để tiếp tục.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('ok'),
                ),
              ],
            ),
          );
        }
      },
      child: BlocBuilder<NotiScreenBloc, NotiScreenState>(
        builder: (context, state) {
          if (state is LoadedState) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/home-bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  _buildHead(context),
                  const SizedBox(height: 30.0),
                  Expanded(
                    child: state.notis.length > 0
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (NotificationData item in state.notis)
                                  NotiWidget(
                                    noti: item,
                                  ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text("Hiện không có thông báo mới!"),
                          ),
                  ),
                ],
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
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
            "Thông báo",
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

class NotiWidget extends StatelessWidget {
  final NotificationData noti;

  NotiWidget({required this.noti});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noti.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Container(height: 2, color: Colors.blueAccent),
            SizedBox(height: 8.0),
            // Text(
            //   noti.description,
            //   style: TextStyle(
            //     fontSize: 18.0,
            //     fontWeight: FontWeight.normal,
            //   ),
            // ),
            HtmlWidget(noti.description),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
