﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace XQYC.Web.Models
{
    /// <summary>
    /// 在统计信息中使用的劳务人员实体信息
    /// </summary>
    public class LaborStaticstialEntity
    {
        public Guid LaborGuid { get; set; }
        public string  LaborName { get; set; }

        public Guid EnterpriseGuid { get; set; }
        public string EnterpriseName { get; set; }
        /// <summary>
        /// 薪资月份
        /// </summary>
        public DateTime SalaryDate { get; set; }
        public Guid  ETProvideGuid { get; set; }
        public string ETProvideName { get; set; }
        public Guid ETBusinessGuid { get; set; }
        public string ETBusinessName { get; set; }
        public Guid LBBusinessGuid { get; set; }
        public string LBBusinessName { get; set; }
        public Guid LBServiceGuid { get; set; }
        public string LBServiceName { get; set; }

        public decimal ManageFee { get; set; }
        public decimal GeneralRecruitFee { get; set; }
        public decimal OnceRecruitFee { get; set; }
    }
}