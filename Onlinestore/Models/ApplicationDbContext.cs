using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<Product> Products { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<CartItem> CartItems { get; set; }
    public DbSet<Order> Orders { get; set; }
    public DbSet<OrderItem> OrderItems { get; set; }
    public DbSet<Review> Reviews { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Configure relationships
        modelBuilder.Entity<Product>()
            .HasOne(p => p.Category)
            .WithMany(c => c.Products)
            .HasForeignKey(p => p.CategoryId);

        modelBuilder.Entity<Review>()
            .HasOne(r => r.Product)
            .WithMany()
            .HasForeignKey(r => r.ProductId);

        modelBuilder.Entity<Review>()
            .HasOne(r => r.User)
            .WithMany()
            .HasForeignKey(r => r.UserId);

        // Seed data
        modelBuilder.Entity<Category>().HasData(
            new Category { Id = 1, Name = "Espresso", Description = "Rich and bold espresso blends" },
            new Category { Id = 2, Name = "Single Origin", Description = "Premium single origin coffees" },
            new Category { Id = 3, Name = "Cold Brew", Description = "Smooth cold brew concentrates" },
            new Category { Id = 4, Name = "Decaf", Description = "Decaffeinated coffee options" },
            new Category { Id = 5, Name = "Accessories", Description = "Coffee brewing accessories" }
        );

        modelBuilder.Entity<Product>().HasData(
            new Product { Id = 1, Name = "Ethiopian Yirgacheffe", Description = "Bright and floral single origin with citrus notes", Price = 18.99m, CategoryId = 2, Origin = "Ethiopia", RoastLevel = "Light", FlavorNotes = "Citrus, Floral, Tea-like", StockQuantity = 50, ImageUrl = "/images/ethiopian-yirgacheffe.jpg" },
            new Product { Id = 2, Name = "Italian Espresso Blend", Description = "Classic dark roast espresso blend", Price = 16.99m, CategoryId = 1, Origin = "Blend", RoastLevel = "Dark", FlavorNotes = "Chocolate, Nutty, Bold", StockQuantity = 75, ImageUrl = "/images/italian-espresso.jpg" },
            new Product { Id = 3, Name = "Colombian Supremo", Description = "Well-balanced medium roast from Colombia", Price = 15.99m, CategoryId = 2, Origin = "Colombia", RoastLevel = "Medium", FlavorNotes = "Caramel, Smooth, Balanced", StockQuantity = 60, ImageUrl = "/images/colombian-supremo.jpg" },
            new Product { Id = 4, Name = "Cold Brew Concentrate", Description = "Smooth cold brew concentrate, just add water", Price = 12.99m, CategoryId = 3, Origin = "Blend", RoastLevel = "Medium", FlavorNotes = "Smooth, Low Acid, Refreshing", StockQuantity = 30, ImageUrl = "/images/cold-brew.jpg" },
            new Product { Id = 5, Name = "Swiss Water Decaf", Description = "Chemical-free decaffeinated coffee", Price = 17.99m, CategoryId = 4, Origin = "Guatemala", RoastLevel = "Medium", FlavorNotes = "Chocolate, Nutty, Full Body", StockQuantity = 40, ImageUrl = "/images/swiss-decaf.jpg" }
        );
    }
} 