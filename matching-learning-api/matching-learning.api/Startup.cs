﻿using System;
using System.IO;
using System.Reflection;
using System.Threading.Tasks;
using matching_learning.common.Repositories;
using matching_learning.api.Models;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Swashbuckle.AspNetCore.Swagger;
using matching_learning_algorithm;

namespace matching_learning.api
{
    /// <summary>
    /// Startup class.
    /// </summary>
    public class Startup
    {
        private readonly IHostingEnvironment _env;

        /// <summary>
        /// Web Api startup.
        /// </summary>
        /// <param name="configuration"></param>
        /// <param name="env"></param>
        public Startup(IConfiguration configuration,
                       IHostingEnvironment env)
        {
            Configuration = configuration;
            _env = env;
        }

        /// <summary>
        /// Configuration.
        /// </summary>
        public IConfiguration Configuration { get; }

        /// <summary>
        /// This method gets called by the runtime. Use this method to add services to the container.
        /// </summary>
        /// <param name="services"></param>
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
                //Locate the XML file being generated by ASP.NET...
                var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.XML";
                var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);

                //... and tell Swagger to use those XML comments.
                c.IncludeXmlComments(xmlPath);

                // c.IncludeXmlComments(Path.Combine(_env.ContentRootPath, "matching-learning.api.xml"));
            });

            services.AddHttpContextAccessor();

            services.AddSingleton<IProjectAnalyzer, ProjectAnalyzer>(sp =>
            {
                var logger = sp.GetRequiredService<ILogger<ProjectAnalyzer>>();
                var analyzer = new ProjectAnalyzer(logger, new SkillRepository());
                analyzer.TrainModelIfNotExists();

                return analyzer;
            });

            var photosRepo = new Repositories.FileSystemPhotoRepository(Path.Combine(_env.ContentRootPath, "Photos"));
            services.AddSingleton<Repositories.IPhotoRepository>(photosRepo);
            services.AddSingleton<Repositories.ISkillRepository, Repositories.SkillRepository>();

            services.AddSingleton<IRegionRepository, RegionRepository>();
            services.AddSingleton<IDeliveryUnitRepository, DeliveryUnitRepository>();
            services.AddSingleton<IProjectRepository, ProjectRepository>();
            services.AddSingleton<ICandidateRepository, CandidateRepository>();
            services.AddSingleton<ICandidateRoleRepository, CandidateRoleRepository>();
            services.AddSingleton<IEvaluationRepository, EvaluationRepository>();
            services.AddSingleton<IEvaluationTypeRepository, EvaluationTypeRepository>();
            services.AddSingleton<ISkillRepository, SkillRepository>();

            GenFu.GenFu.Configure<CandidateModel>()
                .Fill(c => c.Name)
                .Fill(c => c.LastName);
        }

        /// <summary>
        /// This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        /// </summary>
        /// <param name="app"></param>
        /// <param name="env"></param>
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

            app.UseMvc();

            app.UseSwagger();

            app.UseSwaggerUI(c =>
             {
                 c.SwaggerEndpoint("/swagger/v1/swagger.json", "Matching Learning API");
                 c.RoutePrefix = string.Empty;
             }
            );

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

        }
    }
}
