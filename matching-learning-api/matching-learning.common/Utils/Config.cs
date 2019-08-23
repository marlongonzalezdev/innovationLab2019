using System;
using Microsoft.Extensions.Configuration;

namespace matching_learning.common.Utils
{
    public static class Config
    {
        private static IConfigurationRoot _configuration;
        private static IConfigurationSection _appSettings;

        static Config()
        {
            string projectPath = AppDomain.CurrentDomain.BaseDirectory.Split(new String[] { @"bin\" }, StringSplitOptions.None)[0];

#if LOCAL_DEFAULT_INSTANCE
            IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(projectPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile("appsettings.LocalDefaultInstance.json", optional: false)
                .Build();
#elif LOCAL_SQLEXPRESS_INSTANCE
  IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(projectPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile("appsettings.LocalSqlExpressInstance.json", optional: false)
                .Build();
#else
            IConfigurationRoot configuration = new ConfigurationBuilder()
                .SetBasePath(projectPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .Build();

#endif
            _configuration = configuration;
            _appSettings = _configuration.GetSection("AppSettings");
        }

        public static string GetConnectionString()
        {
            return (_configuration.GetConnectionString("IL2019"));
        }

        public static string GetPicturesRootFolder()
        {
            return (_appSettings["PicturesRootFolder"]);
        }

        public static string GetDefaultPicture()
        {
            return (_appSettings["DefaultPicture"]);
        }
    }
}
