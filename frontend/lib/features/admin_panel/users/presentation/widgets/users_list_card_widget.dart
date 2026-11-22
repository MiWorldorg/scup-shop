import 'package:flutter/material.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';

class UsersListCard extends StatelessWidget {
  final UsersListResponse user;
  final bool isUpdating;
  final ValueChanged<String> onRoleChanged;

  const UsersListCard({
    super.key,
    required this.user,
    required this.isUpdating,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isAdmin = user.role == 'admin';
    final name = '${user.firstName} ${user.lastName}'.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.onSurface.withOpacity(0.08)),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colors.primary.withOpacity(0.14),
            foregroundColor: colors.primary,
            child: Text(
              name.isNotEmpty ? name.characters.first.toUpperCase() : '?',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? user.username : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withOpacity(0.62),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUpdating)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            PopupMenuButton<String>(
              tooltip: 'Change account role',
              onSelected: onRoleChanged,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'user',
                  child: _RoleOption(
                    title: 'Customer',
                    selected: !isAdmin,
                    icon: Icons.person_outline_rounded,
                  ),
                ),
                PopupMenuItem(
                  value: 'admin',
                  child: _RoleOption(
                    title: 'Administrator',
                    selected: isAdmin,
                    icon: Icons.admin_panel_settings_outlined,
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: isAdmin
                      ? colors.primary.withOpacity(0.14)
                      : colors.onSurface.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAdmin
                          ? Icons.admin_panel_settings_outlined
                          : Icons.person_outline_rounded,
                      size: 16,
                      color: isAdmin ? colors.primary : colors.onSurface,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isAdmin ? 'Admin' : 'Customer',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: isAdmin ? colors.primary : colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.expand_more_rounded,
                      size: 16,
                      color: colors.onSurface.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String title;
  final bool selected;
  final IconData icon;

  const _RoleOption({
    required this.title,
    required this.selected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: selected ? colors.primary : null),
        const SizedBox(width: 10),
        Expanded(child: Text(title)),
        if (selected)
          Icon(Icons.check_rounded, size: 17, color: colors.primary),
      ],
    );
  }
}
