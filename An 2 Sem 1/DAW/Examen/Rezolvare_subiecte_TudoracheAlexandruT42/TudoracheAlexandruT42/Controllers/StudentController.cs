using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using TudoracheAlexandruT42.Models;

namespace TudoracheAlexandruT42.Controllers
{
    public class StudentController : Controller
    {
        private Models.AppContext db = new Models.AppContext();
        // GET: Student
        public ActionResult Index()
        {
            var students = db.Students.Include("Domain");
            ViewBag.Students = students;
            if (TempData.ContainsKey("message"))
            {
                ViewBag.Message = TempData["message"];
            }
            return View();
        }

        [ActionName("afisareStudent")]
        public ActionResult Show(int id)
        {
            Student student = db.Students.Find(id);
            return View(student);
        }

        public ActionResult New()
        {
            Student student = new Student();
            student.Dom = GetAllDomains();
            return View(student);
        }

        [HttpPost]
        public ActionResult New(Student student)
        {
            student.Dom = GetAllDomains();
            try
            {
                if (ModelState.IsValid)
                {
                    db.Students.Add(student);
                    db.SaveChanges();
                    TempData["message"] = "Studentul a fost adaugat cu succes!";
                    return RedirectToAction("Index");
                }
                else
                {
                    return View(student);
                }
            }
            catch (Exception e)
            {
                return View(student);
            }
        }

        public ActionResult Edit(int id)
        {
            Student student = db.Students.Find(id);
            student.Dom = GetAllDomains();
            return View(student);
        }


        [HttpPut]
        public ActionResult Edit(int id, Student requestStudent)
        {
            requestStudent.Dom = GetAllDomains();
            try
            {
                if (ModelState.IsValid)
                {
                    Student student = db.Students.Find(id);
                    if (TryUpdateModel(student))
                    {
                        student.Nume = requestStudent.Nume;
                        student.Email = requestStudent.Email;
                        student.DataNastere = requestStudent.DataNastere;
                        student.DomainId = requestStudent.DomainId;
                        db.SaveChanges();
                        TempData["message"] = "Studentul a fost modificat!";
                        return RedirectToAction("Index");
                    }
                    else
                    {
                        return View(requestStudent);
                    }
                }
                else
                {
                    return View(requestStudent);
                }

            }
            catch (Exception e)
            {
                return View(requestStudent);
            }
        }

        [HttpDelete]
        public ActionResult Delete(int id)
        {
            Student student = db.Students.Find(id);
            db.Students.Remove(student);
            db.SaveChanges();
            TempData["message"] = "Studentul a fost sters cu succes!";
            return RedirectToAction("Index");
        }

        public ActionResult Search()
        {
            IEnumerable<SelectListItem> domenii = GetAllDomains();
            ViewBag.Domenii = domenii;
            return View();
        }

        public ActionResult SearchRes(string nume_cautat, string dom)
        {
            if (!String.IsNullOrEmpty(nume_cautat))
            {
                ViewBag.SearchRes = db.Students.Where(s => s.Nume.Contains(nume_cautat) && s.DomainId.ToString() == dom).ToList();
                return View();
            }
            else
            {
                return Redirect(Request.UrlReferrer.ToString());
            }
        }


        private IEnumerable<SelectListItem> GetAllDomains()
        {
            var selectList = new List<SelectListItem>();
            var domains = from dm in db.Domains
                           select dm;
            foreach (var domain in domains)
            {
                var listItem = new SelectListItem();

                listItem.Value = domain.Id.ToString();
                listItem.Text = domain.Denumire.ToString();

                selectList.Add(listItem);
            }
            return selectList;
        }
    }
}