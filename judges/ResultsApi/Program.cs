using ResultsApi;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddCors(options => options.AddPolicy("web", policy => policy
    .AllowAnyOrigin()
    .AllowAnyHeader()
    .AllowAnyMethod()));
builder.Services.AddSingleton<ITestResultStore, InMemoryTestResultStore>();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseCors("web");
app.MapControllers();
app.UseSwagger();
app.UseSwaggerUI();

app.Run();
