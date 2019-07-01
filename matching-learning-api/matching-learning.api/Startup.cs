using System.IO;
using System.Threading.Tasks;
using matching_learning.api.Repositories;
using matching_learning.ml;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Cors.Infrastructure;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Swashbuckle.AspNetCore.Swagger;

namespace matching_learning.api
{
    public class Startup
    {
        private readonly IHostingEnvironment _env;

        public Startup(IConfiguration configuration,
            IHostingEnvironment env)
        {
            Configuration = configuration;
            _env = env;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_2);

            services.AddCors(options =>
            {
                options.AddPolicy("AnotherPolicy",
                      builder =>
                      {
                          builder.AllowAnyOrigin()
                              .AllowAnyHeader()
                              .AllowAnyMethod();
                      });
            });

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new Info
                {
                    Title = "Matching Learning API",
                    Version = "v1",
                    Description = "The API for Matching Learning @Endava Innovation Lab 2019."
                });

                c.IncludeXmlComments(Path.Combine(_env.ContentRootPath, "matching-learning.api.xml"));
            });

            services.AddHttpContextAccessor();

            services.AddSingleton<IProjectAnalyzer, DefaultProjectAnalyzer>(sp =>
            {
                var logger = sp.GetRequiredService<ILogger<DefaultProjectAnalyzer>>();
                DefaultProjectAnalyzer analyzer = new DefaultProjectAnalyzer(logger);
                analyzer.TrainModelIfNotExists();

                return analyzer;
            });

            var photosRepo = new FileSystemPhotoRepository(Path.Combine(_env.ContentRootPath, "Photos"));
            services.AddSingleton<IPhotoRepository>(photosRepo);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
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

            app.UseCors("AnotherPolicy");

            app.UseHttpsRedirection();

            app.UseCors();

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

            app.UseMvc();
        }
    }
}
