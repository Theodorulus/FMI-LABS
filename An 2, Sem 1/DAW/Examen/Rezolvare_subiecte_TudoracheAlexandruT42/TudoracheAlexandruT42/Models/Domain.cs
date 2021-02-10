using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace TudoracheAlexandruT42.Models
{
    public class Domain
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Denumirea domeniului este obligatorie!")]
        public string Denumire { get; set; }

        public virtual ICollection<Student> Students { get; set; }
    }
}