using FriendRequest.Models;
using Microsoft.AspNet.Identity;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FriendRequest.Controllers
{
    public class UsersController : Controller
    {
        public ApplicationDbContext db = ApplicationDbContext.Create();
        // GET: Users
        public ActionResult Index()
        {
            var users  = (from user in db.Users
                                            .Include(u => u.SentRequests)
                                            .Include(u => u.ReceivedRequests)
                         select user).ToList();
            ViewBag.Users = users;
           
            return View();
        }

        [HttpPost]
        public ActionResult AddFriend(FormCollection formData)
        {
            string currentUser = User.Identity.GetUserId();
            string friendToAdd = formData.Get("UserId"); // TODO: trebuie validare (verificare daca userul exista)

            Friend friendship = new Friend();
            friendship.User1_Id = currentUser;
            friendship.User2_Id = friendToAdd;
            friendship.Accepted = true; // Accepted = false, iar in lista de cereri -> accept
            friendship.RequestTime = DateTime.Now;

            // TODO: sa existe try si catch astfel incat sa nu se trimita o cerere de doua ori
            // verificare daca userul a primit deja cerere de la userul caruia doreste sa ii trimita
            // de verificat ca user1 sa nu fie deja prieten cu user2

            db.Friends.Add(friendship);
            db.SaveChanges();

            return RedirectToAction("Index");
        }
    }
}