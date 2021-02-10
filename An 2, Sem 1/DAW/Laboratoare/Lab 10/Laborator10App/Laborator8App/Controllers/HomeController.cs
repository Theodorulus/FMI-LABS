using Laborator8App.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Laborator8App.Controllers
{
    public class HomeController : Controller
    {
        private ApplicationDbContext db = new ApplicationDbContext();

        public ActionResult Index()
        {
            if (Request.IsAuthenticated)
            {
                return RedirectToAction("Index", "Articles");
            }

            var articles = from article in db.Articles
                            select article;

            ViewBag.FirstArticle = articles.First();
            ViewBag.Articles = articles.OrderBy(o => o.Date).Skip(1).Take(2);

            return View();
        }

        /*
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

    */
    }
}