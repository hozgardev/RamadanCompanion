using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class DailyDua
    {
        public int DuaId { get; set; }
        public int SeasonId { get; set; }
        public byte RamadanDay { get; set; }
        public string TextAr { get; set; } = string.Empty;
        public string? TextEn { get; set; }
    }
}
