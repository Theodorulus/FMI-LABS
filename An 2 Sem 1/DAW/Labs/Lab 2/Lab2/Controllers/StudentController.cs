using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Lab2.Controllers
{
    public class StudentController : Controller
    {
        // GET: Student
        public string Index()
        {
            return "Lista tuturor studentilor.";
        }

        public string Create()
        {
            return "Adaugarea unui student.";
        }

        public string Show(string id)
        {
            return "Afisarea studentului cu ID: " + id;
        }

        public string Edit(string id)
        {
            return "Editarea studentului cu ID: " + id;
        }

        public string Delete(string id)
        {
            return "Stergerea studentului cu ID: " + id;
        }
    }
}