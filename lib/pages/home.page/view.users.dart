import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../models/transfer.dart';
import '../../pages/user.page.dart';
import '../../configs/colours.dart';

class HomePageViewUsers extends StatelessWidget {
  const HomePageViewUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context);
    final transfers = Provider.of<Transfers>(context, listen: false);
    final ids = users.get.keys.toList();

    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Padding(
          key: Key(users.get[ids[index]].toString()),
          padding: index == 0
              ? const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10)
              : const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: Text(
                    "View Users",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? lighten(Theme.of(context).primaryColorLight,
                              factor: 0.25)
                          .withOpacity(0.8)
                      : Theme.of(context).primaryColorLight.withOpacity(0.8),
                  // color: Theme.of(context).primaryColorLight.withOpacity(0.75),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider.value(
                                value: users.get[ids[index]],
                              ),
                              ChangeNotifierProvider.value(
                                value: transfers,
                              ),
                            ],
                            child: UserPage(
                              colourIndex: index,
                              users: users,
                            ),
                          ),
                        ),
                      );
                    },
                    splashColor: colours[index]["colour"],
                    hoverColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Hero(
                            tag: "avatar-${users.get[ids[index]]!.id}",
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: colours[index]["colour"],
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  users.get[ids[index]]!.getAvatar,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: colours[index]["textColour"],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  users.get[ids[index]]!.name,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  users.get[ids[index]]!.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: darken(
                                        Theme.of(context).primaryColorDark,
                                        factor: 0.3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: ids.length,
    );
  }
}
