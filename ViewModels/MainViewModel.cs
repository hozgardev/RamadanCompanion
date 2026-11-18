using CommunityToolkit.Mvvm.ComponentModel;
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
        [ObservableProperty]
        private string welcomeMessage = "أهلاً بكِ في تطبيق رفيق رمضان - النسخة الأولى!";
    }
}
