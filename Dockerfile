# Sử dụng hình ảnh cơ sở chứa Flutter và Dart
FROM cirrusci/flutter:stable

# Đặt thư mục làm việc trong container
WORKDIR /app

# Sao chép các tệp tin từ thư mục hiện tại của máy tính vào thư mục làm việc trong container
COPY . .

# Chạy lệnh để cài đặt các dependencies của ứng dụng Flutter
RUN flutter pub get

# Chạy lệnh để xây dựng ứng dụng Flutter
RUN flutter build apk --release

# Port mà ứng dụng chạy trên (tuỳ thuộc vào ứng dụng của bạn)
EXPOSE 80

# Lệnh chạy khi container được khởi động
CMD ["flutter", "run", "--release", "--web-port", "80", "--web-hostname", "0.0.0.0"]
