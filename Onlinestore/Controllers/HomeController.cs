using Microsoft.AspNetCore.Mvc;
using Onlinstore.Models;
using System.Diagnostics;

namespace Onlinstore.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly ProductService _productService;
        private readonly CartService _cartService;

        public HomeController(ILogger<HomeController> logger, ProductService productService, CartService cartService)
        {
            _logger = logger;
            _productService = productService;
            _cartService = cartService;
        }

        public async Task<IActionResult> Index()
        {
            var featuredProducts = await _productService.GetFeaturedProductsAsync();
            var categories = await _productService.GetCategoriesAsync();
            
            ViewBag.Categories = categories;
            ViewBag.CartItemCount = _cartService.GetCartItemCount();
            
            return View(featuredProducts);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult About()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Contact()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Contact(string name, string email, string message)
        {
            // Here you could send an email or save the message
            ViewBag.Name = name;
            return View("ContactThankYou");
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
