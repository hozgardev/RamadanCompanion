using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class ReminderType
    {
        public byte ReminderTypeId { get; set; }
        public string Code { get; set; } = string.Empty;
        public string NameAr { get; set; } = string.Empty;
        public string? NameEn { get; set; }
        public bool DefaultEnabled { get; set; }
        public short? DefaultOffsetMinutes { get; set; }
        public TimeSpan? DefaultFixedTime { get; set; }
        public bool DefaultPlaySound { get; set; }
    }
}
