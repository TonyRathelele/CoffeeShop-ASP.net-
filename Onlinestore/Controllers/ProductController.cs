using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;

public class ProductController : Controller
{
    private readonly ApplicationDbContext _context;
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ProductService _productService;
    private readonly CartService _cartService;

    public ProductController(ApplicationDbContext context, UserManager<ApplicationUser> userManager, 
        ProductService productService, CartService cartService)
    {
        _context = context;
        _userManager = userManager;
        _productService = productService;
        _cartService = cartService;
    }

    public async Task<IActionResult> Index(int? categoryId, string search)
    {
        List<Product> products;
        
        if (categoryId.HasValue)
        {
            products = await _productService.GetProductsByCategoryAsync(categoryId.Value);
            ViewBag.CategoryName = (await _productService.GetCategoriesAsync())
                .FirstOrDefault(c => c.Id == categoryId.Value)?.Name;
        }
        else if (!string.IsNullOrEmpty(search))
        {
            products = await _context.Products
                .Include(p => p.Category)
                .Where(p => p.Name.Contains(search) || p.Description.Contains(search) || p.FlavorNotes.Contains(search))
                .Where(p => p.IsAvailable)
                .ToListAsync();
            ViewBag.SearchTerm = search;
        }
        else
        {
            products = await _context.Products
                .Include(p => p.Category)
                .Where(p => p.IsAvailable)
                .ToListAsync();
        }

        ViewBag.Categories = await _productService.GetCategoriesAsync();
        ViewBag.CartItemCount = _cartService.GetCartItemCount();
        
        return View(products);
    }

    public async Task<IActionResult> Details(int id)
    {
        var product = await _productService.GetProductByIdAsync(id);
        if (product == null) return NotFound();

        // Get reviews for this product
        var reviews = await _context.Reviews
            .Include(r => r.User)
            .Where(r => r.ProductId == id)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();

        ViewBag.Reviews = reviews;
        ViewBag.AverageRating = reviews.Any() ? reviews.Average(r => r.Rating) : 0;
        ViewBag.CartItemCount = _cartService.GetCartItemCount();

        return View(product);
    }

    [HttpPost]
    public async Task<IActionResult> AddToCart(int productId, int quantity = 1)
    {
        var product = await _productService.GetProductByIdAsync(productId);
        if (product == null) return NotFound();

        var cart = _cartService.GetCart();
        cart.AddItem(product, quantity);
        _cartService.SaveCart(cart);

        TempData["Success"] = $"{product.Name} added to cart!";
        return RedirectToAction("Details", new { id = productId });
    }

    [HttpPost]
    public async Task<IActionResult> AddReview(int productId, int rating, string comment)
    {
        if (!User.Identity?.IsAuthenticated ?? true)
        {
            return RedirectToAction("Login", "Account");
        }

        var userId = _userManager.GetUserId(User);
        var existingReview = await _context.Reviews
            .FirstOrDefaultAsync(r => r.ProductId == productId && r.UserId == userId);

        if (existingReview != null)
        {
            TempData["Error"] = "You have already reviewed this product.";
            return RedirectToAction("Details", new { id = productId });
        }

        var review = new Review
        {
            ProductId = productId,
            UserId = userId!,
            Rating = rating,
            Comment = comment ?? string.Empty
        };

        _context.Reviews.Add(review);
        await _context.SaveChangesAsync();

        TempData["Success"] = "Review added successfully!";
        return RedirectToAction("Details", new { id = productId });
    }
} 