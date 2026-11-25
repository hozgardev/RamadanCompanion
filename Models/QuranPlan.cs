using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class QuranPlan
    {
        public int PlanId { get; set; }
        public int UserId { get; set; }
        public int SeasonId { get; set; }
        public byte TargetKhatmas { get; set; }
        public byte CompletedKhatmas { get; set; }
        public short LastPage { get; set; }
        public byte StartDay { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
