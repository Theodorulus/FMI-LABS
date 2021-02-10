﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Laborator5App.Models
{
    public class Article
    {
        [Key]
        public int Id { get; set; }
        [Required(ErrorMessage = "Titlul articolului este obligatoriu")]
        [StringLength(100,ErrorMessage = "Titlul nu poate avea mai mult de 100 de caractere")]
        public string Title { get; set; }
        [Required(ErrorMessage = "Continutul articolului este obligatoriu")]
        [DataType(DataType.MultilineText)]
        public string Content { get; set; }

        public DateTime Date { get; set; }
        [Required(ErrorMessage = "Categoria este obligatorie")]
        public int CategoryId { get; set; }

        public virtual Category Category { get; set; }
        public virtual ICollection<Comment> Comments { get; set; }

        public IEnumerable<SelectListItem> Categ { get; set; }
    }
}