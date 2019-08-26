using System;
using System.Collections.Generic;
using System.Linq;
using matching_learning.common.Domain.BusinessLogic;
using matching_learning.common.Domain.DTOs;
using matching_learning.common.Domain.Enums;
using Microsoft.AspNetCore.Mvc;

namespace matching_learning.api.Controllers.Common
{
    /// <summary>
    /// The controller for the delivery units.
    /// </summary>
    /// <seealso cref="ControllerBase" />
    [Route("[controller]")]
    [ApiController]
    public class EnumEntitiesController : ControllerBase
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="EnumEntitiesController"/> class.
        /// </summary>
        public EnumEntitiesController()
        {
        }

        /// <summary>
        /// Gets the candidate relation types.
        /// </summary>
        /// <returns></returns>
        [Route("CandidateRelationTypes")]
        public ActionResult<List<EnumEntity>> GetCandidateRelationTypes()
        {
            var res = from CandidateRelationType n in Enum.GetValues(typeof(CandidateRelationType))
                      select new EnumEntity()
                      {
                          Id = (int)n,
                          Name = EnumHelper.GetEnumDescription(n)
                      };

            return (res.ToList());
        }

        /// <summary>
        /// Gets the document types.
        /// </summary>
        /// <returns></returns>
        [Route("DocumentTypes")]
        public ActionResult<List<EnumEntity>> GetDocumentTypes()
        {
            var res = from DocumentType n in Enum.GetValues(typeof(DocumentType))
                      select new EnumEntity()
                      {
                          Id = (int)n,
                          Name = EnumHelper.GetEnumDescription(n)
                      };

            return (res.ToList());
        }

        /// <summary>
        /// Gets the skill categories.
        /// </summary>
        /// <returns></returns>
        [Route("SkillCategories")]
        public ActionResult<List<EnumEntity>> GetSkillCategories()
        {
            var res = from SkillCategory n in Enum.GetValues(typeof(SkillCategory))
                      select new EnumEntity()
                      {
                          Id = (int)n,
                          Name = EnumHelper.GetEnumDescription(n)
                      };

            return (res.ToList());
        }

        /// <summary>
        /// Gets the skill relation types.
        /// </summary>
        /// <returns></returns>
        [Route("SkillRelationTypes")]
        public ActionResult<List<EnumEntity>> GetSkillRelationTypes()
        {
            var res = from SkillRelationType n in Enum.GetValues(typeof(SkillRelationType))
                      select new EnumEntity()
                      {
                          Id = (int)n,
                          Name = EnumHelper.GetEnumDescription(n)
                      };

            return (res.ToList());
        }
    }
}
