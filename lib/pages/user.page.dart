import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transfer.dart';
import '../models/user.dart';
import '../configs/colours.dart';

class UserPage extends StatelessWidget {
  final int colourIndex;
  final Users users;

  const UserPage({Key? key, required this.colourIndex, required this.users})
      : super(key: key);

  void displayTransferOverlay(
      BuildContext context, Function(int, int) transfer) {
    final user = Provider.of<User>(context, listen: false);

    if (user.balance == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No balance!"),
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (ctx) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TransferModalSheetData(),
          ),
          ChangeNotifierProvider.value(
            value: user,
          ),
          ChangeNotifierProvider.value(
            value: Provider.of<Transfers>(context, listen: false),
          ),
        ],
        child: TransferModalSheet(
          users: users,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context); // Listen

    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.dark
              ? lighten(Theme.of(context).primaryColorLight, factor: 0.15)
              : darken(Theme.of(context).primaryColorLight, factor: 0.05),
      // appBar: AppBar(
      //   title: Text(
      //     "Banking",
      //     style: TextStyle(color: Theme.of(context).primaryColorDark),
      //   ),
      //   centerTitle: true,
      //   shadowColor: Colors.black.withOpacity(0.2),
      //   backgroundColor:
      //       lighten(Theme.of(context).primaryColorLight, factor: 0.1),
      // ),
      body: Stack(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Hero(
                  tag: "avatar-${user.id}",
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: colours[colourIndex]["colour"],
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        user.getAvatar,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: colours[colourIndex]["textColour"],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    user.name,
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 20,
                      color: darken(Theme.of(context).primaryColorDark,
                          factor: 0.3),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 13,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "\$ ${user.balance}",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      splashColor: colours[colourIndex]["colour"],
                      hoverColor: Colors.transparent,
                      onTap: () =>
                          displayTransferOverlay(context, (int id, int amount) {
                        users.get[id]!.balance += amount;
                        users.get[id]!.saveAndRefresh();

                        user.balance -= amount;
                        user.saveAndRefresh();

                        Transfer(
                          id: Transfer.safeId++,
                          from: user.id,
                          to: id,
                          amount: amount,
                          datetime: DateTime.now().millisecondsSinceEpoch,
                        ).saveAndRefresh();
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 1,
                            color: darken(Theme.of(context).primaryColorDark),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.money,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Transfer money",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: Theme.of(context).primaryColorDark,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Details",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Phone : ",
                              style: TextStyle(
                                fontSize: 18,
                                color: darken(
                                    Theme.of(context).primaryColorDark,
                                    factor: 0.1),
                              ),
                            ),
                            Text(
                              user.phone,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darken(
                                    Theme.of(context).primaryColorDark,
                                    factor: 0.05),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Occupation : ",
                          style: TextStyle(
                              fontSize: 18,
                              color: darken(Theme.of(context).primaryColorDark,
                                  factor: 0.1)),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            user.occupation,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darken(
                                    Theme.of(context).primaryColorDark,
                                    factor: 0.05)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransferModalSheetData extends ChangeNotifier {
  int _selectedId = 0;
  int get selectedId => _selectedId;

  final _amountController = TextEditingController();
  TextEditingController get amount => _amountController;

  void setSelected(int selectedId) {
    _selectedId = selectedId;
    notifyListeners();
  }
}

class TransferModalSheet extends StatelessWidget {
  final Users users;

  const TransferModalSheet({Key? key, required this.users}) : super(key: key);

  bool isValidInput(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    final data = Provider.of<TransferModalSheetData>(context, listen: false);

    try {
      int amount = int.parse(data.amount.text);
      if (amount <= 0) return false;
      if (amount > user.balance) return false;
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final data = Provider.of<TransferModalSheetData>(context);

    int colourIndex = 0;

    return Container(
      padding: const EdgeInsets.all(20),
      color: lighten(Theme.of(context).primaryColorLight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).primaryColorDark,
              ),
              const SizedBox(width: 10),
              Text(
                "Transfer to",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          DropdownButton(
            dropdownColor:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? lighten(Theme.of(context).primaryColorLight, factor: 0.3)
                    : darken(Theme.of(context).primaryColorLight, factor: 0.1),
            alignment: Alignment.center,
            elevation: 0,
            underline: const Opacity(
              opacity: 0,
            ),
            value: data.selectedId,
            items: <DropdownMenuItem<int>>[
              ...(users.get.keys.toList())
                  .map(
                    (userId) => userId == user.id
                        ? DropdownMenuItem(
                            child: Center(
                              child: Text(
                                "• Select a User •",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: darken(
                                      Theme.of(context).primaryColorDark),
                                ),
                              ),
                            ),
                            value: 0 * colourIndex++,
                          )
                        : DropdownMenuItem(
                            key: Key(users.get[userId]!.id.toString()),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: colours[colourIndex]
                                        ["colour"],
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        users.get[userId]!.getAvatar,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: colours[colourIndex++]
                                              ["textColour"],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      users.get[userId]!.name,
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            value: users.get[userId]!.id,
                          ),
                  )
                  .toList(),
            ],
            onChanged: (_selectedId) =>
                Provider.of<TransferModalSheetData>(context, listen: false)
                    .setSelected(_selectedId as int),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Icon(
                Icons.money,
                color: Theme.of(context).primaryColorDark,
              ),
              const SizedBox(width: 10),
              Text(
                "Amount",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: data.amount,
            keyboardType: const TextInputType.numberWithOptions(
              signed: false,
            ),
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).primaryColorDark,
            ),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              hintStyle: TextStyle(
                fontSize: 25,
                color: darken(Theme.of(context).primaryColorDark, factor: 0.4),
              ),
              hintText: "Amount (<= ${user.balance})",
              errorText: !isValidInput(context)
                  ? "Please enter a valid integer > 0 and <= ${user.balance}."
                  : null,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 13,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "\$ ${user.balance}",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_right,
                size: 40,
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 13,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "\$ ${user.balance - (isValidInput(context) ? int.parse(data.amount.text) : 0)}",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            borderRadius: BorderRadius.circular(15),
            splashColor: colours[user.id - 1]["colour"],
            hoverColor: Colors.transparent,
            onTap: isValidInput(context) && data.selectedId != 0
                ? () {
                    int amount = int.parse(data.amount.text);
                    user.balance -= amount;
                    user.saveAndRefresh();

                    users.get[data.selectedId]!.balance += amount;
                    users.get[data.selectedId]!.saveAndRefresh();

                    Transfer transfer = Transfer(
                      id: Transfer.safeId++,
                      from: user.id,
                      to: data.selectedId,
                      amount: amount,
                      datetime: DateTime.now().millisecondsSinceEpoch,
                    );
                    transfer.saveAndRefresh();

                    Provider.of<Transfers>(context, listen: false)
                        .get
                        .insert(0, transfer);
                    Provider.of<Transfers>(context, listen: false)
                        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                        .notifyListeners();

                    Navigator.of(context).pop();
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  width: 1,
                  color: isValidInput(context) && data.selectedId != 0
                      ? darken(Theme.of(context).primaryColorDark)
                      : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.money,
                        color: isValidInput(context) && data.selectedId != 0
                            ? Theme.of(context).primaryColorDark
                            : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Transfer money",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isValidInput(context) && data.selectedId != 0
                              ? Theme.of(context).primaryColorDark
                              : Colors.grey,
                        ),
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
  }
}
