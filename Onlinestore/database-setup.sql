-- Coffee Haven Database Setup Script
-- Run this script to create the database and all required tables

-- Create Database
CREATE DATABASE IF NOT EXISTS CoffeeHavenDb;
USE CoffeeHavenDb;

-- Drop existing tables if they exist (in correct order to handle foreign keys)
DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS CartItems;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS AspNetUserTokens;
DROP TABLE IF EXISTS AspNetUserRoles;
DROP TABLE IF EXISTS AspNetUserLogins;
DROP TABLE IF EXISTS AspNetUserClaims;
DROP TABLE IF EXISTS AspNetRoleClaims;
DROP TABLE IF EXISTS AspNetUsers;
DROP TABLE IF EXISTS AspNetRoles;

-- Create ASP.NET Identity Tables
CREATE TABLE AspNetRoles (
    Id VARCHAR(255) NOT NULL PRIMARY KEY,
    Name VARCHAR(256) NULL,
    NormalizedName VARCHAR(256) NULL UNIQUE,
    ConcurrencyStamp LONGTEXT NULL
);

CREATE TABLE AspNetUsers (
    Id VARCHAR(255) NOT NULL PRIMARY KEY,
    UserName VARCHAR(256) NULL,
    NormalizedUserName VARCHAR(256) NULL UNIQUE,
    Email VARCHAR(256) NULL,
    NormalizedEmail VARCHAR(256) NULL,
    EmailConfirmed BOOLEAN NOT NULL DEFAULT FALSE,
    PasswordHash LONGTEXT NULL,
    SecurityStamp LONGTEXT NULL,
    ConcurrencyStamp LONGTEXT NULL,
    PhoneNumber LONGTEXT NULL,
    PhoneNumberConfirmed BOOLEAN NOT NULL DEFAULT FALSE,
    TwoFactorEnabled BOOLEAN NOT NULL DEFAULT FALSE,
    LockoutEnd DATETIME(6) NULL,
    LockoutEnabled BOOLEAN NOT NULL DEFAULT FALSE,
    AccessFailedCount INT NOT NULL DEFAULT 0
);

CREATE TABLE AspNetRoleClaims (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    RoleId VARCHAR(255) NOT NULL,
    ClaimType LONGTEXT NULL,
    ClaimValue LONGTEXT NULL,
    FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE
);

CREATE TABLE AspNetUserClaims (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    UserId VARCHAR(255) NOT NULL,
    ClaimType LONGTEXT NULL,
    ClaimValue LONGTEXT NULL,
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE TABLE AspNetUserLogins (
    LoginProvider VARCHAR(255) NOT NULL,
    ProviderKey VARCHAR(255) NOT NULL,
    ProviderDisplayName LONGTEXT NULL,
    UserId VARCHAR(255) NOT NULL,
    PRIMARY KEY (LoginProvider, ProviderKey),
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE TABLE AspNetUserRoles (
    UserId VARCHAR(255) NOT NULL,
    RoleId VARCHAR(255) NOT NULL,
    PRIMARY KEY (UserId, RoleId),
    FOREIGN KEY (RoleId) REFERENCES AspNetRoles(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE TABLE AspNetUserTokens (
    UserId VARCHAR(255) NOT NULL,
    LoginProvider VARCHAR(255) NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Value LONGTEXT NULL,
    PRIMARY KEY (UserId, LoginProvider, Name),
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

-- Create Coffee Shop Tables
CREATE TABLE Categories (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Description VARCHAR(200) NULL,
    ImageUrl LONGTEXT NULL
);

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

CREATE TABLE CartItems (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProductId INT NOT NULL,
    UserId VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL,
    ProductName LONGTEXT NULL,
    Price DECIMAL(18,2) NOT NULL DEFAULT 0,
    ImageUrl LONGTEXT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE TABLE Orders (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    UserId VARCHAR(255) NOT NULL,
    OrderDate DATETIME(6) NOT NULL,
    TotalAmount DECIMAL(18,2) NOT NULL,
    Status VARCHAR(50) NULL DEFAULT 'Pending',
    ShippingAddress LONGTEXT NULL,
    PaymentMethod VARCHAR(50) NULL,
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

CREATE TABLE OrderItems (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES Orders(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE CASCADE
);

CREATE TABLE Reviews (
    Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ProductId INT NOT NULL,
    UserId VARCHAR(255) NOT NULL,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment VARCHAR(1000) NULL,
    CreatedAt DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE CASCADE,
    FOREIGN KEY (UserId) REFERENCES AspNetUsers(Id) ON DELETE CASCADE
);

-- Create Indexes for better performance
CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
CREATE INDEX IX_CartItems_ProductId ON CartItems(ProductId);
CREATE INDEX IX_CartItems_UserId ON CartItems(UserId);
CREATE INDEX IX_Orders_UserId ON Orders(UserId);
CREATE INDEX IX_OrderItems_OrderId ON OrderItems(OrderId);
CREATE INDEX IX_OrderItems_ProductId ON OrderItems(ProductId);
CREATE INDEX IX_Reviews_ProductId ON Reviews(ProductId);
CREATE INDEX IX_Reviews_UserId ON Reviews(UserId);
CREATE INDEX IX_AspNetUsers_NormalizedEmail ON AspNetUsers(NormalizedEmail);
CREATE INDEX IX_AspNetUsers_NormalizedUserName ON AspNetUsers(NormalizedUserName);

-- Insert Sample Categories
INSERT INTO Categories (Id, Name, Description, ImageUrl) VALUES
(1, 'Espresso', 'Rich and bold espresso blends', '/images/category-espresso.jpg'),
(2, 'Single Origin', 'Premium single origin coffees', '/images/category-single-origin.jpg'),
(3, 'Cold Brew', 'Smooth cold brew concentrates', '/images/category-cold-brew.jpg'),
(4, 'Decaf', 'Decaffeinated coffee options', '/images/category-decaf.jpg'),
(5, 'Accessories', 'Coffee brewing accessories', '/images/category-accessories.jpg');

-- Insert Sample Products
INSERT INTO Products (Id, Name, Description, Price, CategoryId, Origin, RoastLevel, FlavorNotes, StockQuantity, ImageUrl) VALUES
(1, 'Ethiopian Yirgacheffe', 'Bright and floral single origin with citrus notes', 18.99, 2, 'Ethiopia', 'Light', 'Citrus, Floral, Tea-like', 50, '/images/ethiopian-yirgacheffe.jpg'),
(2, 'Italian Espresso Blend', 'Classic dark roast espresso blend', 16.99, 1, 'Blend', 'Dark', 'Chocolate, Nutty, Bold', 75, '/images/italian-espresso.jpg'),
(3, 'Colombian Supremo', 'Well-balanced medium roast from Colombia', 15.99, 2, 'Colombia', 'Medium', 'Caramel, Smooth, Balanced', 60, '/images/colombian-supremo.jpg'),
(4, 'Cold Brew Concentrate', 'Smooth cold brew concentrate, just add water', 12.99, 3, 'Blend', 'Medium', 'Smooth, Low Acid, Refreshing', 30, '/images/cold-brew.jpg'),
(5, 'Swiss Water Decaf', 'Chemical-free decaffeinated coffee', 17.99, 4, 'Guatemala', 'Medium', 'Chocolate, Nutty, Full Body', 40, '/images/swiss-decaf.jpg'),
(6, 'French Roast', 'Bold and smoky dark roast', 14.99, 1, 'Blend', 'Dark', 'Smoky, Bold, Intense', 45, '/images/french-roast.jpg'),
(7, 'Brazilian Santos', 'Smooth Brazilian coffee with nutty undertones', 13.99, 2, 'Brazil', 'Medium', 'Nutty, Smooth, Mild', 55, '/images/brazilian-santos.jpg'),
(8, 'Vanilla Cold Brew', 'Cold brew with natural vanilla flavoring', 14.99, 3, 'Blend', 'Medium', 'Vanilla, Sweet, Smooth', 25, '/images/vanilla-cold-brew.jpg'),
(9, 'Organic Decaf Blend', 'Organic decaffeinated coffee blend', 19.99, 4, 'Peru', 'Medium', 'Organic, Clean, Balanced', 35, '/images/organic-decaf.jpg'),
(10, 'Coffee Grinder', 'Premium burr coffee grinder', 89.99, 5, 'Germany', 'N/A', 'Precision, Durable, Consistent', 15, '/images/coffee-grinder.jpg');

-- Create a sample admin user (password will need to be hashed properly in the application)
-- This is just a placeholder - the actual user creation should be done through the application
INSERT INTO AspNetUsers (Id, UserName, NormalizedUserName, Email, NormalizedEmail, EmailConfirmed, SecurityStamp, ConcurrencyStamp) VALUES
('admin-user-id', 'admin@coffeehaven.com', 'ADMIN@COFFEEHAVEN.COM', 'admin@coffeehaven.com', 'ADMIN@COFFEEHAVEN.COM', TRUE, NEWID(), NEWID());

-- Display success message
SELECT 'Coffee Haven database setup completed successfully!' as Message;
SELECT 'Tables created:' as Info;
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'CoffeeHavenDb' ORDER BY TABLE_NAME;