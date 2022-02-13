using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TudoracheAlexandruT42.Models;

namespace TudoracheAlexandruT42.Controllers
{
    public class DomainController : Controller
    {
        private Models.AppContext db = new Models.AppContext();
        // GET: Domain
        public ActionResult Index()
        {
            if (TempData.ContainsKey("message"))
            {
                ViewBag.Message = TempData["message"];
            }
            return View();
        }

        public ActionResult New()
        {
            Domain dm = new Domain();
            return View(dm);
        }

        [HttpPost]
        public ActionResult New(Domain dm)
        {
            try
            {
                db.Domains.Add(dm);
                db.SaveChanges();
                TempData["message"] = "Domeniul a fost adaugat cu succes!";
                return RedirectToAction("Index");
            }
            catch (Exception e)
            {
                return View(dm);
            }
        }
    }
}