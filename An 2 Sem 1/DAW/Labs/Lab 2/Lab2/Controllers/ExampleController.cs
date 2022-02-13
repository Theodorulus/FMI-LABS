using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Lab2.Controllers
{
    public class ExampleController : Controller
    {
        // GET: Example
        public ActionResult Index()
        {
            return View();
        }

        public string Concatenare(string param1, string param2)
        {
            return param1 + " " + param2;
        }

        public string Operatie(int? param1, int? param2, string param3)
        {
            if (param1 == null)
            {
                return "Introduceti parametrul 1.";
            }

            if (param2 == null)
            {
                return "Introduceti parametrul 2.";
            }

            if (param3 == null)
            {
                return "Introduceti parametrul 3.";
            }

            if (param3 == "plus")
                return (param1 + param2).ToString();
            else
                if (param3 == "minus")
                    return (param1 - param2).ToString();
                else
                    if (param3 == "ori")
                        return (param1 * param2).ToString();
                    else
                        if (param3 == "div")
                            return (param1 / param2).ToString();
            return "Scriere gresita.";
        }
    }
}