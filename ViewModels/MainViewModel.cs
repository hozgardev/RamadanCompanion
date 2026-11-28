using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using RamadanCompanion.Data;
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
        [ObservableProperty]
        private string _dbStatusMessage = "جاري فحص الاتصال بقاعدة البيانات...";

        public MainViewModel()
        {
            _currentViewModel = _homeViewModel;
            _ = LoadDbStatusAsync();
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
        public async Task LoadDbStatusAsync()
        {
            try
            {
                int count = await DbHelper.TestReminderTypesCountAsync();
                DbStatusMessage = $"تم الاتصال بنجاح (ReminderTypes: {count})";
            }
            catch (Exception ex)
            {
                DbStatusMessage = $"تعذر الاتصال بقاعدة البيانات: {ex.Message}";
            }
        }
    }
}

