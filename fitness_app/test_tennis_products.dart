import 'package:fitness_app/screens/clietnt/booking_confirmation_models.dart';
import 'package:fitness_app/services/mock_data_service.dart';
import 'package:fitness_app/models/booking_model.dart' as booking_models;

void main() {
  print('=== Тест отображения товаров для теннисных кортов ===');
  
  // Тест метода shouldShowProductsSection
  final shouldShow = ConfirmationBookingType.tennisCourt.shouldShowProductsSection;
  print('Должен показывать товары для теннисных кортов: $shouldShow');
  
  // Тест преобразования типа
  final bookingType = ConfirmationBookingType.tennisCourt.toBookingType();
  print('Преобразованный тип бронирования: $bookingType');
  
  // Тест получения товаров
  final products = MockDataService.getProductsForBooking(bookingType);
  print('Доступные товары для теннисных кортов:');
  for (final product in products) {
    print('  - ${product.name} (${product.category}): ${product.price} ₽');
  }
  
  // Тест создания конфигурации
  final config = BookingConfirmationConfig(
    type: ConfirmationBookingType.tennisCourt,
    title: 'Тестовое бронирование',
    serviceName: 'Корт 1',
    price: 2500,
    date: DateTime.now(),
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(hours: 2)),
    court: booking_models.TennisCourt(
      id: 'court_1',
      number: 'Корт 1',
      surfaceType: 'Хард',
      isIndoor: true,
      basePricePerHour: 1200,
      isAvailable: true,
    ),
    location: 'Хард • Крытый',
  );
  
  print('Конфигурация создана успешно: ${config.type}');
  print('Должна показывать секцию товаров: ${config.type.shouldShowProductsSection}');
  
  print('\n=== Тест завершен ===');
}