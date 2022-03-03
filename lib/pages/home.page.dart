import 'package:banking_app/configs/colours.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../models/transfer.dart';
import './home.page/home.dart';
import './home.page/view.users.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.users, required this.transfers})
      : super(key: key);

  final Users users;
  final Transfers transfers;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bnbSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighten(Theme.of(context).primaryColorLight),
      appBar: AppBar(
        title: Text(
          "Banking",
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
        backgroundColor:
            lighten(Theme.of(context).primaryColorLight, factor: 0.1),
      ),
      body: _bnbSelected == 0
          ? MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: widget.transfers,
                ),
              ],
              child: HomePageHome(
                users: widget.users,
              ),
            )
          : _bnbSelected == 1
              ? MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(
                      value: widget.users,
                    ),
                    ChangeNotifierProvider.value(
                      value: widget.transfers,
                    ),
                  ],
                  child: const HomePageViewUsers(),
                )
              : Container(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            lighten(Theme.of(context).primaryColorLight, factor: 0.1),
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor:
            Theme.of(context).primaryColorDark.withOpacity(0.5),
        currentIndex: _bnbSelected,
        onTap: (value) => setState(() => _bnbSelected = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "View Users",
          ),
        ],
      ),
    );
  }
}
