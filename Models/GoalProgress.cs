using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class GoalProgress
    {
        public int ProgressId { get; set; }
        public int GoalId { get; set; }
        public byte RamadanDay { get; set; }
        public decimal Value { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
