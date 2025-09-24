using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

public class CartController : Controller
{
    private readonly ApplicationDbContext _context;
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly CartService _cartService;

    public CartController(ApplicationDbContext context, UserManager<ApplicationUser> userManager, CartService cartService)
    {
        _context = context;
        _userManager = userManager;
        _cartService = cartService;
    }

    public IActionResult Index()
    {
        var cart = _cartService.GetCart();
        ViewBag.CartItemCount = cart.ItemCount;
        return View(cart);
    }

    [HttpPost]
    public IActionResult UpdateQuantity(int productId, int quantity)
    {
        var cart = _cartService.GetCart();
        cart.UpdateQuantity(productId, quantity);
        _cartService.SaveCart(cart);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public IActionResult Remove(int productId)
    {
        var cart = _cartService.GetCart();
        cart.RemoveItem(productId);
        _cartService.SaveCart(cart);
        return RedirectToAction("Index");
    }

    [HttpPost]
    public async Task<IActionResult> Checkout()
    {
        if (!User.Identity?.IsAuthenticated ?? true)
        {
            return RedirectToAction("Login", "Account");
        }

        var cart = _cartService.GetCart();
        if (!cart.Items.Any())
        {
            TempData["Error"] = "Your cart is empty.";
            return RedirectToAction("Index");
        }

        var userId = _userManager.GetUserId(User);
        var order = new Order
        {
            UserId = userId!,
            OrderDate = DateTime.UtcNow,
            TotalAmount = cart.Total,
            Items = cart.Items.Select(item => new OrderItem
            {
                ProductId = item.ProductId,
                Quantity = item.Quantity,
                Price = item.Price
            }).ToList()
        };

        _context.Orders.Add(order);
        await _context.SaveChangesAsync();

        // Clear the cart
        _cartService.ClearCart();

        TempData["Success"] = "Order placed successfully!";
        return RedirectToAction("OrderConfirmation", new { orderId = order.Id });
    }

    public async Task<IActionResult> OrderConfirmation(int orderId)
    {
        var order = await _context.Orders.Include(o => o.Items).ThenInclude(i => i.Product).FirstOrDefaultAsync(o => o.Id == orderId);
        if (order == null) return NotFound();
        return View(order);
    }

    public async Task<IActionResult> OrderHistory()
    {
        var userId = _userManager.GetUserId(User);
        var orders = await _context.Orders
            .Where(o => o.UserId == userId)
            .OrderByDescending(o => o.OrderDate)
            .Include(o => o.Items)
            .ThenInclude(i => i.Product)
            .ToListAsync();
        return View(orders);
    }
} 