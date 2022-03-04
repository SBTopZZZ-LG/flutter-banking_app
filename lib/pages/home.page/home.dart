import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../models/transfer.dart';
import '../../configs/colours.dart';
import '../user.page.dart';

// ignore: must_be_immutable
class HomePageHome extends StatelessWidget {
  HomePageHome({Key? key, required this.users}) : super(key: key);

  final Users users;

  var date = DateFormat.MMMEd();
  var time = DateFormat("hh:MM a");

  @override
  Widget build(BuildContext context) {
    final transfers = Provider.of<Transfers>(context);

    if (transfers.get.isEmpty) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
            child: Text(
              "Home",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
          const SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    height: 0.5,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "No transfer records available",
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    height: 0.5,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          DateTime datetime = DateTime.fromMillisecondsSinceEpoch(
              transfers.get[index].datetime);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 15),
                    child: Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
                if (index == 0 ||
                    (index > 0 &&
                        date.format(DateTime.fromMillisecondsSinceEpoch(
                                transfers.get[index - 1].datetime)) !=
                            date.format(datetime))) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          date.format(datetime),
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            height: 0.5,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (index == 0 ||
                    (index > 0 &&
                        time.format(DateTime.fromMillisecondsSinceEpoch(
                                transfers.get[index - 1].datetime)) !=
                            time.format(datetime))) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Text(
                        time.format(datetime),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: darken(Theme.of(context).primaryColorDark),
                        ),
                      ),
                    ),
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        // style: ButtonStyle(
                        //   overlayColor: MaterialStateColor.resolveWith(
                        //     (states) => colours[transfers.get[index].from - 1]
                        //         ["colour"]!,
                        //   ),
                        // ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              width: 1,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.6)),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              users.get[transfers.get[index].from]!.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: darken(
                                    Theme.of(context).primaryColorDark,
                                    factor: 0.05),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider.value(
                                    value: users.get[transfers.get[index].from],
                                  ),
                                  ChangeNotifierProvider.value(
                                    value: transfers,
                                  ),
                                ],
                                child: UserPage(
                                  colourIndex: transfers.get[index].from - 1,
                                  users: users,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                height: 0.5,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                  horizontal: 6,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "\$ ${transfers.get[index].amount}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                height: 0.5,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          // style: ButtonStyle(
                          //   overlayColor: MaterialStateColor.resolveWith(
                          //     (states) => colours[transfers.get[index].from - 1]
                          //         ["colour"]!,
                          //   ),
                          // ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1,
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.6)),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                users.get[transfers.get[index].to]!.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: darken(
                                      Theme.of(context).primaryColorDark,
                                      factor: 0.05),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => MultiProvider(
                                  providers: [
                                    ChangeNotifierProvider.value(
                                      value: users.get[transfers.get[index].to],
                                    ),
                                    ChangeNotifierProvider.value(
                                      value: transfers,
                                    ),
                                  ],
                                  child: UserPage(
                                    colourIndex: transfers.get[index].to - 1,
                                    users: users,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: transfers.get.length,
      ),
    );
  }
}
