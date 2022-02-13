using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace FriendRequest.Models
{
    public class Friend
    {
        public int FriendId { get; set; }

        [ForeignKey("User1")]
        public string User1_Id { get; set; }
        public virtual ApplicationUser User1 { get; set; }

        [ForeignKey("User2")]
        public string User2_Id { get; set; }
        public virtual ApplicationUser User2 { get; set; }



        public DateTime RequestTime { get; set; }

        public bool Accepted { get; set; }
    }
}