using System.IO;

namespace matching_learning.Repositories
{
    /// <summary>
    /// 
    /// </summary>
    /// <seealso cref="matching_learning.Repositories.IPhotoRepository" />
    public class FileSystemPhotoRepository : IPhotoRepository
    {
        private readonly string _photosPath;
        private const string DefaultPhotoName = "_default.png";

        /// <summary>
        /// Initializes a new instance of the <see cref="FileSystemPhotoRepository"/> class.
        /// </summary>
        /// <param name="photosPath">The photos path.</param>
        public FileSystemPhotoRepository(string photosPath)
        {
            _photosPath = photosPath;
        }

        /// <inheritdoc />
        public string ResolvePhoto(string userId)
        {
            var photoFileName = Path.Combine(_photosPath, $"{userId}.jpg");
            if (!File.Exists(photoFileName))
                return Path.Combine(_photosPath, DefaultPhotoName);

            return photoFileName;
        }
    }
}