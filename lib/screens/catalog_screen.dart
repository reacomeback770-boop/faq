import 'package:flutter/material.dart';
import '../models/catalog_models.dart';
import '../widgets/breadcrumb_bar.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  // Navigation State
  // Level 1: Main Categories
  // Level 2: Sub-categories of selected main category
  // Level 3: Final categories & Products
  int _currentLevel = 1;
  MainCategory? _selectedMainCategory;
  SubCategory? _selectedSubCategory;
  int _selectedFinalCategoryIndex = 0; // 0 means "Barchasi" (All)

  // Search & Cart State
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _cartCount = 0;

  late final List<MainCategory> _allCategories;

  @override
  void initState() {
    super.initState();
    _allCategories = CatalogRepository.getCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Navigation Helpers
  void _goToLevel1() {
    setState(() {
      _currentLevel = 1;
      _selectedMainCategory = null;
      _selectedSubCategory = null;
      _selectedFinalCategoryIndex = 0;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _goToLevel2(MainCategory category) {
    setState(() {
      _selectedMainCategory = category;
      _selectedSubCategory = null;
      _selectedFinalCategoryIndex = 0;
      _currentLevel = 2;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _goToLevel3(SubCategory subCategory) {
    setState(() {
      _selectedSubCategory = subCategory;
      _selectedFinalCategoryIndex = 0;
      _currentLevel = 3;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _goBack() {
    if (_currentLevel == 3) {
      setState(() {
        _currentLevel = 2;
        _selectedSubCategory = null;
        _selectedFinalCategoryIndex = 0;
      });
    } else if (_currentLevel == 2) {
      setState(() {
        _currentLevel = 1;
        _selectedMainCategory = null;
      });
    }
  }

  void _addToCart(ProductItem product) {
    setState(() {
      _cartCount++;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '«${product.name}» savatga qo\'shildi',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BreadcrumbItem> _buildBreadcrumbItems() {
    final items = <BreadcrumbItem>[
      BreadcrumbItem(
        title: '🏠 Katalog',
        isActive: _currentLevel == 1,
        onTap: _goToLevel1,
      ),
    ];

    if (_selectedMainCategory != null && _currentLevel >= 2) {
      items.add(
        BreadcrumbItem(
          title: _selectedMainCategory!.title,
          isActive: _currentLevel == 2,
          onTap: () {
            if (_selectedMainCategory != null) {
              _goToLevel2(_selectedMainCategory!);
            }
          },
        ),
      );
    }

    if (_selectedSubCategory != null && _currentLevel == 3) {
      items.add(
        BreadcrumbItem(
          title: _selectedSubCategory!.title,
          isActive: true,
        ),
      );
    }

    return items;
  }

  String _getAppBarTitle() {
    if (_currentLevel == 1) return 'Каталог меню';
    if (_currentLevel == 2) return _selectedMainCategory?.title ?? 'Katalog';
    return _selectedSubCategory?.title ?? 'Mahsulotlar';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentLevel == 1,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentLevel > 1) {
          _goBack();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Interactive Breadcrumb Navigation
            BreadcrumbBar(items: _buildBreadcrumbItems()),

            // Search Bar
            _buildSearchBar(),

            // Animated Screen Content according to _currentLevel
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: _buildCurrentLevelBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF0F172A),
      centerTitle: true,
      leading: _currentLevel > 1
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: _goBack,
              tooltip: 'Orqaga qaytish',
            )
          : const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.category_rounded, color: Color(0xFF2563EB)),
            ),
      title: Text(
        _getAppBarTitle(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        // Shopping Cart with badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, size: 24),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Savatda $_cartCount ta mahsulot bor'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            if (_cartCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Center(
                    child: Text(
                      _cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              _searchQuery = val.trim().toLowerCase();
            });
          },
          decoration: InputDecoration(
            hintText: _currentLevel == 1
                ? 'Kategoriyalarni qidirish...'
                : _currentLevel == 2
                    ? 'Bo\'limlarni qidirish...'
                    : 'Mahsulotlarni qidirish...',
            hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
            prefixIcon: const Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF64748B)),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLevelBody() {
    switch (_currentLevel) {
      case 1:
        return _buildLevel1MainCategories();
      case 2:
        return _buildLevel2SubCategories();
      case 3:
        return _buildLevel3FinalCategoriesAndProducts();
      default:
        return const SizedBox();
    }
  }

  // =========================================================
  // 1-BOSQICH (1-DARAJA): ASOSIY KATEGORIYALAR RO'YXATI
  // =========================================================
  Widget _buildLevel1MainCategories() {
    final filtered = _allCategories.where((cat) {
      if (_searchQuery.isEmpty) return true;
      return cat.title.toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      key: const ValueKey('level1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Level Indicator Banner
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.layers_rounded, size: 18, color: Color(0xFF2563EB)),
                  SizedBox(width: 8),
                  Text(
                    '1-daraja: Asosiy kategoriyalar',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${filtered.length} ta bo\'lim',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Categories List
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = filtered[index];
              return _buildMainCategoryCard(category);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMainCategoryCard(MainCategory category) {
    return InkWell(
      onTap: () => _goToLevel2(category),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Badge
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: category.backgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Title and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${category.subCategoryCount} ta ichki bo\'lim • ${category.totalProducts} ta mahsulot',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Action Arrow
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 2-BOSQICH (2-DARAJA): TANLANGAN ASOSIY KATEGORIYA ICHKI BO'LIMLARI
  // =========================================================
  Widget _buildLevel2SubCategories() {
    final cat = _selectedMainCategory!;
    final filtered = cat.subCategories.where((sub) {
      if (_searchQuery.isEmpty) return true;
      return sub.title.toLowerCase().contains(_searchQuery) ||
          sub.description.toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      key: const ValueKey('level2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header summary for Level 2
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cat.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cat.color.withValues(alpha: 0.25),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(cat.icon, color: cat.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: cat.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '2-daraja: Kerakli bo\'limni tanlang',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Sub-categories list
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final sub = filtered[index];
              return _buildSubCategoryCard(sub);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubCategoryCard(SubCategory sub) {
    return InkWell(
      onTap: () => _goToLevel3(sub),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(sub.icon, color: const Color(0xFF334155), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    sub.description,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${sub.finalCategories.length} ta yakuniy tur • ${sub.totalProducts} ta mahsulot',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 3-BOSQICH (3-DARAJA): YAKUNIY BO'LIMLAR VA MAHSULOTLAR RO'YXATI
  // =========================================================
  Widget _buildLevel3FinalCategoriesAndProducts() {
    final sub = _selectedSubCategory!;

    // Compile list of products according to selected filter tab
    List<ProductItem> displayedProducts;
    if (_selectedFinalCategoryIndex == 0) {
      // All products in this sub-category
      displayedProducts = sub.finalCategories
          .expand((finalCat) => finalCat.products)
          .toList();
    } else {
      final finalCat = sub.finalCategories[_selectedFinalCategoryIndex - 1];
      displayedProducts = finalCat.products;
    }

    // Apply Search Query filter
    if (_searchQuery.isNotEmpty) {
      displayedProducts = displayedProducts
          .where((p) => p.name.toLowerCase().contains(_searchQuery))
          .toList();
    }

    return Column(
      key: const ValueKey('level3'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Level 3 Pill Tabs (Final Categories selector)
        _buildFinalCategoriesTabBar(sub),

        // Result Stats Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '3-daraja: ${displayedProducts.length} ta mahsulot topildi',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.tune_rounded, size: 16, color: Color(0xFF2563EB)),
                  SizedBox(width: 4),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Products Grid
        Expanded(
          child: displayedProducts.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: displayedProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayedProducts[index];
                    return ProductCard(
                      product: product,
                      onAddToCart: () => _addToCart(product),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFinalCategoriesTabBar(SubCategory sub) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // "Barchasi" Tab
            _buildTabChip(
              index: 0,
              label: 'Barchasi (${sub.totalProducts})',
              isSelected: _selectedFinalCategoryIndex == 0,
            ),
            const SizedBox(width: 8),

            // Each Final Category Tab
            ...List.generate(sub.finalCategories.length, (i) {
              final finalCat = sub.finalCategories[i];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildTabChip(
                  index: i + 1,
                  label: '${finalCat.title} (${finalCat.productCount})',
                  isSelected: _selectedFinalCategoryIndex == i + 1,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTabChip({
    required int index,
    required String label,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFinalCategoryIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 36,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mahsulot topilmadi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Qidiruv so\'zini o\'zgartirib ko\'ring',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
