import 'package:flutter/material.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';

class UsersListCard extends StatelessWidget {
  final UsersListResponse user;
  const UsersListCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            width: 2, color: Theme.of(context).colorScheme.onSecondary),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              user.username,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(user.email),
            Text(user.firstName),
            Text(user.lastName),
          ],
        ),
      ),
    );
  }
}
