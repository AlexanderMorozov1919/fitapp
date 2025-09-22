import '../../models/booking_model.dart';
import 'package:flutter/material.dart';

final List<TennisCourt> tennisCourts = [
  TennisCourt(
    id: 'court_001',
    number: 'Корт 1',
    surfaceType: 'Хард',
    isIndoor: true,
    isAvailable: true,
    basePricePerHour: 1500,
    morningPriceMultiplier: 0.7,  // 1050 ₽
    dayPriceMultiplier: 1.0,      // 1500 ₽
    eveningPriceMultiplier: 1.3,  // 1950 ₽
    weekendPriceMultiplier: 1.6,  // 2400 ₽
    bookedSlots: [
      // Понедельник (26 сентября)
      DateTime(2025, 9, 26, 9, 0),
      DateTime(2025, 9, 26, 10, 0),
      DateTime(2025, 9, 26, 11, 0),
      DateTime(2025, 9, 26, 18, 0),
      DateTime(2025, 9, 26, 19, 0),
      DateTime(2025, 9, 26, 20, 0),
      DateTime(2025, 9, 26, 21, 0),
      
      // Вторник (27 сентября)
      DateTime(2025, 9, 27, 10, 0),
      DateTime(2025, 9, 27, 11, 0),
      DateTime(2025, 9, 27, 12, 0),
      DateTime(2025, 9, 27, 13, 0),
      DateTime(2025, 9, 27, 19, 0),
      DateTime(2025, 9, 27, 20, 0),
      DateTime(2025, 9, 27, 21, 0),
      
      // Среда (28 сентября)
      DateTime(2025, 9, 28, 14, 0),
      DateTime(2025, 9, 28, 15, 0),
      DateTime(2025, 9, 28, 16, 0),
      DateTime(2025, 9, 28, 17, 0),
      DateTime(2025, 9, 28, 18, 0),
      
      // Четверг (29 сентября)
      DateTime(2025, 9, 29, 9, 0),
      DateTime(2025, 9, 29, 10, 0),
      DateTime(2025, 9, 29, 11, 0),
      DateTime(2025, 9, 29, 17, 0),
      DateTime(2025, 9, 29, 18, 0),
      DateTime(2025, 9, 29, 19, 0),
      DateTime(2025, 9, 29, 20, 0),
      
      // Пятница (30 сентября)
      DateTime(2025, 9, 30, 11, 0),
      DateTime(2025, 9, 30, 12, 0),
      DateTime(2025, 9, 30, 13, 0),
      DateTime(2025, 9, 30, 14, 0),
      DateTime(2025, 9, 30, 18, 0),
      DateTime(2025, 9, 30, 19, 0),
      DateTime(2025, 9, 30, 20, 0),
      DateTime(2025, 9, 30, 21, 0),
      
      // Суббота (1 октября)
      DateTime(2025, 10, 1, 10, 0),
      DateTime(2025, 10, 1, 11, 0),
      DateTime(2025, 10, 1, 12, 0),
      DateTime(2025, 10, 1, 13, 0),
      DateTime(2025, 10, 1, 14, 0),
      DateTime(2025, 10, 1, 15, 0),
      DateTime(2025, 10, 1, 16, 0),
      DateTime(2025, 10, 1, 17, 0),
      DateTime(2025, 10, 1, 18, 0),
      
      // Воскресенье (2 октября)
      DateTime(2025, 10, 2, 11, 0),
      DateTime(2025, 10, 2, 12, 0),
      DateTime(2025, 10, 2, 13, 0),
      DateTime(2025, 10, 2, 14, 0),
      DateTime(2025, 10, 2, 15, 0),
      DateTime(2025, 10, 2, 16, 0),
      DateTime(2025, 10, 2, 17, 0),
    ],
  ),
  TennisCourt(
    id: 'court_002',
    number: 'Корт 2',
    surfaceType: 'Грунт',
    isIndoor: false,
    isAvailable: true,
    basePricePerHour: 1200,
    morningPriceMultiplier: 0.6,  // 720 ₽
    dayPriceMultiplier: 0.9,      // 1080 ₽
    eveningPriceMultiplier: 1.2,  // 1440 ₽
    weekendPriceMultiplier: 1.4,  // 1680 ₽
    bookedSlots: [
      // Понедельник
      DateTime(2025, 9, 26, 8, 0),
      DateTime(2025, 9, 26, 9, 0),
      DateTime(2025, 9, 26, 17, 0),
      DateTime(2025, 9, 26, 18, 0),
      
      // Вторник
      DateTime(2025, 9, 27, 14, 0),
      DateTime(2025, 9, 27, 15, 0),
      DateTime(2025, 9, 27, 16, 0),
      
      // Среда
      DateTime(2025, 9, 28, 10, 0),
      DateTime(2025, 9, 28, 11, 0),
      DateTime(2025, 9, 28, 19, 0),
      DateTime(2025, 9, 28, 20, 0),
      
      // Четверг
      DateTime(2025, 9, 29, 13, 0),
      DateTime(2025, 9, 29, 14, 0),
      DateTime(2025, 9, 29, 15, 0),
      
      // Пятница
      DateTime(2025, 9, 30, 9, 0),
      DateTime(2025, 9, 30, 10, 0),
      DateTime(2025, 9, 30, 16, 0),
      DateTime(2025, 9, 30, 17, 0),
      
      // Суббота
      DateTime(2025, 10, 1, 9, 0),
      DateTime(2025, 10, 1, 10, 0),
      DateTime(2025, 10, 1, 11, 0),
      DateTime(2025, 10, 1, 15, 0),
      DateTime(2025, 10, 1, 16, 0),
      DateTime(2025, 10, 1, 17, 0),
      
      // Воскресенье
      DateTime(2025, 10, 2, 10, 0),
      DateTime(2025, 10, 2, 11, 0),
      DateTime(2025, 10, 2, 12, 0),
      DateTime(2025, 10, 2, 16, 0),
      DateTime(2025, 10, 2, 17, 0),
    ],
  ),
  TennisCourt(
    id: 'court_003',
    number: 'Корт 3',
    surfaceType: 'Хард',
    isIndoor: true,
    isAvailable: false,  // На ремонте
    basePricePerHour: 1600,
    morningPriceMultiplier: 0.7,
    dayPriceMultiplier: 1.0,
    eveningPriceMultiplier: 1.3,
    weekendPriceMultiplier: 1.5,
    bookedSlots: [
      // Полностью занят на ремонт
      DateTime(2025, 9, 26, 8, 0),
      DateTime(2025, 9, 26, 9, 0),
      DateTime(2025, 9, 26, 10, 0),
      DateTime(2025, 9, 26, 11, 0),
      DateTime(2025, 9, 26, 12, 0),
      DateTime(2025, 9, 26, 13, 0),
      DateTime(2025, 9, 26, 14, 0),
      DateTime(2025, 9, 26, 15, 0),
      DateTime(2025, 9, 26, 16, 0),
      DateTime(2025, 9, 26, 17, 0),
      DateTime(2025, 9, 26, 18, 0),
      DateTime(2025, 9, 26, 19, 0),
      DateTime(2025, 9, 26, 20, 0),
      DateTime(2025, 9, 26, 21, 0),
    ],
  ),
  TennisCourt(
    id: 'court_004',
    number: 'Корт 4',
    surfaceType: 'Трава',
    isIndoor: false,
    isAvailable: true,
    basePricePerHour: 2000,
    morningPriceMultiplier: 0.8,  // 1600 ₽
    dayPriceMultiplier: 1.2,      // 2400 ₽
    eveningPriceMultiplier: 1.5,  // 3000 ₽
    weekendPriceMultiplier: 1.8,  // 3600 ₽
    bookedSlots: [
      // Понедельник
      DateTime(2025, 9, 26, 18, 0),
      DateTime(2025, 9, 26, 19, 0),
      DateTime(2025, 9, 26, 20, 0),
      
      // Вторник
      DateTime(2025, 9, 27, 9, 0),
      DateTime(2025, 9, 27, 10, 0),
      DateTime(2025, 9, 27, 17, 0),
      DateTime(2025, 9, 27, 18, 0),
      
      // Среда
      DateTime(2025, 9, 28, 14, 0),
      DateTime(2025, 9, 28, 15, 0),
      DateTime(2025, 9, 28, 16, 0),
      
      // Четверг
      DateTime(2025, 9, 29, 11, 0),
      DateTime(2025, 9, 29, 12, 0),
      DateTime(2025, 9, 29, 19, 0),
      DateTime(2025, 9, 29, 20, 0),
      
      // Пятница
      DateTime(2025, 9, 30, 10, 0),
      DateTime(2025, 9, 30, 11, 0),
      DateTime(2025, 9, 30, 12, 0),
      
      // Суббота - полностью занят турниром
      DateTime(2025, 10, 1, 8, 0),
      DateTime(2025, 10, 1, 9, 0),
      DateTime(2025, 10, 1, 10, 0),
      DateTime(2025, 10, 1, 11, 0),
      DateTime(2025, 10, 1, 12, 0),
      DateTime(2025, 10, 1, 13, 0),
      DateTime(2025, 10, 1, 14, 0),
      DateTime(2025, 10, 1, 15, 0),
      DateTime(2025, 10, 1, 16, 0),
      DateTime(2025, 10, 1, 17, 0),
      DateTime(2025, 10, 1, 18, 0),
      
      // Воскресенье - турнир продолжается
      DateTime(2025, 10, 2, 9, 0),
      DateTime(2025, 10, 2, 10, 0),
      DateTime(2025, 10, 2, 11, 0),
      DateTime(2025, 10, 2, 12, 0),
      DateTime(2025, 10, 2, 13, 0),
      DateTime(2025, 10, 2, 14, 0),
      DateTime(2025, 10, 2, 15, 0),
    ],
  ),
  TennisCourt(
    id: 'court_005',
    number: 'Корт 5',
    surfaceType: 'Хард',
    isIndoor: true,
    isAvailable: true,
    basePricePerHour: 1400,
    morningPriceMultiplier: 0.6,  // 840 ₽
    dayPriceMultiplier: 0.9,      // 1260 ₽
    eveningPriceMultiplier: 1.2,  // 1680 ₽
    weekendPriceMultiplier: 1.4,  // 1960 ₽
    bookedSlots: [
      // Понедельник
      DateTime(2025, 9, 26, 16, 0),
      DateTime(2025, 9, 26, 17, 0),
      DateTime(2025, 9, 26, 18, 0),
      
      // Вторник
      DateTime(2025, 9, 27, 8, 0),
      DateTime(2025, 9, 27, 9, 0),
      DateTime(2025, 9, 27, 19, 0),
      DateTime(2025, 9, 27, 20, 0),
      
      // Среда
      DateTime(2025, 9, 28, 13, 0),
      DateTime(2025, 9, 28, 14, 0),
      DateTime(2025, 9, 28, 15, 0),
      
      // Четверг
      DateTime(2025, 9, 29, 10, 0),
      DateTime(2025, 9, 29, 11, 0),
      DateTime(2025, 9, 29, 16, 0),
      DateTime(2025, 9, 29, 17, 0),
      
      // Пятница
      DateTime(2025, 9, 30, 14, 0),
      DateTime(2025, 9, 30, 15, 0),
      DateTime(2025, 9, 30, 16, 0),
      
      // Суббота
      DateTime(2025, 10, 1, 11, 0),
      DateTime(2025, 10, 1, 12, 0),
      DateTime(2025, 10, 1, 13, 0),
      DateTime(2025, 10, 1, 17, 0),
      DateTime(2025, 10, 1, 18, 0),
      
      // Воскресенье
      DateTime(2025, 10, 2, 10, 0),
      DateTime(2025, 10, 2, 11, 0),
      DateTime(2025, 10, 2, 15, 0),
      DateTime(2025, 10, 2, 16, 0),
    ],
  ),
  TennisCourt(
    id: 'court_006',
    number: 'Корт 6',
    surfaceType: 'Грунт',
    isIndoor: false,
    isAvailable: false,  // Закрыт на сезон
    basePricePerHour: 1000,
    morningPriceMultiplier: 0.5,
    dayPriceMultiplier: 0.8,
    eveningPriceMultiplier: 1.0,
    weekendPriceMultiplier: 1.2,
    bookedSlots: [
      // Полностью занят на весь период
      DateTime(2025, 9, 26, 8, 0),
      DateTime(2025, 9, 26, 9, 0),
      DateTime(2025, 9, 26, 10, 0),
      DateTime(2025, 9, 26, 11, 0),
      DateTime(2025, 9, 26, 12, 0),
      DateTime(2025, 9, 26, 13, 0),
      DateTime(2025, 9, 26, 14, 0),
      DateTime(2025, 9, 26, 15, 0),
      DateTime(2025, 9, 26, 16, 0),
      DateTime(2025, 9, 26, 17, 0),
      DateTime(2025, 9, 26, 18, 0),
      DateTime(2025, 9, 26, 19, 0),
      DateTime(2025, 9, 26, 20, 0),
    ],
  ),
];