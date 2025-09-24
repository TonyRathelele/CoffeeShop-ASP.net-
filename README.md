# Coffee Haven - Full Functional Coffee Website

A complete ASP.NET Core coffee e-commerce website with database integration, caching, cookies, and session management.

## Features

### 🛍️ E-commerce Functionality
- Product catalog with categories (Espresso, Single Origin, Cold Brew, Decaf, Accessories)
- Shopping cart with session-based storage
- User authentication and registration
- Order management and history
- Product reviews and ratings

### 🗄️ Database Integration
- Entity Framework Core with MySQL
- Identity system for user management
- Seeded sample data for categories and products
- Relational data model with proper foreign keys

### ⚡ Performance & Caching
- Memory caching for frequently accessed data
- Cached product listings and categories
- Optimized database queries with includes
- Cache invalidation strategies

### 🍪 Cookies & Sessions
- Session-based shopping cart
- Cookie consent management
- Secure cookie policies
- User preference storage

### 🎨 Modern UI/UX
- Responsive Bootstrap 5 design
- Coffee-themed color scheme
- Font Awesome icons
- Smooth animations and transitions
- Mobile-friendly interface

## Technology Stack

- **Backend**: ASP.NET Core 8.0
- **Database**: MySQL with Entity Framework Core
- **Frontend**: Bootstrap 5, HTML5, CSS3, JavaScript
- **Caching**: In-Memory Cache
- **Authentication**: ASP.NET Core Identity
- **Icons**: Font Awesome 6

## Prerequisites

- .NET 8.0 SDK
- MySQL Server (running on port 3310)
- Visual Studio 2022 or VS Code

## Setup Instructions

### 1. Database Setup
```bash
# Make sure MySQL is running on localhost:3310
# The application will create the database automatically
# Default credentials: root/2000 (update in appsettings.json if different)
```

### 2. Install Dependencies
```bash
dotnet restore
```

### 3. Run the Application
```bash
cd Onlinstore
dotnet run
```

### 4. Access the Website
- Open your browser and navigate to `https://localhost:5001`
- The database will be created automatically with sample data

## Project Structure

```
Onlinstore/
├── Controllers/           # MVC Controllers
│   ├── HomeController.cs
│   ├── ProductController.cs
│   ├── CartController.cs
│   └── AccountController.cs
├── Models/               # Data Models
│   ├── Product.cs
│   ├── Category.cs
│   ├── ShoppingCart.cs
│   ├── Review.cs
│   └── ApplicationDbContext.cs
├── Services/             # Business Logic
│   ├── ProductService.cs
│   └── CartService.cs
├── Views/                # Razor Views
│   ├── Home/
│   ├── Product/
│   ├── Cart/
│   └── Shared/
└── wwwroot/              # Static Files
    ├── css/
    ├── js/
    └── images/
```

## Key Features Explained

### Database Integration
- Uses Entity Framework Core with MySQL
- Automatic database creation and seeding
- Proper relationships between entities
- Identity system for user management

### Caching Implementation
- Memory caching for product listings
- Category caching with longer expiration
- Cache keys for easy invalidation
- Performance optimization for frequently accessed data

### Session-Based Shopping Cart
- Cart stored in user session
- Persists across page refreshes
- JSON serialization for complex objects
- No database dependency for cart storage

### Cookie Management
- Cookie consent banner
- Secure cookie policies
- Session cookies for cart data
- GDPR compliance considerations

## Sample Data

The application includes sample coffee products:
- Ethiopian Yirgacheffe (Single Origin)
- Italian Espresso Blend (Espresso)
- Colombian Supremo (Single Origin)
- Cold Brew Concentrate (Cold Brew)
- Swiss Water Decaf (Decaf)

## Configuration

### Database Connection
Update `appsettings.json` to match your MySQL setup:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "server=localhost;port=3310;database=CoffeeHavenDb;user=root;password=2000;"
  }
}
```

### Cache Settings
Adjust cache durations in `appsettings.json`:
```json
{
  "CacheSettings": {
    "DefaultCacheDurationMinutes": 30,
    "ProductCacheDurationMinutes": 60,
    "CategoryCacheDurationMinutes": 120
  }
}
```

## Development Notes

- The application uses placeholder images from Unsplash
- For production, replace with actual product images
- Consider implementing Redis for distributed caching
- Add payment processing integration
- Implement email notifications for orders
- Add inventory management features

## Security Features

- HTTPS enforcement
- Secure cookie policies
- Input validation and sanitization
- SQL injection prevention through EF Core
- XSS protection with Razor encoding

## Performance Optimizations

- Memory caching for database queries
- Optimized image loading
- Minified CSS and JavaScript
- Efficient database queries with proper indexing
- Session-based cart to reduce database load

## Future Enhancements

- Payment gateway integration
- Email notifications
- Advanced search and filtering
- Wishlist functionality
- Admin dashboard improvements
- Mobile app API
- Multi-language support
- Advanced analytics

## License

This project is for educational and demonstration purposes.