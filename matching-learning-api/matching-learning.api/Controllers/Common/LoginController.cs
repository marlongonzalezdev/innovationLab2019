using System;
using System.Collections.Generic;
using matching_learning.common.Domain.DTOs.Security;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// The controller for the regions.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private List<string> _users = new List<string>() { "admin", "delia", "marlon", "pablo", "william", "yanara" };

        /// <summary>
        /// Initializes a new instance of the <see cref="RegionsController"/> class.
        /// </summary>
        public LoginController()
        {
        }

        /// <summary>
        /// Checks user credentials.
        /// </summary>
        /// <param name="uc"></param>
        [HttpPost("Login")]
        [ProducesResponseType(typeof(AuthenticationResult), 200)]
        [Consumes("application/json")]
        [ProducesResponseType(500)]
        public IActionResult Login([FromBody] UserCredentials uc)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            AuthenticationResult res;

            if (!validateUser(uc))
            {
                res = new AuthenticationResult()
                {
                    Authenticated = false,
                    //Message = $"Invalid user {uc.UserName}."
                    Message = "Invalid user/password."
                };
            }
            else if (!validatePassword(uc))
            {
                res = new AuthenticationResult()
                {
                    Authenticated = false,
                    //Message = $"Invalid user/password for user {uc.UserName}."
                    Message = "Invalid user/password."
                };
            }
            else
            {
                res = new AuthenticationResult()
                {
                    Authenticated = true,
                    Message = $"User {uc.UserName} authenticated successfully."
                };
            }

            return Ok(res);
        }

        private bool validateUser(UserCredentials uc)
        {
            return (_users.Contains(uc.UserName.ToLower()));
        }

        private bool validatePassword(UserCredentials uc)
        {
            return (string.Compare(uc.UserName, uc.Password, StringComparison.InvariantCultureIgnoreCase) == 0);
        }
    }
}
