using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace TudoracheAlexandruT42.Models
{
    public class Student : IValidatableObject
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Numele studentului este obligatoriu!")]
        public string Nume { get; set; }

        [Required(ErrorMessage = "Email-ul studentului este obligatoriu!")]
        [StringLength(25, ErrorMessage = "Adresa de e-mail trebuie sa aiba cel mult 25 de caractere!")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Data de nastere este obligatorie!")]
        public DateTime DataNastere { get; set; }

        [ForeignKey("Domain")]
        [Required(ErrorMessage = "Domeniul este obligatoriu!")]
        public int DomainId { get; set; }

        public virtual Domain Domain { get; set;}

        public IEnumerable<SelectListItem> Dom { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
            int age = DateTime.Now.Year - DataNastere.Year; // se verifica automat daca data este din viitor, rezultatul fiind cu -, iar orice numar negativ e mai mic decat 18
            System.Diagnostics.Debug.WriteLine(age.ToString());
            if (age < 18)
            {
                yield return new ValidationResult(
                    errorMessage: "Studentul trebuie sa aiba peste 18 ani!",
                    memberNames: new[] { "DataEnd" }
               );
            }
        }
    }
}