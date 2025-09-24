-- Coffee Haven Core Tables Only
-- This script creates just the coffee shop specific tables
-- Use this if ASP.NET Identity tables are created automatically by the framework

USE CoffeeHavenDb;

-- Drop existing coffee shop tables if they exist
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS CartItems;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;

-- Create Categories Table
CREATE TABLE Categories (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Description VARCHAR(200) NULL,
    ImageUrl LONGTEXT NULL
);

-- Create Products Table
CREATE TABLE Products (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(500) NULL,
    Price DECIMAL(18,2) NOT NULL,
    ImageUrl LONGTEXT NULL,
    CategoryId INT NOT NULL,
    Origin LONGTEXT NULL,
    RoastLevel LONGTEXT NULL,
    FlavorNotes LONGTEXT NULL,
    IsAvailable BOOLEAN NOT NULL DEFAULT TRUE,
    StockQuantity INT NOT NULL DEFAULT 0,
    CreatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id) ON DELETE CASCADE
);

-- Create CartItems Table
CREATE TABLE CartItems (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProductId INT NOT NULL,
    UserId VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    ProductName LONGTEXT NULL,
    Price DECIMAL(18,2) NOT NULL DEFAULT 0,
    ImageUrl LONGTEXT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE CASCADE
);

-- Create Orders Table
CREATE TABLE Orders (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    UserId VARCHAR(255) NOT NULL,
    OrderDate DATETIME(6) NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    Status VARCHAR(50) NULL DEFAULT 'Pending',
    ShippingAddress LONGTEXT NULL,
    PaymentMethod VARCHAR(50) NULL
);

-- Create OrderItems Table
CREATE TABLE OrderItems (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES Orders(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE CASCADE
);

-- Create Reviews Table
CREATE TABLE Reviews (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProductId INT NOT NULL,
    UserId VARCHAR(255) NOT NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment VARCHAR(1000) NULL,
    CreatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE CASCADE
);

-- Create Indexes for Performance
CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
CREATE INDEX IX_Products_IsAvailable ON Products(IsAvailable);
CREATE INDEX IX_CartItems_ProductId ON CartItems(ProductId);
CREATE INDEX IX_CartItems_UserId ON CartItems(UserId);
CREATE INDEX IX_Orders_UserId ON Orders(UserId);
CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);
CREATE INDEX IX_OrderItems_OrderId ON OrderItems(OrderId);
CREATE INDEX IX_OrderItems_ProductId ON OrderItems(ProductId);
CREATE INDEX IX_Reviews_ProductId ON Reviews(ProductId);
CREATE INDEX IX_Reviews_UserId ON Reviews(UserId);
CREATE INDEX IX_Reviews_Rating ON Reviews(Rating);

-- Insert Sample Categories
INSERT INTO Categories (Name, Description, ImageUrl) VALUES
('Espresso', 'Rich and bold espresso blends perfect for morning energy', '/images/category-espresso.jpg'),
('Single Origin', 'Premium single origin coffees from specific regions', '/images/category-single-origin.jpg'),
('Cold Brew', 'Smooth cold brew concentrates for refreshing drinks', '/images/category-cold-brew.jpg'),
('Decaf', 'Decaffeinated coffee options without compromising taste', '/images/category-decaf.jpg'),
('Accessories', 'Coffee brewing accessories and equipment', '/images/category-accessories.jpg');

-- Insert Sample Products
INSERT INTO Products (Name, Description, Price, CategoryId, Origin, RoastLevel, FlavorNotes, StockQuantity, ImageUrl) VALUES
-- Espresso Category
('Italian Espresso Blend', 'Classic dark roast espresso blend with rich crema', 16.99, 1, 'Italy Blend', 'Dark', 'Chocolate, Nutty, Bold', 75, 'https://images.unsplash.com/photo-1610889556528-9a770e32642f?w=400'),
('French Roast', 'Bold and smoky dark roast with intense flavor', 14.99, 1, 'Multi-Origin', 'Dark', 'Smoky, Bold, Intense', 45, 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400'),
('Espresso Romano', 'Traditional Italian espresso with citrus notes', 18.99, 1, 'Italy', 'Dark', 'Citrus, Bold, Traditional', 30, 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400'),

-- Single Origin Category
('Ethiopian Yirgacheffe', 'Bright and floral single origin with citrus notes', 18.99, 2, 'Ethiopia', 'Light', 'Citrus, Floral, Tea-like', 50, 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=400'),
('Colombian Supremo', 'Well-balanced medium roast from Colombian highlands', 15.99, 2, 'Colombia', 'Medium', 'Caramel, Smooth, Balanced', 60, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400'),
('Brazilian Santos', 'Smooth Brazilian coffee with nutty undertones', 13.99, 2, 'Brazil', 'Medium', 'Nutty, Smooth, Mild', 55, 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400'),
('Jamaican Blue Mountain', 'Premium coffee with mild flavor and no bitterness', 45.99, 2, 'Jamaica', 'Medium', 'Mild, Sweet, Complex', 20, 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=400'),

-- Cold Brew Category
('Cold Brew Concentrate', 'Smooth cold brew concentrate, just add water or milk', 12.99, 3, 'Multi-Origin', 'Medium', 'Smooth, Low Acid, Refreshing', 30, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400'),
('Vanilla Cold Brew', 'Cold brew with natural vanilla flavoring', 14.99, 3, 'Guatemala Blend', 'Medium', 'Vanilla, Sweet, Smooth', 25, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=400'),
('Nitro Cold Brew', 'Nitrogen-infused cold brew for creamy texture', 16.99, 3, 'Colombian Blend', 'Medium', 'Creamy, Smooth, Rich', 20, 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400'),

-- Decaf Category
('Swiss Water Decaf', 'Chemical-free decaffeinated coffee with full flavor', 17.99, 4, 'Guatemala', 'Medium', 'Chocolate, Nutty, Full Body', 40, 'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400'),
('Organic Decaf Blend', 'Organic decaffeinated coffee blend', 19.99, 4, 'Peru', 'Medium', 'Organic, Clean, Balanced', 35, 'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=400'),
('Evening Decaf', 'Perfect decaf blend for evening enjoyment', 15.99, 4, 'Mexican Blend', 'Medium-Dark', 'Smooth, Rich, Mellow', 45, 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400'),

-- Accessories Category
('Premium Coffee Grinder', 'Burr coffee grinder for consistent grind', 89.99, 5, 'Germany', 'N/A', 'Precision, Durable, Consistent', 15, 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400'),
('French Press', 'Classic French press for rich coffee brewing', 29.99, 5, 'France', 'N/A', 'Classic, Simple, Effective', 25, 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=400'),
('Pour Over Dripper', 'V60 style pour over dripper', 24.99, 5, 'Japan', 'N/A', 'Precise, Clean, Bright', 30, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400'),
('Coffee Scale', 'Digital scale for precise coffee measurements', 39.99, 5, 'China', 'N/A', 'Accurate, Digital, Essential', 20, 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=400'),
('Milk Frother', 'Electric milk frother for perfect foam', 34.99, 5, 'Italy', 'N/A', 'Creamy, Electric, Professional', 18, 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400');

-- Display completion message
SELECT 'Coffee Haven core tables created successfully!' as Message;
SELECT COUNT(*) as 'Categories Created' FROM Categories;
SELECT COUNT(*) as 'Products Created' FROM Products;