import 'dart:ui';

import 'package:banking_app/configs/colours.dart';
import 'package:banking_app/widgets/clipper.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
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
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? lighten(Theme.of(context).primaryColorLight, factor: 0.15)
              : darken(Theme.of(context).primaryColorLight, factor: 0.05),
      // appBar: AppBar(
      //   title: Text(
      //     "Banking",
      //     style: TextStyle(
      //       color: Theme.of(context).primaryColorDark,
      //     ),
      //   ),
      //   shadowColor: Colors.black.withOpacity(0.2),
      //   centerTitle: true,
      //   backgroundColor:
      //       lighten(Theme.of(context).primaryColorLight, factor: 0.1),
      // ),
      body: Stack(
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -65.0, 0.0),
            child: ClipPath(
              clipper: BgClipper$(),
              child: Container(
                color: Colors.black.withOpacity(0.125),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Container(
              transform: Matrix4.translationValues(0.0, -65.0, 0.0),
              // color: Colors.white.withOpacity(0.25),
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0.0, -65.0, 0.0),
            child: ClipPath(
              clipper: BgClipper$(),
              child: Container(
                color: lighten(Theme.of(context).primaryColorLight),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.monetization_on,
              size: 125,
              color: MediaQuery.of(context).platformBrightness ==
                      Brightness.light
                  ? darken(Theme.of(context).primaryColorLight, factor: 0.15)
                  : lighten(Theme.of(context).primaryColorLight),
            ),
          ),
          if (_bnbSelected == 0) ...[
            MultiProvider(
              providers: [
                ChangeNotifierProvider.value(
                  value: widget.transfers,
                ),
              ],
              child: HomePageHome(
                users: widget.users,
              ),
            ),
          ] else if (_bnbSelected == 1) ...[
            MultiProvider(
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
          ],
        ],
      ),
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        elevation: 30,
        borderRadius: 20,
        selectedBackgroundColor:
            lighten(Theme.of(context).primaryColorLight, factor: 0.4),
        backgroundColor:
            lighten(Theme.of(context).primaryColorLight, factor: 0.3),
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor:
            Theme.of(context).primaryColorDark.withOpacity(0.5),
        currentIndex: _bnbSelected,
        onTap: (value) => setState(() => _bnbSelected = value),
        items: [
          FloatingNavbarItem(
            icon: Icons.home,
            title: "Home",
          ),
          FloatingNavbarItem(
            icon: Icons.list,
            title: "View Users",
          ),
        ],
      ),
    );
  }
}
