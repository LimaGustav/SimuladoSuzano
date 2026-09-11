using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPIBase.Controllers
{
    [Route("api")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        [HttpGet("admin/password")] 
        public IActionResult adminpass()
        {
            return Ok();
        }
    }
}
