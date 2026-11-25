using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Animation;

namespace RamadanCompanion.ViewModels
{
   public partial class MainViewModel: ObservableObject
    {
        // نستخدم ObservableObject لتفعيل نظام ربط البيانات تلقائياً
        private readonly HomeViewModel _homeViewModel = new();
        private readonly PrayerTimesViewModel _prayerTimesViewModel = new();
        private readonly QuranViewModel _quranViewModel = new();
        private readonly WorshipViewModel _worshipViewModel = new();
        private readonly GoalsViewModel _goalsViewModel = new();
        private readonly ReportsViewModel _reportsViewModel = new();
        private readonly SettingsViewModel _settingsViewModel = new();

        [ObservableProperty]
        private string _welcomeMessage = "أهلاً بك في تطبيق رفيق رمضان - النسخة الأولى!";

        [ObservableProperty]
        private object? _currentViewModel;

        public MainViewModel()
        {
            _currentViewModel = _homeViewModel;
        }

        [RelayCommand]
        private void Navigate(string? destination)
        {
            CurrentViewModel = destination switch
            {
                "Home" => _homeViewModel,
                "PrayerTimes" => _prayerTimesViewModel,
                "Quran" => _quranViewModel,
                "Worship" => _worshipViewModel,
                "Goals" => _goalsViewModel,
                "Reports" => _reportsViewModel,
                "Settings" => _settingsViewModel,
                _ => _homeViewModel
            };
        }
    }
}

