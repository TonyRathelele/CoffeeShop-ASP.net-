using System.ComponentModel.DataAnnotations;

public class Category
{
    public int Id { get; set; }
    
    [Required]
    [StringLength(50)]
    public string Name { get; set; } = string.Empty;
    
    [StringLength(200)]
    public string Description { get; set; } = string.Empty;
    
    public string ImageUrl { get; set; } = string.Empty;
    
    public ICollection<Product> Products { get; set; } = new List<Product>();
}