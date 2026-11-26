using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class DailyWorshipLog
    {
        public int WorshipLogId { get; set; }
        public int UserId { get; set; }
        public int SeasonId { get; set; }
        public byte RamadanDay { get; set; }
        public bool Fasted { get; set; }
        public byte? FastMissReasonId { get; set; }
        public bool CongFajr { get; set; }
        public bool CongDhuhr { get; set; }
        public bool CongAsr { get; set; }
        public bool CongMaghrib { get; set; }
        public bool CongIsha { get; set; }
        public byte TarawihRakats { get; set; }
        public byte QiyamRakats { get; set; }
        public byte NawafilRakats { get; set; }
        public bool MorningAdhkar { get; set; }
        public bool EveningAdhkar { get; set; }
        public bool Sadaqah { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
