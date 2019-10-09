using matching_learning.api.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Old
{
    /// <summary>
    /// The controller for the user photos.
    /// </summary>
    /// <seealso cref="Microsoft.AspNetCore.Mvc.ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class PhotoController : ControllerBase
    {
        private readonly IPhotoRepository _photoRepo;

        /// <summary>
        /// Initializes a new instance of the <see cref="PhotoController"/> class.
        /// </summary>
        /// <param name="photoRepo">The photo repo.</param>
        public PhotoController(IPhotoRepository photoRepo)
        {
            _photoRepo = photoRepo;
        }

        /// <summary>
        /// Gets the photo with the specified identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns></returns>
        [HttpGet("{id}", Name = "GetUserPhoto")]
        public ActionResult<string> Get(string id)
        {
            var photoPath = _photoRepo.ResolvePhoto(id);
            return File(System.IO.File.ReadAllBytes(photoPath), "image/png");
        }
    }
}
