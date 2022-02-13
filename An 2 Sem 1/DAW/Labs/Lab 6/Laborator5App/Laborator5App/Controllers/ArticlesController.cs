using Laborator5App.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using AppContext = Laborator5App.Models.AppContext;

namespace Laborator5App.Controllers
{
    public class ArticlesController : Controller
    {
        private AppContext db = new Laborator5App.Models.AppContext();

        // GET: Article
        public ActionResult Index()
        {
            var articles = db.Articles.Include("Category");
            ViewBag.Articles = articles;
            if(TempData.ContainsKey("message"))
            {
                ViewBag.Message = TempData["message"];
            }
            return View();
        }

        public ActionResult Show(int id)
        {
            Article article = db.Articles.Find(id);
            ViewBag.Article = article;
            ViewBag.Category = article.Category;

            return View();

        }

        public ActionResult New()
        {
            Article article = new Article();
            article.Categ = GetAllCategories();

            return View(article);
        }

        [HttpPost]
        public ActionResult New(Article article)
        {
            article.Date = DateTime.Now;

            try
            {
                db.Articles.Add(article);
                db.SaveChanges();
                TempData["message"] = "Articolul a fost adaugat cu succes!";
                return RedirectToAction("Index");
            }
            catch (Exception e)
            {
                return View(article);
            }
        }

        public ActionResult Edit(int id)
        {

            Article article = db.Articles.Find(id);
            article.Categ = GetAllCategories();
            return View(article);
        }


        [HttpPut]
        public ActionResult Edit(int id, Article requestArticle)
        {
            try
            {
                Article article = db.Articles.Find(id);
                if (TryUpdateModel(article))
                {
                    //article = requestArticle;
                    article.Title = requestArticle.Title;
                    article.Content = requestArticle.Content;
                    article.Date = requestArticle.Date;
                    article.CategoryId = requestArticle.CategoryId;
                    db.SaveChanges();
                    TempData["message"] = "Articolul a fost modificat!";
                    return RedirectToAction("Index");
                }
                return View(requestArticle);
            }
            catch (Exception e)
            {
                return View(requestArticle);
            }
        }

        [HttpDelete]
        public ActionResult Delete(int id)
        {
            Article article = db.Articles.Find(id);
            db.Articles.Remove(article);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        [NonAction]
        public IEnumerable<SelectListItem> GetAllCategories()
        {
            // generam o lista goala
            var selectList = new List<SelectListItem>();
            // extragem toate categoriile din baza de date
            var categories = from cat in db.Categories
                             select cat;
            // iteram prin categorii
            /*foreach (var category in categories)
            {
                // adaugam in lista elementele necesare pentru dropdown
                selectList.Add(new SelectListItem
                {
                    Value = category.CategoryId.ToString(),
                    Text = category.CategoryName.ToString()
                });
            }*/
            
            foreach (var category in categories)
            {
                var listItem = new SelectListItem();

                listItem.Value = category.CategoryId.ToString();
                listItem.Text = category.CategoryName.ToString();

                selectList.Add(listItem);
            }
            // returnam lista de categorii
            return selectList;
        }
    }
}
 