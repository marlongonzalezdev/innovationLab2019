using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

namespace matching_learning.api
{
    /// <summary>
    /// Main program.
    /// </summary>
    public class Program
    {
        /// <summary>
        /// main program.
        /// </summary>
        /// <param name="args"></param>
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        /// <summary>
        /// CreateWebHostBuilder.
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>();
    }
}
