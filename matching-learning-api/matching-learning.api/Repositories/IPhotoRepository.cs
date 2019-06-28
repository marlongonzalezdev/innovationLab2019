namespace matching_learning.api.Repositories
{
    /// <summary>
    /// A repo contract for user photos.
    /// </summary>
    public interface IPhotoRepository
    {
        /// <summary>
        /// Resolves the photo.
        /// </summary>
        /// <param name="userId">The user identifier.</param>
        /// <returns></returns>
        string ResolvePhoto(string userId);
    }
}
