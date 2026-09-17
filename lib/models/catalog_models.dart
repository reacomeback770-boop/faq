import 'package:flutter/material.dart';

class ProductItem {
  final String id;
  final String name;
  final int price;
  final int? oldPrice;
  final double rating;
  final int reviewsCount;
  final String? badge;
  final IconData icon;
  final Color accentColor;
  bool isFavorite;

  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewsCount,
    this.badge,
    required this.icon,
    required this.accentColor,
    this.isFavorite = false,
  });

  String get formattedPrice {
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(' ');
      }
    }
    return '${buffer.toString().split('').reversed.join('')} so\'m';
  }

  String? get formattedOldPrice {
    if (oldPrice == null) return null;
    final str = oldPrice.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(' ');
      }
    }
    return '${buffer.toString().split('').reversed.join('')} so\'m';
  }
}

class FinalCategory {
  final String id;
  final String title;
  final IconData icon;
  final List<ProductItem> products;

  const FinalCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.products,
  });

  int get productCount => products.length;
}

class SubCategory {
  final String id;
  final String title;
  final IconData icon;
  final String description;
  final List<FinalCategory> finalCategories;

  const SubCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    required this.finalCategories,
  });

  int get totalProducts =>
      finalCategories.fold(0, (sum, item) => sum + item.productCount);
}

class MainCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final List<SubCategory> subCategories;

  const MainCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.subCategories,
  });

  int get subCategoryCount => subCategories.length;

  int get totalProducts =>
      subCategories.fold(0, (sum, item) => sum + item.totalProducts);
}

class CatalogRepository {
  static List<MainCategory> getCategories() {
    return [
      // 1. ELEKTRONIKA
      MainCategory(
        id: 'cat_electronics',
        title: 'Elektronika',
        icon: Icons.devices_rounded,
        color: const Color(0xFF2563EB),
        backgroundColor: const Color(0xFFEFF6FF),
        subCategories: [
          SubCategory(
            id: 'sub_smartphones',
            title: 'Smartfonlar va gadjetlar',
            icon: Icons.smartphone_rounded,
            description: 'iPhone, Samsung, Xiaomi va aksessuarlar',
            finalCategories: [
              FinalCategory(
                id: 'fin_smartphones',
                title: 'Smartfonlar',
                icon: Icons.phone_android_rounded,
                products: [
                  ProductItem(
                    id: 'p1',
                    name: 'Apple iPhone 15 Pro Max 256GB Natural Titanium',
                    price: 16800000,
                    oldPrice: 18200000,
                    rating: 4.9,
                    reviewsCount: 342,
                    badge: 'HIT SOTUV',
                    icon: Icons.phone_iphone_rounded,
                    accentColor: const Color(0xFF475569),
                  ),
                  ProductItem(
                    id: 'p2',
                    name: 'Samsung Galaxy S24 Ultra 12/512GB Titanium Gray',
                    price: 15400000,
                    oldPrice: 16900000,
                    rating: 4.8,
                    reviewsCount: 215,
                    badge: 'YANGI',
                    icon: Icons.smartphone_rounded,
                    accentColor: const Color(0xFF2563EB),
                  ),
                  ProductItem(
                    id: 'p3',
                    name: 'Xiaomi 14 Ultra 16/512GB Leica Kamera',
                    price: 12200000,
                    rating: 4.7,
                    reviewsCount: 98,
                    badge: 'CHEGIRMA -10%',
                    icon: Icons.camera_alt_rounded,
                    accentColor: const Color(0xFFEA580C),
                  ),
                  ProductItem(
                    id: 'p4',
                    name: 'Google Pixel 8 Pro 128GB Obsidian Black',
                    price: 10900000,
                    oldPrice: 11900000,
                    rating: 4.8,
                    reviewsCount: 76,
                    icon: Icons.phone_android_rounded,
                    accentColor: const Color(0xFF0D9488),
                  ),
                ],
              ),
              FinalCategory(
                id: 'fin_smartwatches',
                title: 'Smart-soatlar va brasletlar',
                icon: Icons.watch_rounded,
                products: [
                  ProductItem(
                    id: 'p5',
                    name: 'Apple Watch Series 9 45mm Midnight',
                    price: 5400000,
                    oldPrice: 5900000,
                    rating: 4.9,
                    reviewsCount: 164,
                    badge: 'TOP',
                    icon: Icons.watch_rounded,
                    accentColor: const Color(0xFF1E293B),
                  ),
                  ProductItem(
                    id: 'p6',
                    name: 'Samsung Galaxy Watch 6 Classic 47mm LTE',
                    price: 4200000,
                    rating: 4.7,
                    reviewsCount: 89,
                    icon: Icons.watch_later_rounded,
                    accentColor: const Color(0xFF3B82F6),
                  ),
                ],
              ),
              FinalCategory(
                id: 'fin_audio',
                title: 'Quloqchinlar va audio',
                icon: Icons.headphones_rounded,
                products: [
                  ProductItem(
                    id: 'p7',
                    name: 'Apple AirPods Pro 2 (USB-C) MagSafe Case',
                    price: 3100000,
                    oldPrice: 3500000,
                    rating: 4.9,
                    reviewsCount: 420,
                    badge: 'CHEGIRMA',
                    icon: Icons.headphones_rounded,
                    accentColor: const Color(0xFF6366F1),
                  ),
                  ProductItem(
                    id: 'p8',
                    name: 'Sony WH-1000XM5 Simsiz shovqin so\'ndiruvchi',
                    price: 4600000,
                    rating: 4.8,
                    reviewsCount: 112,
                    icon: Icons.headset_rounded,
                    accentColor: const Color(0xFF0F172A),
                  ),
                ],
              ),
            ],
          ),
          SubCategory(
            id: 'sub_laptops',
            title: 'Noutbuklar va kompyuterlar',
            icon: Icons.laptop_mac_rounded,
            description: 'MacBook, o\'yin noutbuklari va monitorlar',
            finalCategories: [
              FinalCategory(
                id: 'fin_laptops',
                title: 'Noutbuklar',
                icon: Icons.laptop_chromebook_rounded,
                products: [
                  ProductItem(
                    id: 'p9',
                    name: 'Apple MacBook Pro 14" M3 Pro 18GB/512GB Space Black',
                    price: 25800000,
                    oldPrice: 27500000,
                    rating: 5.0,
                    reviewsCount: 88,
                    badge: 'PREMIUM',
                    icon: Icons.laptop_mac_rounded,
                    accentColor: const Color(0xFF0F172A),
                  ),
                  ProductItem(
                    id: 'p10',
                    name: 'ASUS ROG Zephyrus G16 RTX 4070 Gaming Laptop',
                    price: 22400000,
                    rating: 4.8,
                    reviewsCount: 63,
                    icon: Icons.sports_esports_rounded,
                    accentColor: const Color(0xFFDC2626),
                  ),
                ],
              ),
              FinalCategory(
                id: 'fin_monitors',
                title: 'Monitorlar',
                icon: Icons.desktop_windows_rounded,
                products: [
                  ProductItem(
                    id: 'p11',
                    name: 'Samsung Odyssey G7 28" 4K 144Hz IPS Monitor',
                    price: 7800000,
                    rating: 4.7,
                    reviewsCount: 45,
                    icon: Icons.tv_rounded,
                    accentColor: const Color(0xFF2563EB),
                  ),
                ],
              ),
            ],
          ),
          SubCategory(
            id: 'sub_tvs',
            title: 'Televizorlar va proyektorlar',
            icon: Icons.tv_rounded,
            description: 'Smart TV, OLED va 4K proyektorlar',
            finalCategories: [
              FinalCategory(
                id: 'fin_tvs',
                title: 'Smart TV',
                icon: Icons.live_tv_rounded,
                products: [
                  ProductItem(
                    id: 'p12',
                    name: 'Samsung 55" QLED 4K Smart TV',
                    price: 8900000,
                    oldPrice: 9800000,
                    rating: 4.8,
                    reviewsCount: 140,
                    icon: Icons.tv_rounded,
                    accentColor: const Color(0xFF0284C7),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // 2. MAISHIY TEXNIKA
      MainCategory(
        id: 'cat_appliances',
        title: 'Maishiy texnika',
        icon: Icons.kitchen_rounded,
        color: const Color(0xFF059669),
        backgroundColor: const Color(0xFFECFDF5),
        subCategories: [
          SubCategory(
            id: 'sub_kitchen',
            title: 'Oshxona texnikasi',
            icon: Icons.soup_kitchen_rounded,
            description: 'Muzlatgich, kofe mashina va mikroto\'lqinli pechlar',
            finalCategories: [
              FinalCategory(
                id: 'fin_coffee',
                title: 'Kofe mashinalari',
                icon: Icons.coffee_maker_rounded,
                products: [
                  ProductItem(
                    id: 'p13',
                    name: 'DeLonghi Magnifica S Avtomatik kofe mashinasi',
                    price: 6400000,
                    oldPrice: 7200000,
                    rating: 4.9,
                    reviewsCount: 180,
                    badge: 'TOP',
                    icon: Icons.coffee_rounded,
                    accentColor: const Color(0xFF78350F),
                  ),
                ],
              ),
              FinalCategory(
                id: 'fin_fridge',
                title: 'Muzlatgichlar',
                icon: Icons.kitchen_rounded,
                products: [
                  ProductItem(
                    id: 'p14',
                    name: 'LG NoFrost Inverter 384L Muzlatgich',
                    price: 9200000,
                    rating: 4.8,
                    reviewsCount: 95,
                    icon: Icons.kitchen_rounded,
                    accentColor: const Color(0xFF059669),
                  ),
                ],
              ),
            ],
          ),
          SubCategory(
            id: 'sub_cleaning',
            title: 'Uy tozalash texnikasi',
            icon: Icons.cleaning_services_rounded,
            description: 'Robot-changyutgichlar va par tozalagichlar',
            finalCategories: [
              FinalCategory(
                id: 'fin_robot_vac',
                title: 'Robot changyutgichlar',
                icon: Icons.smart_toy_rounded,
                products: [
                  ProductItem(
                    id: 'p15',
                    name: 'Roborock S8 Pro Ultra Yuvuvchi Robot changyutgich',
                    price: 13500000,
                    oldPrice: 14800000,
                    rating: 4.9,
                    reviewsCount: 77,
                    badge: 'HIT',
                    icon: Icons.smart_toy_rounded,
                    accentColor: const Color(0xFF4F46E5),
                  ),
                  ProductItem(
                    id: 'p16',
                    name: 'Dyson V15 Detect Simsiz changyutgich',
                    price: 9800000,
                    rating: 5.0,
                    reviewsCount: 114,
                    icon: Icons.cleaning_services_rounded,
                    accentColor: const Color(0xFF9333EA),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // 3. KIYIM-KECHAK VA POYABZALLAR
      MainCategory(
        id: 'cat_clothing',
        title: 'Kiyim-kechak va poyabzal',
        icon: Icons.checkroom_rounded,
        color: const Color(0xFF7C3AED),
        backgroundColor: const Color(0xFFF5F3FF),
        subCategories: [
          SubCategory(
            id: 'sub_mens_clothing',
            title: 'Erkaklar kiyimi',
            icon: Icons.male_rounded,
            description: 'Kurtkalar, kostyumlar, xudi va futbolkalar',
            finalCategories: [
              FinalCategory(
                id: 'fin_mens_shoes',
                title: 'Krossovkalar',
                icon: Icons.roller_skating_rounded,
                products: [
                  ProductItem(
                    id: 'p17',
                    name: 'Nike Air Force 1 \'07 Oq erkaklar krossovkasi',
                    price: 1650000,
                    oldPrice: 1900000,
                    rating: 4.9,
                    reviewsCount: 512,
                    badge: 'HIT SOTUV',
                    icon: Icons.sports_tennis_rounded,
                    accentColor: const Color(0xFF18181B),
                  ),
                  ProductItem(
                    id: 'p18',
                    name: 'Adidas Samba Classic Teri poyabzal',
                    price: 1480000,
                    rating: 4.8,
                    reviewsCount: 380,
                    icon: Icons.snowshoeing_rounded,
                    accentColor: const Color(0xFF3F3F46),
                  ),
                ],
              ),
              FinalCategory(
                id: 'fin_mens_jackets',
                title: 'Ustki kiyimlar',
                icon: Icons.dry_cleaning_rounded,
                products: [
                  ProductItem(
                    id: 'p19',
                    name: 'The North Face 1996 Retro Nuptse Kurtka',
                    price: 3400000,
                    oldPrice: 3900000,
                    rating: 4.9,
                    reviewsCount: 94,
                    icon: Icons.wb_cloudy_rounded,
                    accentColor: const Color(0xFFDC2626),
                  ),
                ],
              ),
            ],
          ),
          SubCategory(
            id: 'sub_womens_clothing',
            title: 'Ayollar kiyimi',
            icon: Icons.female_rounded,
            description: 'Ko\'ylaklar, poyabzal va sumkalar',
            finalCategories: [
              FinalCategory(
                id: 'fin_womens_dresses',
                title: 'Ko\'ylaklar',
                icon: Icons.girl_rounded,
                products: [
                  ProductItem(
                    id: 'p20',
                    name: 'Zara Elegant Silk Kechki ko\'ylak',
                    price: 1250000,
                    rating: 4.7,
                    reviewsCount: 65,
                    icon: Icons.accessibility_new_rounded,
                    accentColor: const Color(0xFFBE185D),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // 4. GO'ZALLIK VA SALOMATLIK
      MainCategory(
        id: 'cat_beauty',
        title: 'Go\'zallik va salomatlik',
        icon: Icons.spa_rounded,
        color: const Color(0xFFDB2777),
        backgroundColor: const Color(0xFFFDF2F8),
        subCategories: [
          SubCategory(
            id: 'sub_perfume',
            title: 'Parfyumeriya',
            icon: Icons.auto_awesome_rounded,
            description: 'Frantsuz va sharqona elita atirlari',
            finalCategories: [
              FinalCategory(
                id: 'fin_perfumes',
                title: 'Erkaklar va ayollar atirlari',
                icon: Icons.water_drop_rounded,
                products: [
                  ProductItem(
                    id: 'p21',
                    name: 'Dior Sauvage Eau de Parfum 100ml',
                    price: 2100000,
                    oldPrice: 2400000,
                    rating: 4.9,
                    reviewsCount: 310,
                    badge: 'TOP',
                    icon: Icons.local_florist_rounded,
                    accentColor: const Color(0xFF1E1B4B),
                  ),
                  ProductItem(
                    id: 'p22',
                    name: 'Maison Francis Kurkdjian Baccarat Rouge 540',
                    price: 3900000,
                    rating: 5.0,
                    reviewsCount: 140,
                    icon: Icons.diamond_rounded,
                    accentColor: const Color(0xFFB91C1C),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // 5. KITOBLAR VA KANTSELYARIYA
      MainCategory(
        id: 'cat_books',
        title: 'Kitoblar va kantselyariya',
        icon: Icons.menu_book_rounded,
        color: const Color(0xFFD97706),
        backgroundColor: const Color(0xFFFFFBEB),
        subCategories: [
          SubCategory(
            id: 'sub_literature',
            title: 'Badiiy va biznes adabiyot',
            icon: Icons.auto_stories_rounded,
            description: 'Jahon durdonalari, biznes va shaxsiy rivojlanish',
            finalCategories: [
              FinalCategory(
                id: 'fin_business_books',
                title: 'Biznes va psixologiya',
                icon: Icons.psychology_rounded,
                products: [
                  ProductItem(
                    id: 'p23',
                    name: 'Atom odatlar - Jeyms Klir (O\'zbek tilida)',
                    price: 85000,
                    oldPrice: 110000,
                    rating: 4.9,
                    reviewsCount: 680,
                    badge: 'BESTSELLER',
                    icon: Icons.menu_book_rounded,
                    accentColor: const Color(0xFFD97706),
                  ),
                  ProductItem(
                    id: 'p24',
                    name: 'Boy ota, kambag\'al ota - Robert Kiyosaki',
                    price: 75000,
                    rating: 4.8,
                    reviewsCount: 450,
                    icon: Icons.book_rounded,
                    accentColor: const Color(0xFF059669),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
