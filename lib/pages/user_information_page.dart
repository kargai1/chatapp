import 'package:flutter/material.dart';

import '../model/user_model.dart';

class InformationScreen extends StatelessWidget {
  final UserModel user;
  const InformationScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user.name} ${user.surName}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Theme.of(context).cardColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      radius: 60, backgroundImage: NetworkImage(user.photoUrl)),
                ),
              ),
            ),
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Card(
            child: ListTile(
                title: Text('${user.name} ${user.surName}'),
                leading: Icon(
                  Icons.person_2_outlined,
                  color: Theme.of(context).iconTheme.color,
                )),
          ),
          const Divider(),
          Card(
            child: ListTile(
                title: Text(user.email),
                leading: Icon(
                  Icons.mail_outlined,
                  color: Theme.of(context).iconTheme.color,
                )),
          ),
          const Divider(),
          Card(
            child: ListTile(
                title: Text(user.description),
                leading: Icon(
                  Icons.message_outlined,
                  color: Theme.of(context).iconTheme.color,
                )),
          ),
          const Divider()
        ],
      ),
    );
  }
}
