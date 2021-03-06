﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using HiLand.Framework.BusinessCore.BLL;
using HiLand.Framework4.Permission.Attributes;
using HiLand.Utility.Enums;
using HiLand.Utility.Paging;
using Webdiyer.WebControls.Mvc;
using XQYC.Business.BLL;
using XQYC.Business.Entity;
using XQYC.Business.Enums;
using XQYC.Web.Models;

namespace XQYC.Web.Areas.EnterpriseConsole.Controllers
{
    [UserAuthorize(UserTypes.EnterpriseUser)]
    public class LaborController : Controller
    {
        //
        // GET: /EnterpriseConsole/Labor/

        public ActionResult Index(int id = 1)
        {
            int pageIndex = id;
            int pageSize = SystemConst.CountPerPage;
            int startIndex = (pageIndex - 1) * pageSize + 1;
            string whereClause = " 1=1 ";

            //--数据权限----------------------------------------------------------------------
            whereClause += string.Format(" AND [CurrentEnterpriseKey]= '{0}' AND LaborWorkStatus={1} ", BusinessUserBLL.CurrentUser.EnterpriseKey, (int)LaborWorkStatuses.Worked);
            //--end--------------------------------------------------------------------------


            string orderClause = "LaborID DESC";

            PagedEntityCollection<LaborEntity> entityList = LaborBLL.Instance.GetPagedCollection(startIndex, pageSize, whereClause, orderClause);
            PagedList<LaborEntity> pagedExList = new PagedList<LaborEntity>(entityList.Records, entityList.PageIndex, entityList.PageSize, entityList.TotalCount);

            return View(pagedExList);
        }

    }
}
