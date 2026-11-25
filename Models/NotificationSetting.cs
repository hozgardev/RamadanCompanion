using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class NotificationSetting
    {
        public int NotificationSettingId { get; set; }
        public int UserId { get; set; }
        public byte ReminderTypeId { get; set; }
        public bool IsEnabled { get; set; }
        public short? OffsetMinutes { get; set; }
        public TimeSpan? FixedTime { get; set; }
        public bool PlaySound { get; set; }
    }
}
