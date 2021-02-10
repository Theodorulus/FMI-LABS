using Lab8.Models;
using Laborator5App.Models;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Laborator5App.Controllers
{
    public class ArticlesController : Controller
    {
        private ApplicationDbContext db = ApplicationDbContext.Create();

        // GET: Article
        public ActionResult Index()
        {
            var articles = db.Articles.Include("Category").Include("User");
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
            //ViewBag.Article = article;
            //ViewBag.Category = article.Category;

            return View(article);

        }

        [Authorize(Roles = "Editor,Admin")]
        public ActionResult New()
        {
            Article article = new Article();
            article.Categ = GetAllCategories();

            //Preluam ID-ul utilizatorului curent
            article.UserId = User.Identity.GetUserId();

            return View(article);
        }

        [HttpPost]
        [Authorize(Roles = "Editor,Admin")]
        public ActionResult New(Article article)
        {
            article.Date = DateTime.Now;
            article.UserId = User.Identity.GetUserId();

            try
            {
                if(ModelState.IsValid)
                {
                    db.Articles.Add(article);
                    db.SaveChanges();
                    TempData["message"] = "Articolul a fost adaugat cu succes!";
                    return RedirectToAction("Index");
                }
                else
                {
                    article.Categ = GetAllCategories();
                    return View(article);
                }
            }
            catch (Exception e)
            {
                return View(article);
            }
        }

        [Authorize(Roles = "Editor,Admin")]
        public ActionResult Edit(int id)
        {

            Article article = db.Articles.Find(id);
            article.Categ = GetAllCategories();
            return View(article);
        }


        [HttpPut]
        [Authorize(Roles = "Editor,Admin")]
        public ActionResult Edit(int id, Article requestArticle)
        {
            requestArticle.Categ = GetAllCategories();
            try
            {
                if (ModelState.IsValid)
                {
                    Article article = db.Articles.Find(id);
                    if (TryUpdateModel(article))
                    {
                        //article = requestArticle;
                        article.Title = requestArticle.Title;
                        article.Content = requestArticle.Content;
                        //article.Date = requestArticle.Date;
                        article.CategoryId = requestArticle.CategoryId;
                        db.SaveChanges();
                        TempData["message"] = "Articolul a fost modificat!";
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        return View(requestArticle);
                    }
                }
                else
                {
                    return View(requestArticle);
                }

            }
            catch (Exception e)
            {
                return View(requestArticle);
            }
        }

        [HttpDelete]
        [Authorize(Roles = "Editor,Admin")]
        public ActionResult Delete(int id)
        {
            Article article = db.Articles.Find(id);
            db.Articles.Remove(article);
            db.SaveChanges();
            TempData["message"] = "Articolul a fost sters!";
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
 