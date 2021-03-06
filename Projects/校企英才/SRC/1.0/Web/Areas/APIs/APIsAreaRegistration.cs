﻿using System.Web.Mvc;

namespace XQYC.Web.Areas.APIs
{
    public class APIsAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "APIs";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "APIs_default",
                "APIS/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
