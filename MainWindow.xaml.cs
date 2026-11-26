using RamadanCompanion.Data;
using RamadanCompanion.ViewModels;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace RamadanCompanion
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            Loaded += MainWindow_Loaded;
            // ربط الشاشة بالـ ViewModel لتفعيل الـ Data Binding
            this.DataContext = new MainViewModel();

        }
        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            var workArea = SystemParameters.WorkArea;

            if (Width > workArea.Width)
                Width = Math.Max(MinWidth, workArea.Width - 40);

            if (Height > workArea.Height)
                Height = Math.Max(MinHeight, workArea.Height - 40);

            Left = workArea.Left + Math.Max(0, (workArea.Width - Width) / 2);
            Top = workArea.Top + Math.Max(0, (workArea.Height - Height) / 2);
        }
        private async void Window_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                int count = await DbHelper.TestReminderTypesCountAsync();
                MessageBox.Show(
                    $"تم الاتصال بنجاح! عدد السجلات في ReminderTypes: {count}",
                    "اختبار ADO.NET",
                    MessageBoxButton.OK,
                    MessageBoxImage.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    $"حدث خطأ أثناء الاتصال: {ex.Message}",
                    "خطأ في الاتصال",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);
            }
        }
    }
}