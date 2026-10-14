using Microsoft.EntityFrameworkCore;
using Session4JudgeAPI.Contexts;
using Session4JudgeAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// ── Database ────────────────────────────────────────────────────────────────
builder.Services.AddDbContext<NortransTtContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// ── HTTP client for competitor API ─────────────────────────────────────────
var competitorBaseUrl = builder.Configuration["CompetitorApi:BaseUrl"] ?? "http://localhost:4000";
builder.Services.AddHttpClient("CompetitorApi", client =>
{
    client.BaseAddress = new Uri(competitorBaseUrl);
    client.Timeout = TimeSpan.FromSeconds(30);
});

// ── Application services ────────────────────────────────────────────────────
builder.Services.AddSingleton<TestResultService>();
builder.Services.AddScoped<TestService>();

// ── CORS ────────────────────────────────────────────────────────────────────
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// ── ASP.NET ─────────────────────────────────────────────────────────────────
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors();

app.UseAuthorization();
app.MapControllers();
app.Run();
