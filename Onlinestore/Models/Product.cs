using System.ComponentModel.DataAnnotations;

public class Product
{
    public int Id { get; set; }
    
    [Required]
    [StringLength(100)]
    public string Name { get; set; } = string.Empty;
    
    [StringLength(500)]
    public string Description { get; set; } = string.Empty;
    
    [Required]
    [Range(0.01, 999.99)]
    public decimal Price { get; set; }
    
    public string ImageUrl { get; set; } = string.Empty;
    
    [Required]
    public int CategoryId { get; set; }
    public Category Category { get; set; } = null!;
    
    public string Origin { get; set; } = string.Empty;
    public string RoastLevel { get; set; } = string.Empty;
    public string FlavorNotes { get; set; } = string.Empty;
    public bool IsAvailable { get; set; } = true;
    public int StockQuantity { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
} 