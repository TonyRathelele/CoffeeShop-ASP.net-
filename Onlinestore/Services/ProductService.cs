using Microsoft.Extensions.Caching.Memory;
using Microsoft.EntityFrameworkCore;

public class ProductService
{
    private readonly ApplicationDbContext _context;
    private readonly IMemoryCache _cache;
    private const int CACHE_DURATION_MINUTES = 30;

    public ProductService(ApplicationDbContext context, IMemoryCache cache)
    {
        _context = context;
        _cache = cache;
    }

    public async Task<List<Product>> GetFeaturedProductsAsync()
    {
        const string cacheKey = "featured_products";
        
        if (!_cache.TryGetValue(cacheKey, out List<Product>? products))
        {
            products = await _context.Products
                .Include(p => p.Category)
                .Where(p => p.IsAvailable)
                .Take(6)
                .ToListAsync();

            _cache.Set(cacheKey, products, TimeSpan.FromMinutes(CACHE_DURATION_MINUTES));
        }

        return products ?? new List<Product>();
    }

    public async Task<List<Product>> GetProductsByCategoryAsync(int categoryId)
    {
        string cacheKey = $"products_category_{categoryId}";
        
        if (!_cache.TryGetValue(cacheKey, out List<Product>? products))
        {
            products = await _context.Products
                .Include(p => p.Category)
                .Where(p => p.CategoryId == categoryId && p.IsAvailable)
                .ToListAsync();

            _cache.Set(cacheKey, products, TimeSpan.FromMinutes(CACHE_DURATION_MINUTES));
        }

        return products ?? new List<Product>();
    }

    public async Task<Product?> GetProductByIdAsync(int id)
    {
        string cacheKey = $"product_{id}";
        
        if (!_cache.TryGetValue(cacheKey, out Product? product))
        {
            product = await _context.Products
                .Include(p => p.Category)
                .FirstOrDefaultAsync(p => p.Id == id);

            if (product != null)
            {
                _cache.Set(cacheKey, product, TimeSpan.FromMinutes(CACHE_DURATION_MINUTES));
            }
        }

        return product;
    }

    public async Task<List<Category>> GetCategoriesAsync()
    {
        const string cacheKey = "categories";
        
        if (!_cache.TryGetValue(cacheKey, out List<Category>? categories))
        {
            categories = await _context.Categories.ToListAsync();
            _cache.Set(cacheKey, categories, TimeSpan.FromMinutes(CACHE_DURATION_MINUTES * 2));
        }

        return categories ?? new List<Category>();
    }

    public void ClearProductCache()
    {
        // In a real application, you'd want a more sophisticated cache invalidation strategy
        _cache.Remove("featured_products");
        _cache.Remove("categories");
    }
}