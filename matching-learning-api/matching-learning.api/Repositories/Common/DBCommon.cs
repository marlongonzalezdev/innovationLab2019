using System;
using Microsoft.Extensions.Configuration;

namespace matching_learning.api.Repositories.Common
{
    public static class DBCommon
    {
        public static string GetConnectionString()
        {
            string projectPath = AppDomain.CurrentDomain.BaseDirectory.Split(new String[] { @"bin\" }, StringSplitOptions.None)[0];
            IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(projectPath)
                .AddJsonFile("appsettings.json")
                .Build();
            string connectionString = configuration.GetConnectionString("IL2019");

            return (connectionString);
        }
    }
}
