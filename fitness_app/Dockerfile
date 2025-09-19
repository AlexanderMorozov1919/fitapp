# Используем официальный образ Flutter для веб-сборки
FROM ghcr.io/cirruslabs/flutter:3.35.4 AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта
COPY . .

# Устанавливаем зависимости
RUN flutter pub get

# Собираем веб-приложение
RUN flutter build web --release

# Используем nginx для обслуживания статических файлов
FROM nginx:alpine

# Копируем собранные файлы в nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Копируем кастомную конфигурацию nginx (если нужно)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт 80
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]