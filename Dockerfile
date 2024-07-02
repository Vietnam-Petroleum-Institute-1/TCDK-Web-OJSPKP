# Use the official PHP image with necessary extensions
FROM php:8.2-apache

# Install necessary PHP extensions
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions mysqli intl

# Enable Apache mod_rewrite (if needed)
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy the project files to the container
COPY . .

# Expose port 8000
EXPOSE 8000

# Start PHP's built-in server
CMD ["php", "-S", "0.0.0.0:8000"]
