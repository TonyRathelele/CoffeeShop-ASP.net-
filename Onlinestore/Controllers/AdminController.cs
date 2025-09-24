using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using System;

public class AdminController : Controller
{
    private readonly ApplicationDbContext _context;
    private readonly SignInManager<ApplicationUser> _signInManager;

    public AdminController(ApplicationDbContext context, SignInManager<ApplicationUser> signInManager)
    {
        _context = context;
        _signInManager = signInManager;
    }

    [HttpGet]
    public IActionResult Login() => View();

    [HttpPost]
    public async Task<IActionResult> Login(string email, string password)
    {
        var result = await _signInManager.PasswordSignInAsync(email, password, false, false);
        if (result.Succeeded && User.IsInRole("Admin"))
        {
            return RedirectToAction("Dashboard");
        }
        return View();
    }

    public IActionResult Dashboard()
    {
        return View();
    }

    [HttpGet]
    public IActionResult AddProduct() => View();

    [HttpPost]
    public async Task<IActionResult> AddProduct(Product product)
    {
        _context.Products.Add(product);
        await _context.SaveChangesAsync();
        return RedirectToAction("Dashboard");
    }

    [HttpGet]
    public async Task<IActionResult> EditProduct(int id)
    {
        var product = await _context.Products.FindAsync(id);
        if (product == null) return NotFound();
        return View(product);
    }

    [HttpPost]
    public async Task<IActionResult> EditProduct(Product product)
    {
        if (!ModelState.IsValid) return View(product);
        var existing = await _context.Products.FindAsync(product.Id);
        if (existing == null) return NotFound();
        existing.Name = product.Name;
        existing.Description = product.Description;
        existing.Price = product.Price;
        existing.ImageUrl = product.ImageUrl;
        await _context.SaveChangesAsync();
        return RedirectToAction("Dashboard");
    }

    [HttpPost]
    public async Task<IActionResult> DeleteProduct(int id)
    {
        var product = await _context.Products.FindAsync(id);
        if (product != null)
        {
            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
        }
        return RedirectToAction("Dashboard");
    }

    public IActionResult SalesReport(string period)
    {
        var now = DateTime.Now;
        IQueryable<Order> orders = _context.Orders;
        if (period == "month")
        {
            orders = orders.Where(o => o.OrderDate.Month == now.Month && o.OrderDate.Year == now.Year);
        }
        else if (period == "year")
        {
            orders = orders.Where(o => o.OrderDate.Year == now.Year);
        }
        var total = orders.Sum(o => o.TotalAmount);
        ViewBag.TotalSales = total;
        return View();
    }
} 