using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class RamadanSeason
    {
        public int SeasonId { get; set; }
        public short HijriYear { get; set; }
        public DateTime StartDate { get; set; }
        public byte DaysCount { get; set; }
    }
}
