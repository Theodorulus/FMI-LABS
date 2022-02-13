using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Lab2.Controllers
{
    public class SearchController : Controller
    {
        // GET: Search
        public ActionResult Index()
        {
            return View();
        }

        public string NumarTelefon(string telef)
        {
            if (telef == null)
            {
                return "Introduceti nr. de telefon.";
            }

            string first = telef.Substring(0, 1);

            if (first != "0")
                return "Numarul de telefon nu incepe cu 0.";

            if (telef.Length < 10)
                return "Numarul de telefon nu are suficiente cifre.";

            if (telef.Length > 10)
                return "Numarul de telefon are prea mult cifre.";


            return "Nr. de telefon: " + telef;
        }

        public string Cenepe(string cnp)
        {
            string first = cnp.Substring(0, 1);
            
            if (first != "1" && first != "2" && first != "5" && first != "6")
                return "CNP-ul nu incepe cu o cifra corespunzatoare.";
            return "CNP:" + cnp;
        }
    }
}