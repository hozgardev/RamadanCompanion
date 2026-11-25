using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class QuranReadingLog
    {
        public int ReadingLogId { get; set; }
        public int PlanId { get; set; }
        public byte RamadanDay { get; set; }
        public short FromPage { get; set; }
        public short ToPage { get; set; }
        public short PagesCount { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
