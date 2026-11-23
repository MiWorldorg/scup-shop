import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sculpture_shop/core/widgets/async_state_view.dart';
import 'package:sculpture_shop/features/admin_panel/users/data/entity/users_list_response.dart';
import 'package:sculpture_shop/features/admin_panel/users/presentation/controllers/users_manage_controller.dart';
import 'package:sculpture_shop/features/admin_panel/users/presentation/widgets/users_list_card_widget.dart';

class UsersWidget extends GetView<UsersManageController> {
  UsersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Users & roles',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Obx(
                  () => IconButton.filledTonal(
                    tooltip: 'Refresh accounts',
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.fetchLatestUsers(),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Review customer accounts and manage administrator access.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.68),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: const InputDecoration(
                hintText: 'Search by name, username, or email',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _RoleFilterChip(
                    label: 'All accounts',
                    value: 'all',
                    selectedValue: controller.roleFilter.value,
                    onSelected: (value) => controller.roleFilter.value = value,
                  ),
                  _RoleFilterChip(
                    label: 'Customers',
                    value: 'user',
                    selectedValue: controller.roleFilter.value,
                    onSelected: (value) => controller.roleFilter.value = value,
                  ),
                  _RoleFilterChip(
                    label: 'Administrators',
                    value: 'admin',
                    selectedValue: controller.roleFilter.value,
                    onSelected: (value) => controller.roleFilter.value = value,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => AsyncStateView(
                isLoading: controller.isLoading.value,
                errorMessage: controller.errorMessage.value,
                isEmpty: controller.visibleUsers.isEmpty,
                emptyMessage:
                    controller.searchQuery.value.isEmpty &&
                        controller.roleFilter.value == 'all'
                    ? 'No user accounts were found.'
                    : 'No accounts match your search and role filters.',
                onRetry: () => controller.fetchLatestUsers(),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.visibleUsers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final user = controller.visibleUsers[index];
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Obx(
                        () => UsersListCard(
                          user: user,
                          isUpdating: controller.updatingUserIds.contains(
                            user.id,
                          ),
                          onRoleChanged: (role) =>
                              _confirmRoleChange(context, user, role),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Obx(() {
              if (controller.totalUsers.value == 0) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Page ${controller.currentPage.value} of ${controller.lastPage.value} · ${controller.totalUsers.value} accounts',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurface.withOpacity(0.65),
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Previous page',
                      onPressed:
                          controller.isLoading.value ||
                              controller.currentPage.value <= 1
                          ? null
                          : () => controller.goToPage(
                              controller.currentPage.value - 1,
                            ),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filledTonal(
                      tooltip: 'Next page',
                      onPressed:
                          controller.isLoading.value ||
                              controller.currentPage.value >=
                                  controller.lastPage.value
                          ? null
                          : () => controller.goToPage(
                              controller.currentPage.value + 1,
                            ),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRoleChange(
    BuildContext context,
    UsersListResponse user,
    String role,
  ) async {
    if (user.role == role) return;
    final isPromotion = role == 'admin';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          isPromotion
              ? 'Grant administrator access?'
              : 'Remove administrator access?',
        ),
        content: Text(
          isPromotion
              ? 'This account will be able to manage the shop and change account roles.'
              : 'This account will lose access to the admin panel.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(isPromotion ? 'Grant access' : 'Remove access'),
          ),
        ],
      ),
    );

    if (confirmed == true) await controller.updateRole(user, role);
  }
}

class _RoleFilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const _RoleFilterChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: value == selectedValue,
      onSelected: (_) => onSelected(value),
    );
  }
}
