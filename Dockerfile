# Use Nginx to serve Flutter Web build
FROM nginx:alpine

# Copy built web files to Nginx
COPY build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
