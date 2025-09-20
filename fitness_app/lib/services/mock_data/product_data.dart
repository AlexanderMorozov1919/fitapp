import '../../models/product_model.dart';
import '../../models/booking_model.dart';

class ProductData {
  static final List<Product> allProducts = [
    // Теннисные товары
    Product(
      id: 'prod_1',
      name: 'Теннисные мячи Wilson',
      description: 'Профессиональные теннисные мячи для корта',
      price: 1200,
      category: ProductCategory.tennis,
      imageUrl: 'https://images.unsplash.com/photo-1554068865-24cecd4e34b8?w=400',
      stockQuantity: 50,
      unit: 'упаковка (3 шт.)',
    ),
    Product(
      id: 'prod_2',
      name: 'Теннисная ракетка Babolat',
      description: 'Профессиональная ракетка для тенниса',
      price: 8500,
      category: ProductCategory.tennis,
      imageUrl: 'https://images.unsplash.com/photo-1622279457487-9a5c4667342a?w=400',
      stockQuantity: 15,
      unit: 'шт.',
    ),
    Product(
      id: 'prod_3',
      name: 'Накладка на ручку',
      description: 'Антискользящая накладка для теннисной ракетки',
      price: 350,
      category: ProductCategory.tennis,
      stockQuantity: 100,
      unit: 'шт.',
    ),

    // Фитнес товары
    Product(
      id: 'prod_4',
      name: 'Бутылка для воды',
      description: 'Спортивная бутылка 750 мл',
      price: 450,
      category: ProductCategory.fitness,
      imageUrl: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400',
      stockQuantity: 75,
      unit: 'шт.',
    ),
    Product(
      id: 'prod_5',
      name: 'Спортивное полотенце',
      description: 'Быстросохнущее микрофибровое полотенце',
      price: 600,
      category: ProductCategory.fitness,
      imageUrl: 'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=400',
      stockQuantity: 40,
      unit: 'шт.',
    ),
    Product(
      id: 'prod_6',
      name: 'Перчатки для фитнеса',
      description: 'Защита для рук при работе с железом',
      price: 800,
      category: ProductCategory.fitness,
      stockQuantity: 30,
      unit: 'пара',
    ),

    // Напитки
    Product(
      id: 'prod_7',
      name: 'Вода минеральная',
      description: 'Очищенная питьевая вода 0.5л',
      price: 100,
      category: ProductCategory.drinks,
      imageUrl: 'https://images.unsplash.com/photo-1560526864-eb38c444cfd2?w=400',
      stockQuantity: 200,
      unit: 'бутылка',
    ),
    Product(
      id: 'prod_8',
      name: 'Изотоник Powerade',
      description: 'Энергетический напиток для восстановления',
      price: 150,
      category: ProductCategory.drinks,
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      stockQuantity: 80,
      unit: 'бутылка',
    ),
    Product(
      id: 'prod_9',
      name: 'Протеиновый коктейль',
      description: 'Шоколадный протеиновый коктейль 330мл',
      price: 250,
      category: ProductCategory.drinks,
      stockQuantity: 60,
      unit: 'банка',
    ),

    // Аксессуары
    Product(
      id: 'prod_10',
      name: 'Спортивная сумка',
      description: 'Вместительная сумка для спортивной формы',
      price: 1200,
      category: ProductCategory.accessories,
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
      stockQuantity: 25,
      unit: 'шт.',
    ),
    Product(
      id: 'prod_11',
      name: 'Браслет для ключей',
      description: 'Силиконовый браслет для хранения ключей',
      price: 200,
      category: ProductCategory.accessories,
      stockQuantity: 150,
      unit: 'шт.',
    ),
    Product(
      id: 'prod_12',
      name: 'Спортивные носки',
      description: 'Компрессионные носки для тренировок',
      price: 400,
      category: ProductCategory.accessories,
      stockQuantity: 90,
      unit: 'пара',
    ),

    // Другие товары
    Product(
      id: 'prod_13',
      name: 'Абонемент на месяц',
      description: 'Неограниченный доступ на месяц',
      price: 5000,
      category: ProductCategory.other,
      stockQuantity: 999,
      unit: 'шт.',
    ),
    Product(
      id: 'prod_14',
      name: 'Персональная тренировка',
      description: 'Индивидуальное занятие с тренером',
      price: 2000,
      category: ProductCategory.other,
      stockQuantity: 999,
      unit: 'занятие',
    ),
  ];

  static List<Product> getTennisProducts() {
    return allProducts.where((product) => product.category == ProductCategory.tennis).toList();
  }

  static List<Product> getFitnessProducts() {
    return allProducts.where((product) => product.category == ProductCategory.fitness).toList();
  }

  static List<Product> getDrinks() {
    return allProducts.where((product) => product.category == ProductCategory.drinks).toList();
  }

  static List<Product> getAccessories() {
    return allProducts.where((product) => product.category == ProductCategory.accessories).toList();
  }

  static List<Product> getOtherProducts() {
    return allProducts.where((product) => product.category == ProductCategory.other).toList();
  }

  static Product? getProductById(String id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Product> getPopularProducts() {
    return [
      getProductById('prod_1')!,
      getProductById('prod_4')!,
      getProductById('prod_7')!,
      getProductById('prod_10')!,
      getProductById('prod_13')!,
    ];
  }

  static List<Product> getProductsForBooking(BookingType bookingType) {
    switch (bookingType) {
      case BookingType.tennisCourt:
        return [
          ...getTennisProducts(),
          ...getDrinks(),
          ...getAccessories().where((p) => p.id != 'prod_10'), // исключаем сумку
        ];
      case BookingType.groupClass:
      case BookingType.personalTraining:
        return [
          ...getFitnessProducts(),
          ...getDrinks(),
          ...getAccessories(),
        ];
      case BookingType.locker:
        return [
          ...getAccessories(),
          ...getDrinks(),
        ];
      default:
        return getPopularProducts();
    }
  }
}