public class ShoppingCart
{
    public List<CartItem> Items { get; set; } = new List<CartItem>();
    
    public decimal Total => Items.Sum(item => item.Price * item.Quantity);
    
    public int ItemCount => Items.Sum(item => item.Quantity);
    
    public void AddItem(Product product, int quantity = 1)
    {
        var existingItem = Items.FirstOrDefault(i => i.ProductId == product.Id);
        if (existingItem != null)
        {
            existingItem.Quantity += quantity;
        }
        else
        {
            Items.Add(new CartItem
            {
                ProductId = product.Id,
                ProductName = product.Name,
                Price = product.Price,
                Quantity = quantity,
                ImageUrl = product.ImageUrl
            });
        }
    }
    
    public void RemoveItem(int productId)
    {
        Items.RemoveAll(i => i.ProductId == productId);
    }
    
    public void UpdateQuantity(int productId, int quantity)
    {
        var item = Items.FirstOrDefault(i => i.ProductId == productId);
        if (item != null)
        {
            if (quantity <= 0)
                RemoveItem(productId);
            else
                item.Quantity = quantity;
        }
    }
    
    public void Clear()
    {
        Items.Clear();
    }
}