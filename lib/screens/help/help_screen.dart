import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/legal_resources_service.dart';
import '../../utils/colors.dart';
import '../../l10n/app_localizations.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LegalResourcesService _resourcesService = LegalResourcesService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 130,
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 64),
              title: const Text(
                'Find Help',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.6,
                ),
              ),
              background: Container(color: AppColors.surface),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: AppColors.softShadow,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(3),
                  labelColor: AppColors.primary,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  unselectedLabelColor: AppColors.textSecondary,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: l10n.legalAid),
                    Tab(text: l10n.emergency),
                    Tab(text: l10n.schemes),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: [
            _LegalAidTab(
              resourcesService: _resourcesService,
              searchController: _searchController,
              searchQuery: _searchQuery,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
            ),
            _EmergencyTab(resourcesService: _resourcesService),
            _SchemesTab(resourcesService: _resourcesService),
          ],
        ),
      ),
    );
  }
}

// ── Legal Aid Tab ─────────────────────────────────────────────────────────────

class _LegalAidTab extends StatelessWidget {
  final LegalResourcesService resourcesService;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const _LegalAidTab({
    required this.resourcesService,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
              boxShadow: AppColors.softShadow,
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search legal aid, NGOs...',
                hintStyle: const TextStyle(
                    color: AppColors.textHint, fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.accent, size: 20),
                suffixIcon: searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () => onSearchChanged(''),
                        child: const Icon(Icons.close_rounded,
                            color: AppColors.textHint, size: 18),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 0),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<LegalResource>>(
            future: resourcesService.searchResources(query: searchQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.accent, strokeWidth: 2.5));
              }
              if (snapshot.hasError) {
                return _ErrorState(message: l10n.errorFetchingData);
              }
              final resources = snapshot.data ?? [];
              if (resources.isEmpty) {
                return _EmptyState(
                    icon: Icons.search_off_rounded,
                    message: l10n.noDataAvailable);
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: resources.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _ResourceCard(resource: resources[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Resource Card ─────────────────────────────────────────────────────────────

class _ResourceCard extends StatelessWidget {
  final LegalResource resource;
  const _ResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.business_center_rounded,
                    color: AppColors.accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Text(
                          '${resource.city}, ${resource.state}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (resource.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded,
                          size: 12, color: AppColors.success),
                      const SizedBox(width: 3),
                      Text(
                        l10n.verified,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (resource.description != null) ...[
            const SizedBox(height: 12),
            Text(
              resource.description!,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          if (resource.services != null &&
              resource.services!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: resource.services!.take(4).map((service) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    service,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              if (resource.phone != null)
                _ContactChip(
                  icon: Icons.phone_rounded,
                  label: l10n.call,
                  color: AppColors.success,
                  onTap: () async {
                    final url =
                        Uri(scheme: 'tel', path: resource.phone!);
                    if (await canLaunchUrl(url)) launchUrl(url);
                  },
                ),
              if (resource.email != null)
                _ContactChip(
                  icon: Icons.email_rounded,
                  label: l10n.emailLabel,
                  color: AppColors.accent,
                  onTap: () async {
                    final url =
                        Uri(scheme: 'mailto', path: resource.email!);
                    if (await canLaunchUrl(url)) launchUrl(url);
                  },
                ),
              if (resource.website != null)
                _ContactChip(
                  icon: Icons.language_rounded,
                  label: l10n.website,
                  color: AppColors.primary,
                  onTap: () async {
                    final url = Uri.parse(resource.website!);
                    if (await canLaunchUrl(url)) launchUrl(url);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContactChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Emergency Tab ─────────────────────────────────────────────────────────────

class _EmergencyTab extends StatelessWidget {
  final LegalResourcesService resourcesService;
  const _EmergencyTab({required this.resourcesService});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<Map<String, List<EmergencyContact>>>(
      future: resourcesService.getAllEmergencyCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.accent, strokeWidth: 2.5));
        }
        if (snapshot.hasError || snapshot.data == null) {
          return _ErrorState(message: l10n.errorFetchingData);
        }
        final categories = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories.keys.elementAt(index);
            final contacts = categories[category]!;
            return _EmergencyCategory(
                category: category, contacts: contacts);
          },
        );
      },
    );
  }
}

class _EmergencyCategory extends StatelessWidget {
  final String category;
  final List<EmergencyContact> contacts;

  const _EmergencyCategory(
      {required this.category, required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...contacts.map((c) => _EmergencyTile(contact: c)),
        ],
      ),
    );
  }
}

class _EmergencyTile extends StatelessWidget {
  final EmergencyContact contact;
  const _EmergencyTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.local_hospital_rounded,
                color: AppColors.error, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.description,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final url = Uri(scheme: 'tel', path: contact.number);
              if (await canLaunchUrl(url)) launchUrl(url);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: AppColors.errorGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.errorShadow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.call_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    contact.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
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

// ── Schemes Tab ───────────────────────────────────────────────────────────────

class _SchemesTab extends StatelessWidget {
  final LegalResourcesService resourcesService;
  const _SchemesTab({required this.resourcesService});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<GovernmentScheme>>(
      future: resourcesService.getGovernmentSchemes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
                  color: AppColors.accent, strokeWidth: 2.5));
        }
        if (snapshot.hasError) {
          return _ErrorState(message: l10n.errorFetchingData);
        }
        final schemes = snapshot.data ?? [];
        if (schemes.isEmpty) {
          return _EmptyState(
              icon: Icons.inbox_rounded, message: l10n.noDataAvailable);
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
          itemCount: schemes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _SchemeCard(scheme: schemes[index]),
        );
      },
    );
  }
}

class _SchemeCard extends StatelessWidget {
  final GovernmentScheme scheme;
  const _SchemeCard({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            collapsedBackgroundColor: AppColors.surface,
            backgroundColor: AppColors.surface,
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.infoTint,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.account_balance_rounded,
                  color: AppColors.accent, size: 22),
            ),
            iconColor: AppColors.accent,
            collapsedIconColor: AppColors.textHint,
            title: Text(
              scheme.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                scheme.description,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            childrenPadding:
                const EdgeInsets.fromLTRB(18, 0, 18, 18),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: AppColors.border),
              const SizedBox(height: 12),
              _SchemeSection(
                title: 'Eligibility',
                items: scheme.eligibility,
                icon: Icons.check_circle_rounded,
                color: AppColors.success,
              ),
              const SizedBox(height: 16),
              _SchemeSection(
                title: 'Benefits',
                items: scheme.benefits,
                icon: Icons.star_rounded,
                color: AppColors.warning,
              ),
              if (scheme.applicationProcess.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.description_rounded,
                        size: 16, color: AppColors.accent),
                    const SizedBox(width: 6),
                    const Text(
                      'Application Process',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    scheme.applicationProcess,
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SchemeSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;

  const _SchemeSection({
    required this.title,
    required this.items,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

// ── State widgets ─────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 52, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
