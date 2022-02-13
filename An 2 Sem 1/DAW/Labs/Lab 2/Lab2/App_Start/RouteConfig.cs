using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Lab2
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //Exercitiul 1

            routes.MapRoute(
                name: "Concatenare",
                url: "concatenare/{param1}/{param2}",
                defaults: new { controller = "Example", action = "Concatenare", param1 = UrlParameter.Optional, param2 = UrlParameter.Optional }
           );

            routes.MapRoute(
                name: "Operatie",
                url: "operatie/{param1}/{param2}/{param3}",
                defaults: new { controller = "Example", action = "Operatie", param1 = UrlParameter.Optional, param2 = UrlParameter.Optional, param3 = UrlParameter.Optional }
           );

            //Exercitiul 2

            //Afisarea unei liste de studenti

            routes.MapRoute(
                name: "StudentIndex",
                url: "students/all",
                defaults: new { controller = "Student", action = "Index" }
            );

            //Adaugarea unui nou student

            routes.MapRoute(
                name: "StudentNew",
                url: "students/new",
                defaults: new { controller = "Student", action = "Create" }
            );

            //Afisarea unui singur student

            routes.MapRoute(
                name: "StudentShow",
                url: "students/{id}/show",
                defaults: new { controller = "Student", action = "Show", telef = UrlParameter.Optional}
            );

            //Editarea unui singur student

            routes.MapRoute(
                name: "StudentEdit",
                url: "students/{id}/edit",
                defaults: new { controller = "Student", action = "Edit", telef = UrlParameter.Optional }
            );

            //Stergerea unui singur student

            routes.MapRoute(
                name: "StudentDelete",
                url: "students/{id}/delete",
                defaults: new { controller = "Student", action = "Delete", telef = UrlParameter.Optional }
            );


            //Exercitiul 3

            routes.MapRoute(
                name: "SearchTelefon",
                url: "search/telefon/{telef}",
                defaults: new { controller = "Search", action = "NumarTelefon", telef = UrlParameter.Optional },
                constraints: new { telef = @"^[0][0-9]{9}$" }
            );

            //constrangerea nu trebuie sa fie atat de restrictiva incat sa nu permita accesarea metodei.

            routes.MapRoute(
                name: "CautareTelefon",
                url: "cautare/telefon/{telef}",
                defaults: new { controller = "Search", action = "NumarTelefon", telef = UrlParameter.Optional },
                constraints: new { telef = @"^[0-9]*$" }
            );

            //CNP

            routes.MapRoute(
                name: "CautareCNP",
                url: "search/cnp/{cnp}",
                defaults: new { controller = "Search", action = "Cenepe", telef = UrlParameter.Optional },
                constraints: new { cnp = @"^[0-9]{13}$" }
            );

            //Ruta DEFAULT

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", telef = UrlParameter.Optional }
            );

        }
    }
}
