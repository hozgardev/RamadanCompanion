using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace RamadanCompanion.Data
{
   public static    class DbHelper
    {
        private static readonly IConfiguration _configuration;

        static DbHelper()
        {
            _configuration = new ConfigurationBuilder()
                .SetBasePath(AppContext.BaseDirectory)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .Build();
        }

        public static string GetConnectionString()
        {
            return _configuration.GetConnectionString("Default")
                   ?? throw new InvalidOperationException("Connection string 'Default' was not found.");
        }

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(GetConnectionString());
        }

        public static async Task<int> TestReminderTypesCountAsync()
        {
            const string sql = "SELECT COUNT(*) FROM ReminderTypes;";

            await using SqlConnection connection = GetConnection();
            await connection.OpenAsync();

            await using SqlCommand command = new(sql, connection);
            object? result = await command.ExecuteScalarAsync();

            return result is null || result == DBNull.Value ? 0 : Convert.ToInt32(result);
        }
    }
}
    

