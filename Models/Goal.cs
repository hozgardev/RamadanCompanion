using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RamadanCompanion.Models
{
    internal class Goal
    {
        public int GoalId { get; set; }
        public int UserId { get; set; }
        public int SeasonId { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public byte GoalType { get; set; }
        public string Unit { get; set; } = string.Empty;
        public decimal TargetValue { get; set; }
        public bool IsArchived { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
