using Lab3.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Lab3.Controllers
{
    public class ArticlesController : Controller
    {
        // GET: Articles
        [ActionName("listare")]
        [OutputCache(Duration = 30)]
        public ActionResult Index()
        {
            Article[] articles = GetArticles();

            ViewBag.Articles = articles;

            return View("Index");
        }

        //GET implicit: Vizualizarea unui articol
        public ActionResult Show(int id)
        {
            Article[] articles = GetArticles();

            try
            {
                ViewBag.Article = articles[id];
                return View();
            }
            catch(Exception e)
            {
                ViewBag.ErrorMessage = e.Message;
                return View("Error");
            }
            
        }

        //GET: Afisarea formularului de adaugare articol nou
        public ActionResult New()
        {
            return View();
        }

        [HttpPost]
        public ActionResult New(Article article)
        {
            //...cod creare articol...
            return View("NewPostMethod");
        }

        //GET: Afisarea datelor unui articol pentru editare
        public ActionResult Edit(int id)
        {
            ViewBag.Id = id;
            return View();
        }

        [HttpPut]
        public ActionResult Edit(Article article)
        {
            //...cod modificare articol...
            return View("EditPutMethod");
        }

        [HttpDelete]
        public ActionResult Delete(Article article)
        {
            //...cod stergere articol...
            return View("DeleteMethod");
        }

        [NonAction]
        public Article[] GetArticles()
        {
            // Instantiem un array de articole
            Article[] articles = new Article[3];
            // Cream articole
            for (int i = 0; i < 3; i++)
            {
                Article article = new Article();
                article.Id = i;
                article.Title = "Articol " + (i + 1).ToString();
                article.Content = "Continut articol " + (i + 1).ToString();
                article.Date = DateTime.Now;
                // Adaugam articolul in array
                articles[i] = article;
            }
            return articles;
        }
    }
}
    
        