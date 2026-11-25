using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class UserSetting
    {
        public int UserId { get; set; }
        public string Country { get; set; } = string.Empty;
        public string City { get; set; } = string.Empty;
        public byte CalculationMethod { get; set; }
        public short HijriAdjustment { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
