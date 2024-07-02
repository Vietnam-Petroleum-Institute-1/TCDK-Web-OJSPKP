# # Use the official PHP image with necessary extensions
# FROM php:8.2-apache

# # Install necessary PHP extensions
# RUN curl -sSLf \
#         -o /usr/local/bin/install-php-extensions \
#         https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
#     chmod +x /usr/local/bin/install-php-extensions && \
#     install-php-extensions mysqli intl

# # Enable Apache mod_rewrite (if needed)
# RUN a2enmod rewrite

# # Set working directory
# WORKDIR /var/www/html

# # Copy the project files to the container
# COPY . .

# # Expose port 8000
# EXPOSE 8000

# # Start PHP's built-in server
# CMD ["php", "-S", "0.0.0.0:8000"]



# Sử dụng image PHP
FROM php:8.2-cli

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y \
    default-mysql-server \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt các extension PHP cần thiết
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions mysqli intl pdo_mysql

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Sao chép các file dự án vào container
COPY . .

# Thiết lập biến môi trường cho MySQL
ENV MYSQL_ROOT_PASSWORD=167@Trungkinh
ENV MYSQL_DATABASE=tcdkdb
ENV MYSQL_USER=tcdk
ENV MYSQL_PASSWORD=167@Trungkinh

# Tạo script khởi động
RUN echo '#!/bin/bash\n\
# Khởi động MySQL\n\
service mysql start\n\
\n\
# Tạo database và user\n\
mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"\n\
mysql -e "CREATE USER IF NOT EXISTS '"'"'$MYSQL_USER'"'"'@'"'"'localhost'"'"' IDENTIFIED BY '"'"'$MYSQL_PASSWORD'"'"';"\n\
mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '"'"'$MYSQL_USER'"'"'@'"'"'localhost'"'"';"\n\
mysql -e "FLUSH PRIVILEGES;"\n\
\n\
# Khởi động PHP built-in server\n\
php -S 0.0.0.0:8000' > /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose cổng 8000
EXPOSE 8000

# Sử dụng script khởi động làm entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Chỉ định lệnh mặc định khi container khởi động
CMD ["php", "-S", "0.0.0.0:8000"]
