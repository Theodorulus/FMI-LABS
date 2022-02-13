using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace TudoracheAlexandruT42.Models
{
    public class AppContext : DbContext
    {
        public AppContext () : base("DBConnectionString")
        {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<AppContext, TudoracheAlexandruT42.Migrations.Configuration>("DBConnectionString"));
        }
        public DbSet <Student> Students { get; set; }
        public DbSet <Domain> Domains { get; set; }
    }
}