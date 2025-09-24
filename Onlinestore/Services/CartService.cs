using Microsoft.Extensions.Caching.Memory;
using System.Text.Json;

public class CartService
{
    private readonly IMemoryCache _cache;
    private readonly IHttpContextAccessor _httpContextAccessor;
    private const string CART_SESSION_KEY = "ShoppingCart";

    public CartService(IMemoryCache cache, IHttpContextAccessor httpContextAccessor)
    {
        _cache = cache;
        _httpContextAccessor = httpContextAccessor;
    }

    public ShoppingCart GetCart()
    {
        var session = _httpContextAccessor.HttpContext?.Session;
        if (session == null) return new ShoppingCart();

        var cartJson = session.GetString(CART_SESSION_KEY);
        if (string.IsNullOrEmpty(cartJson))
        {
            return new ShoppingCart();
        }

        return JsonSerializer.Deserialize<ShoppingCart>(cartJson) ?? new ShoppingCart();
    }

    public void SaveCart(ShoppingCart cart)
    {
        var session = _httpContextAccessor.HttpContext?.Session;
        if (session == null) return;

        var cartJson = JsonSerializer.Serialize(cart);
        session.SetString(CART_SESSION_KEY, cartJson);
    }

    public void ClearCart()
    {
        var session = _httpContextAccessor.HttpContext?.Session;
        session?.Remove(CART_SESSION_KEY);
    }

    public int GetCartItemCount()
    {
        return GetCart().ItemCount;
    }
}