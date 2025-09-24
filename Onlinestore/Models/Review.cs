using System.ComponentModel.DataAnnotations;

public class Review
{
    public int Id { get; set; }
    
    [Required]
    public int ProductId { get; set; }
    public Product Product { get; set; } = null!;
    
    [Required]
    public string UserId { get; set; } = string.Empty;
    public ApplicationUser User { get; set; } = null!;
    
    [Range(1, 5)]
    public int Rating { get; set; }
    
    [StringLength(1000)]
    public string Comment { get; set; } = string.Empty;
    
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}