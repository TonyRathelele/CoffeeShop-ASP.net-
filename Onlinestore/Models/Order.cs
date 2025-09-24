using System.ComponentModel.DataAnnotations;

public class Order
{
    public int Id { get; set; }
    
    [Required]
    public string UserId { get; set; } = string.Empty;
    
    public DateTime OrderDate { get; set; }
    
    [Range(0.01, double.MaxValue)]
    public decimal TotalAmount { get; set; }
    
    public string Status { get; set; } = "Pending";
    public string? ShippingAddress { get; set; }
    public string? PaymentMethod { get; set; }
    
    public ICollection<OrderItem> Items { get; set; } = new List<OrderItem>();
} 