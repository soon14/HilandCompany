﻿using System;
using System.Collections.Generic;
using HiLand.Framework.FoundationLayer;
using HiLand.General.BLL;
using HiLand.General.Entity;
using HiLand.Utility.Data;
using HiLand.Utility.Entity;
using HiLand.Utility.Mathes.StringParse;
using XQYC.Business.DAL;
using XQYC.Business.Entity;

namespace XQYC.Business.BLL
{
    public class SalarySummaryBLL : BaseBLL<SalarySummaryBLL, SalarySummaryEntity, SalarySummaryDAL>
    {
        #region 静态信息
        static SalarySummaryBLL()
        {
            BasicSettingBLL.Instance.BasicSettingChanged += Instance_BasicSettingChanged;
        }

        private static void Instance_BasicSettingChanged(object sender, DataForChange<BasicSettingEntity> args)
        {
            //如果某个费用项被修改了，那么则清空所有的费用项集合（费用项集合使用的时候，让其自动从新从数据库获取）
            if (args.NewData.SettingCategory == "CostItem")
            {
                costList = null;
            }
        }

        private static List<BasicSettingEntity> costList = null;
        /// <summary>
        /// 配置表中，费用项列表
        /// </summary>
        public static List<BasicSettingEntity> CostList
        {
            get
            {
                if (costList == null)
                {
                    costList = BasicSettingBLL.Instance.GetListByCategory("CostItem");
                }

                return costList;
            }
        }
        #endregion

        public override bool Create(SalarySummaryEntity model)
        {
            CalculateNeedCost(model);
            return base.Create(model);
        }

        public override bool Update(SalarySummaryEntity model)
        {
            CalculateNeedCost(model);
            return base.Update(model);
        }

        /// <summary>
        /// 获取某人某个月的薪资数据
        /// </summary>
        /// <param name="laborKey"></param>
        /// <param name="salaryMonth"></param>
        /// <returns></returns>
        public SalarySummaryEntity Get(string laborKey, DateTime salaryMonth)
        {
            string whereClause = string.Format(" LaborKey='{0}' ", laborKey);
            DateTime salaryDateFirstDay = DateTimeHelper.GetFirstDateOfMonth(salaryMonth);
            DateTime salaryDateLastDay = DateTimeHelper.GetFirstDateOfMonth(salaryMonth.AddMonths(1));
            whereClause += string.Format(" AND SalaryDate>='{0}' AND SalaryDate<'{1}' ", salaryDateFirstDay, salaryDateLastDay);
            List<SalarySummaryEntity> list = base.GetList(whereClause);

            if (list == null || list.Count == 0)
            {
                return SalarySummaryEntity.Empty;
            }
            else
            {
                return list[0];
            }
        }

        /// <summary>
        /// 获取某企业某个月的薪资数据
        /// </summary>
        /// <param name="enterpriseKey"></param>
        /// <param name="salaryMonth"></param>
        /// <returns></returns>
        public List<SalarySummaryEntity> GetList(string enterpriseKey, DateTime salaryMonth)
        {
            string whereClause = string.Format(" EnterpriseKey = '{0}' ", enterpriseKey);

            DateTime salaryDateFirstDay = DateTimeHelper.GetFirstDateOfMonth(salaryMonth);
            DateTime salaryDateLastDay = DateTimeHelper.GetFirstDateOfMonth(salaryMonth.AddMonths(1));
            whereClause += string.Format(" AND SalaryDate>='{0}' AND SalaryDate<'{1}' ", salaryDateFirstDay, salaryDateLastDay);
            return base.GetList(whereClause);
        }

        #region 私有方法
        /// <summary>
        /// 计算某劳务人员各种应付费用（保险，公积金，管理费等）
        /// </summary>
        /// <param name="labor"></param>
        /// <param name="salarySummary"></param>
        private static SalarySummaryEntity CalculateNeedCost(SalarySummaryEntity salarySummary)
        {
            LaborEntity labor = LaborBLL.Instance.Get(salarySummary.LaborKey);

            if (GuidHelper.IsInvalidOrEmpty(labor.CurrentInsuranceFormularKey) == false)
            {
                salarySummary.InsuranceCalculated = CalculateCostDetails(new Guid(labor.CurrentInsuranceFormularKey), salarySummary);
            }

            if (GuidHelper.IsInvalidOrEmpty(labor.CurrentReserveFundFormularKey) == false)
            {
                salarySummary.ReserveFundCalculated = CalculateCostDetails(new Guid(labor.CurrentReserveFundFormularKey), salarySummary);
            }

            if (GuidHelper.IsInvalidOrEmpty(labor.CurrentManageFeeFormularKey) == false)
            {
                salarySummary.ManageFeeCalculated = CalculateCostDetails(new Guid(labor.CurrentManageFeeFormularKey), salarySummary);
            }
            return salarySummary;
        }

        /// <summary>
        /// 计算具体的费用
        /// </summary>
        /// <param name="costFormularKey"></param>
        /// <param name="salarySummary"></param>
        /// <returns></returns>
        private static decimal CalculateCostDetails(Guid costFormularKey, SalarySummaryEntity salarySummary)
        {
            decimal result = 0M;
            CostFormularEntity formularEntity = CostFormularBLL.Instance.Get(costFormularKey);
            if (formularEntity == null)
            {
                return 0M;
            }

            string formularValue = formularEntity.CostFormularValue;
            if (string.IsNullOrWhiteSpace(formularValue) == false)
            {
                List<string> costElementList = StringHelper.GetPlaceHolderList(formularValue, "{", "}");
                foreach (string costElement in costElementList)
                {
                    string placeHolderContent = string.Empty;
                    switch (costElement)
                    {
                        case "NeedPaySalary":
                            placeHolderContent = salarySummary.SalaryNeedPay.ToString();
                            break;
                        case "RealPaySalary":
                            //TODO:xieran20121019暂时未考虑实付工资的情形
                            break;
                        default:
                            {
                                BasicSettingEntity basicSettingEntity = CostList.Find(w => w.SettingKey == costElement);
                                if (basicSettingEntity != null)
                                {
                                    placeHolderContent = basicSettingEntity.SettingValue;
                                }
                                break;
                            }
                    }

                    string placeHolder = "{" + costElement + "}";
                    formularValue = formularValue.Replace(placeHolder, placeHolderContent);
                }

                try
                {
                    RPN rpn = new RPN();
                    if (rpn.Parse(formularValue))
                    {
                        result = Convert.ToDecimal(rpn.Evaluate());
                    }
                }
                catch
                {
                    result = 0;
                }
            }

            return result;
        }
        #endregion
    }
}