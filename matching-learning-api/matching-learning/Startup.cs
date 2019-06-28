using System.IO;
using System.Threading.Tasks;
using matching_learning.ml;
using matching_learning.Repositories;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;

namespace matching_learning
{
    /// <summary>
    /// The application bootstrapper.
    /// </summary>
    public class Startup
    {
        private readonly IWebHostEnvironment _env;

        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            _env = env;
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services
                .AddControllers()
                .AddNewtonsoftJson();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo
                {
                    Title = "Matching Learning API",
                    Version = "v1",
                    Description = "The API for Matching Learning @Endava Innovation Lab 2019."
                });

                c.IncludeXmlComments(Path.Combine(_env.ContentRootPath, "matching-learning.xml"));
            });

            services.AddHttpContextAccessor();
            services.AddScoped<IProjectAnalyzer, DefaultProjectAnalyzer>();
            var photosRepo = new FileSystemPhotoRepository(Path.Combine(_env.ContentRootPath, "Photos"));
            services.AddSingleton<IPhotoRepository>(photosRepo);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            app.Use((context, next) =>
            {
                // Redirect requests without a path to the default swagger UI page.
                if (context.Request.Path.Value == "/")
                {
                    context.Response.Redirect("/swagger");
                    return Task.CompletedTask;
                }

                return next();
            });

            app.UseSwagger();

            app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "Matching Learning API"));

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
