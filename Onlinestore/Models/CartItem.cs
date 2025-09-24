public class CartItem
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public Product? Product { get; set; }
    public string UserId { get; set; } = string.Empty;
    public int Quantity { get; set; }
    
    // For session-based cart
    public string ProductName { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public string ImageUrl { get; set; } = string.Empty;
} 