#!/bin/bash

# Скрипт запуска эмулятора Flutter приложения
echo "🚀 Запуск эмулятора мобильного устройства..."

# Проверяем, собрано ли Flutter приложение
if [ ! -d "fitness_app/build/web" ]; then
    echo "⚠️  Flutter приложение не собрано для web"
    echo "📦 Собираем приложение..."
    cd fitness_app
    flutter build web
    cd ..
fi

# Проверяем, запущен ли сервер на порту 8001
if ! curl -s http://localhost:8001/fitness_app/build/web/ > /dev/null; then
    echo "🌐 Запускаем сервер для Flutter приложения на порту 8001..."
    python3 -m http.server 8001 &
    SERVER_PID1=$!
    sleep 2
fi

# Запускаем сервер для эмулятора на порту 8003
echo "📱 Запускаем сервер эмулятора на порту 8003..."
python3 -m http.server 8003 &
SERVER_PID2=$!

sleep 2

echo ""
echo "✅ Готово!"
echo "📱 Эмулятор доступен по адресу: http://localhost:8003/flutter_mobile_frame.html"
echo "🌐 Flutter приложение: http://localhost:8001/fitness_app/build/web/"
echo ""
echo "Для остановки серверов нажмите Ctrl+C"

# Ожидаем сигнала завершения
trap 'kill $SERVER_PID1 $SERVER_PID2 2>/dev/null; exit' INT
wait