﻿using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Html;
using HiLand.Framework.BusinessCore;
using HiLand.Framework.BusinessCore.BLL;
using HiLand.Framework4.Permission;
using HiLand.General.BLL;
using HiLand.General.Entity;
using HiLand.Utility.Data;
using HiLand.Utility.Entity;
using HiLand.Utility.Enums;
using HiLand.Utility.Web;
using HiLand.Utility4.MVC;
using HiLand.Utility4.MVC.Controls;
using XQYC.Business.BLL;
using XQYC.Business.Entity;
using XQYC.Business.Enums;

namespace XQYC.Web.Control
{
    public static class HtmlHelperEx
    {
        #region 计算机逻辑控件
        /// <summary>
        /// 日期输入控件
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public static IHtmlString DateInput(System.Web.Mvc.HtmlHelper html, string name, string value, string datetimeFormat = "yyyy/mm/dd", bool isUseSelfContainer = true)
        {
            List<string> cssFiles = new List<string>() { UrlHelperEx.UrlHelper.Content("~/Content/jQuery.tools.dateinput.css") };
            List<string> javaScriptFiles = new List<string>() { /*UrlHelperEx.UrlHelper.Content("~/Scripts/jQuery.tools.min.js")*/ };
            if (string.IsNullOrWhiteSpace(datetimeFormat))
            {
                datetimeFormat = "yyyy/mm/dd";
            }
            string dateTimeOptions = string.Format("format:'{0}',selectors:true,yearRange:[-70,10]", datetimeFormat);
            dateTimeOptions = "{" + dateTimeOptions + "}";
            if (DateTimeHelper.Parse(value, DateFormats.YMD) == DateTimeHelper.Min)
            {
                value = string.Empty;
            }
            return html.HiDateTime(name).Value(value).StyleSheetFiles(cssFiles).IsUseSelfContainer(isUseSelfContainer).JavaScriptFiles(javaScriptFiles).DateInputOptions(dateTimeOptions).Render();
        }

        /// <summary>
        /// 导出Excel的按钮
        /// </summary>
        /// <returns></returns>
        public static IHtmlString ExportExcel(System.Web.Mvc.HtmlHelper html)
        {
            string currentUrlWithExportExcelFunction = RequestHelper.AddOrModifyQueryString(RequestHelper.CurrentRequest, "exportExcel", "true");
            string result = string.Format("<a href=\"{0}\" class=\"btn btn-warning\"><i class=\"icon-download-alt icon-white\"></i>导出</a>", currentUrlWithExportExcelFunction);
            return new MvcHtmlString(result);
        }
        #endregion

        #region 部门人员控件
        /// <summary>
        /// 部门下拉列表(单级的组织机构，目前使用多级的组织机构树)
        /// </summary>
        /// <param name="html"></param>
        /// <param name="controlName"></param>
        /// <param name="selectedDepartmentGuid"></param>
        /// <param name="isDisplayChoosenItem"></param>
        public static void XQYCDDLDepartment(System.Web.Mvc.HtmlHelper html, string controlName, string selectedDepartmentGuid = GuidHelper.EmptyString, bool isDisplayChoosenItem = false)
        {
            List<SelectListItem> itemList = XQYCItemsDepartment(selectedDepartmentGuid);

            if (isDisplayChoosenItem == true)
            {
                html.DropDownList(controlName, itemList);
            }
            else
            {
                html.DropDownList(controlName, itemList, "请选择...");
            }
        }

        /// <summary>
        /// 获取部门项集合的数据集
        /// </summary>
        /// <param name="selectedDepartmentGuid"></param>
        /// <returns></returns>
        public static List<SelectListItem> XQYCItemsDepartment(string selectedDepartmentGuid = GuidHelper.EmptyString)
        {
            List<SelectListItem> itemList = new List<SelectListItem>();
            List<BusinessDepartment> departmentList = BusinessDepartmentBLL.Instance.GetOrdedList(Logics.True, string.Empty);
            if (departmentList != null)
            {
                foreach (BusinessDepartment department in departmentList)
                {
                    SelectListItem item = new SelectListItem();
                    item.Text = StringHelper.Repeate(">", department.DepartmentLevel) + department.DepartmentNameShort;
                    item.Value = department.DepartmentGuid.ToString();
                    if (department.DepartmentGuid.ToString() == selectedDepartmentGuid)
                    {
                        item.Selected = true;
                    }

                    itemList.Add(item);
                }
            }

            return itemList;
        }

        /// <summary>
        /// 部门下的人员选择器(建议使用XQYCResourceChooser)
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="value"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        public static IHtmlString XQYCEmployeeChooser(System.Web.Mvc.HtmlHelper html, string name, string text, string value, UserStatuses userStatus = UserStatuses.Normal)
        {
            List<string> scriptList = new List<string>();
            scriptList.Add(UrlHelperEx.UrlHelper.Content("~/Scripts/jquery-1.4.4.min.js"));
            scriptList.Add(UrlHelperEx.UrlHelper.Content("~/Content/ztree/js/jquery.ztree.all-3.3.min.js"));

            List<string> cssList = new List<string>();
            cssList.Add(UrlHelperEx.UrlHelper.Content("~/Content/ztree/css/zTreeStyle/zTreeStyle.css"));
            string employeeJson = GetDepartmentEmployeeNodesJson(XQYCTreeNodeSelectModes.Employee, userStatus);
            bool allowSelect = true;
            if (BusinessUserBLL.CurrentUser.UserType == UserTypes.SuperAdmin
                || value == string.Empty
                || value == GuidHelper.EmptyString
                || BusinessUserBLL.CurrentUserGuid.ToString().ToLower() == value.ToLower()
                //TODO:xieran20130311 考虑加入 数据权限的控制（部门领导可以管理部门内人员的数据） 
                //|| PermissionDataHelper.IsOwning() 
                )
            {
                allowSelect = true;
            }
            else
            {
                allowSelect = false;
            }

            return html.HiTreeSelect(name).JavaScriptFiles(scriptList).IsAllowSelect(allowSelect).StyleSheetFiles(cssList).Text(text).Value(value).IsInPopupWindow(true).DataSelectType(DataSelectTypes.Radio).StaticDataNodes(employeeJson).Render();
        }

        /// <summary>
        /// 部门选择器(建议使用XQYCResourceChooser)
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="value"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        public static IHtmlString XQYCDepartmentChooser(System.Web.Mvc.HtmlHelper html, string name, string text, string value)
        {
            List<string> scriptList = new List<string>();
            scriptList.Add(UrlHelperEx.UrlHelper.Content("~/Scripts/jquery-1.4.4.min.js"));
            scriptList.Add(UrlHelperEx.UrlHelper.Content("~/Content/ztree/js/jquery.ztree.all-3.3.min.js"));

            List<string> cssList = new List<string>();
            cssList.Add(UrlHelperEx.UrlHelper.Content("~/Content/ztree/css/zTreeStyle/zTreeStyle.css"));
            string employeeJson = GetDepartmentEmployeeNodesJson(XQYCTreeNodeSelectModes.Department);
            bool allowSelect = true;

            return html.HiTreeSelect(name).JavaScriptFiles(scriptList).IsAllowSelect(allowSelect).StyleSheetFiles(cssList).Text(text).Value(value).IsInPopupWindow(true).DataSelectType(DataSelectTypes.Radio).StaticDataNodes(employeeJson).Render();
        }

        /// <summary>
        /// 部门人员综合选择器
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="value"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        public static IHtmlString XQYCResourceChooser(System.Web.Mvc.HtmlHelper html, XQYCTreeNodeSelectModes selectMode, string name, string text, string value, UserStatuses userStatus = UserStatuses.Normal)
        {
            List<string> scriptList = new List<string>();
            scriptList.Add(UrlHelperEx.UrlHelper.Content("~/Scripts/jquery-1.4.4.min.js"));
            scriptList.Add(UrlHelperEx.UrlHelper.Content("~/Content/ztree/js/jquery.ztree.all-3.3.min.js"));

            List<string> cssList = new List<string>();
            cssList.Add(UrlHelperEx.UrlHelper.Content("~/Content/ztree/css/zTreeStyle/zTreeStyle.css"));
            string employeeJson = GetDepartmentEmployeeNodesJson(selectMode, userStatus);
            bool allowSelect = true;

            return html.HiTreeSelect(name).JavaScriptFiles(scriptList).IsAllowSelect(allowSelect).StyleSheetFiles(cssList).Text(text).Value(value).IsInPopupWindow(true).DataSelectType(DataSelectTypes.Radio).StaticDataNodes(employeeJson).Render();
        }

        /// <summary>
        /// 获取部门人员节点的json数据
        /// </summary>
        /// <returns></returns>
        private static string GetDepartmentEmployeeNodesJson(XQYCTreeNodeSelectModes selectMode = XQYCTreeNodeSelectModes.Employee, UserStatuses userStatus = UserStatuses.UnSet)
        {
            string result = string.Empty;

            List<ZTreeNodeEntity> nodeList = new List<ZTreeNodeEntity>();

            List<BusinessDepartment> departmentList = BusinessDepartmentBLL.Instance.GetList(Logics.True, "", 0, "");
            foreach (BusinessDepartment item in departmentList)
            {
                ZTreeNodeEntity node = new ZTreeNodeEntity();
                node.id = item.DepartmentGuid.ToString();
                node.pId = item.DepartmentParentGuid.ToString();
                node.name = item.DepartmentNameShort;
                node.open = false;
                node.addonData = "D";

                if (FlagHelper.ContainsFlag(selectMode, XQYCTreeNodeSelectModes.Department))
                {
                    node.nocheck = false;
                }
                else
                {
                    node.nocheck = true;
                }

                nodeList.Add(node);
            }

            if (FlagHelper.ContainsFlag(selectMode, XQYCTreeNodeSelectModes.Employee))
            {
                string sqlClause = "SELECT EMP.*,CU.* FROM XQYCEmployee EMP LEFT JOIN CoreUser CU ON EMP.UserGuid= CU.UserGuid WHERE 1=1 ";
                if (userStatus != UserStatuses.UnSet)
                {
                    sqlClause += string.Format(" AND CU.UserStatus={0} ", (int)userStatus);
                }

                List<EmployeeEntity> employeeList = EmployeeBLL.Instance.GetListBySQL(sqlClause);
                foreach (EmployeeEntity item in employeeList)
                {
                    ZTreeNodeEntity node = new ZTreeNodeEntity();
                    node.id = item.UserGuid.ToString();
                    node.pId = item.DepartmentGuid.ToString();
                    node.name = item.UserNameCN;
                    node.open = false;
                    node.nocheck = false;
                    node.addonData = "E";

                    nodeList.Add(node);
                }
            }

            result = JsonHelper.Serialize(nodeList);

            return result;
        }

        #endregion

        #region 企业、企业合同控件
        /// <summary>
        /// 企业选择下拉列表
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="selectedValue"></param>
        /// <param name="enterpriseServiceType">企业选用服务的类型，具体在表GeneralBasicSetting中定义的SettingKey</param>
        /// <returns></returns>
        public static IHtmlString XQYCDDLEnterprise(System.Web.Mvc.HtmlHelper html, string name, string selectedValue, string enterpriseServiceType = "0")
        {
            int enterpriserServiceTypeValue = 0;
            enterpriserServiceTypeValue = Converter.ChangeType(enterpriseServiceType, -999);
            if (enterpriserServiceTypeValue == -999)
            {
                List<BasicSettingEntity> allServiceList = BasicSettingBLL.Instance.GetListByCategory("EnterpriseServiceType");
                for (int i = 0; i < allServiceList.Count; i++)
                {
                    BasicSettingEntity currentServiceItem = allServiceList[i];
                    if (currentServiceItem.SettingKey.ToLower() == enterpriseServiceType.ToLower())
                    {
                        enterpriserServiceTypeValue = Converter.ChangeType(currentServiceItem.SettingValue, -999);
                        break;
                    }
                }
            }

            List<SelectListItem> itemList = new List<SelectListItem>();
            List<EnterpriseEntity> allEnterpriseList = EnterpriseBLL.Instance.GetList(string.Format("CanUsable={0}", (int)Logics.True));
            List<EnterpriseEntity> selectedEnterpriseList = new List<EnterpriseEntity>();

            if (enterpriserServiceTypeValue == 0)
            {
                selectedEnterpriseList = allEnterpriseList;
            }

            if (enterpriserServiceTypeValue > 0)
            {
                List<EnterpriseServiceEntity> serviceList = EnterpriseServiceBLL.Instance.GetList(string.Format("EnterpriseServiceType={0} AND EnterpriseServiceStatus={1}", enterpriserServiceTypeValue, (int)Logics.True));
                for (int i = 0; i < serviceList.Count; i++)
                {
                    EnterpriseServiceEntity currentService = serviceList[i];
                    for (int j = 0; j < allEnterpriseList.Count; j++)
                    {
                        EnterpriseEntity currentEnterprise = allEnterpriseList[j];
                        if (currentEnterprise.EnterpriseGuid == currentService.EnterpriseGuid)
                        {
                            selectedEnterpriseList.Add(currentEnterprise);
                            break;
                        }
                    }
                }
            }

            for (int i = 0; i < selectedEnterpriseList.Count; i++)
            {
                EnterpriseEntity currentEnterprise = selectedEnterpriseList[i];

                SelectListItem listItem = new SelectListItem();
                listItem.Text = currentEnterprise.CompanyName;
                listItem.Value = currentEnterprise.EnterpriseGuid.ToString();
                if (currentEnterprise.EnterpriseGuid.ToString() == selectedValue)
                {
                    listItem.Selected = true;
                }

                itemList.Add(listItem);
            }

            return html.DropDownList(name, itemList, "请选择...");
        }

        public static IHtmlString XQYCCSDDLEnterpriseContract(System.Web.Mvc.HtmlHelper html, string name, string selectedValue, string enterpriseControlID)
        {
            string dynamicItemsLoadUrl = UrlHelperEx.UrlHelper.Action("EnterpriseContractItemList", "FreePermission", new { enterpriseControlID = enterpriseControlID });
            return html.HiCascadingDropDownList(name).ParentSelectControlSelector("#" + enterpriseControlID).DynamicSelectItemsLoadUrl(dynamicItemsLoadUrl).Value(selectedValue).Render();
        }

        public static IHtmlString XQYCAutoCompleteEnterprise(System.Web.Mvc.HtmlHelper html, string name, string value = StringHelper.Empty, string realValue = StringHelper.Empty)
        {
            string autoCompleteUrl = UrlHelperEx.UrlHelper.Action("AutoCompleteData", "Enterprise");
            return html.HiTextBox(name).DynamicLoadDataUrl(autoCompleteUrl).Value(value).HiddenFieldValue(realValue).Render();
        }
        #endregion

        #region 信息员控件
        /// <summary>
        /// 信息员自动完成控件
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="value"></param>
        /// <param name="realValue"></param>
        /// <returns></returns>
        public static IHtmlString XQYCAutoCompleteInformationBroker(System.Web.Mvc.HtmlHelper html, string name, string value = StringHelper.Empty, string realValue = StringHelper.Empty, string callbackFunctionName = "autoCompleteSelectedCallback")
        {
            string autoCompleteUrl = UrlHelperEx.UrlHelper.Action("AutoCompleteData", "InformationBroker");
            return html.HiTextBox(name).DynamicLoadDataUrl(autoCompleteUrl).Value(value).HiddenFieldValue(realValue).SelectedCallbackFunctionName(callbackFunctionName).Render();
        }

        /// <summary>
        /// 信息员下拉列表控件
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public static IHtmlString XQYCDDLInformationBroker(System.Web.Mvc.HtmlHelper html, string name, string value)
        {
            List<SelectListItem> itemList = new List<SelectListItem>();
            List<InformationBrokerEntity> brokerList = InformationBrokerBLL.Instance.GetList(string.Format("CanUsable={0}", (int)Logics.True));
            foreach (InformationBrokerEntity currentItem in brokerList)
            {
                SelectListItem listItem = new SelectListItem();

                listItem.Text = currentItem.InformationBrokerName;
                listItem.Value = currentItem.InformationBrokerGuid.ToString();
                if (currentItem.InformationBrokerGuid.ToString() == value)
                {
                    listItem.Selected = true;
                }

                itemList.Add(listItem);
            }

            string hiddenName = string.Format("{0}_Text", name);
            StringBuilder sb = new StringBuilder();
            sb.Append(html.DropDownList(name, itemList, "请选择...").ToHtmlString());
            sb.AppendFormat("<input id=\"{0}\" name=\"{0}\" type=\"hidden\" />", hiddenName);
            sb.AppendFormat(@"<script type='text/javascript'>
                $(document).ready(function () |<|
                    $('#{0}').change(function () |<|
                        var valueSelected = $(this).children('option:selected').val();
                        var textSelected = '';
                        if (valueSelected != '') |<|
                            textSelected = $(this).children('option:selected').text();
                        |>|
                        $('#{1}').val(textSelected);
                    |>|);
                |>|);
                </script>
            ", name, hiddenName);

            MvcHtmlString result = new MvcHtmlString(sb.Replace("|<|", "{").Replace("|>|", "}").ToString());
            return result;
        }
        #endregion

        #region 各种费用公式列表控件
        ///// <summary>
        ///// 保险下拉列表
        ///// </summary>
        ///// <param name="html"></param>
        ///// <param name="name"></param>
        ///// <param name="value"></param>
        ///// <returns></returns>
        //public static IHtmlString XQYCDDLInsurance(System.Web.Mvc.HtmlHelper html, string name, string value)
        //{
        //    return XQYCDDLCostFormular(html, CostKinds.Insurance, name, value);
        //}

        ///// <summary>
        ///// 管理费下拉列表
        ///// </summary>
        ///// <param name="html"></param>
        ///// <param name="name"></param>
        ///// <param name="value"></param>
        ///// <returns></returns>
        //public static IHtmlString XQYCDDLManageFee(System.Web.Mvc.HtmlHelper html, string name, string value)
        //{
        //    return XQYCDDLCostFormular(html, CostKinds.ManageFee, name, value);
        //}

        ///// <summary>
        ///// 公积金下拉列表
        ///// </summary>
        ///// <param name="html"></param>
        ///// <param name="name"></param>
        ///// <param name="value"></param>
        ///// <returns></returns>
        //public static IHtmlString XQYCDDLReserveFund(System.Web.Mvc.HtmlHelper html, string name, string value)
        //{
        //    return XQYCDDLCostFormular(html, CostKinds.ReserveFund, name, value);
        //}


        /// <summary>
        /// 通用的费用公式列表
        /// </summary>
        /// <param name="html"></param>
        /// <param name="costKind"></param>
        /// <param name="name"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public static IHtmlString XQYCDDLCostFormular(System.Web.Mvc.HtmlHelper html, CostKinds costKind, CostTypes costType, string name, string value)
        {
            List<SelectListItem> itemList = new List<SelectListItem>();
            List<CostFormularEntity> entityList = CostFormularBLL.Instance.GetList(costKind, costType, Logics.True, string.Empty);
            foreach (CostFormularEntity currentItem in entityList)
            {
                SelectListItem listItem = new SelectListItem();
                listItem.Text = currentItem.CostFormularName;
                listItem.Value = currentItem.CostFormularGuid.ToString();
                if (currentItem.CostFormularGuid.ToString() == value)
                {
                    listItem.Selected = true;
                }

                itemList.Add(listItem);
            }

            string hiddenName = string.Format("{0}_Text", name);
            StringBuilder sb = new StringBuilder();
            sb.Append(html.DropDownList(name, itemList, "请选择...").ToHtmlString());
            sb.AppendFormat("<input id=\"{0}\" name=\"{0}\" type=\"hidden\" />", hiddenName);
            sb.AppendFormat(@"<script type='text/javascript'>
                $(document).ready(function () |<|
                    $('#{0}').change(function () |<|
                        var valueSelected = $(this).children('option:selected').val();
                        var textSelected = '';
                        if (valueSelected != '') |<|
                            textSelected = $(this).children('option:selected').text();
                        |>|
                        $('#{1}').val(textSelected);
                    |>|);
                |>|);
                </script>
            ", name, hiddenName);

            MvcHtmlString result = new MvcHtmlString(sb.Replace("|<|", "{").Replace("|>|", "}").ToString());
            return result;
        }
        #endregion

        #region 各种常用业务控件
        /// <summary>
        /// 企业行业类型选择下拉列表
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="selectedValue"></param>
        /// <returns></returns>
        public static IHtmlString XQYCDDLEnterpriseType(System.Web.Mvc.HtmlHelper html, string name, string selectedValue = StringHelper.Empty)
        {
            List<SelectListItem> itemList = new List<SelectListItem>();
            List<BasicSettingEntity> industryTypeList = BasicSettingBLL.Instance.GetListOfIndustryType();
            for (int i = 0; i < industryTypeList.Count; i++)
            {
                BasicSettingEntity industryTypeItem = industryTypeList[i];
                SelectListItem listItem = new SelectListItem();
                listItem.Text = industryTypeItem.DisplayName;
                listItem.Value = industryTypeItem.SettingKey;
                if (industryTypeItem.SettingKey == selectedValue)
                {
                    listItem.Selected = true;
                }

                itemList.Add(listItem);
            }

            return html.DropDownList(name, itemList);
        }

        /// <summary>
        /// 获取目前使用的地区列表
        /// </summary>
        /// <returns></returns>
        public static List<AreaEntity> XQYCItemsArea()
        {
            List<AreaEntity> entityList = AreaBLL.Instance.GetListByParentCode("3702");

            //添加一个“其他”地区
            if (entityList.Exists(m => m.AreaCode == "QT") == false)
            {
                AreaEntity areaEntity = new AreaEntity();
                areaEntity.AreaCode = "QT";
                areaEntity.AreaName = "其他";
                entityList.Add(areaEntity);
            }

            return entityList;
        }

        /// <summary>
        /// 地区选择下拉列表
        /// </summary>
        /// <param name="html"></param>
        /// <param name="name"></param>
        /// <param name="selectedValue"></param>
        /// <returns></returns>
        /// <remarks>目前仅提供青岛各辖区信息</remarks>
        public static IHtmlString XQYCDDLArea(System.Web.Mvc.HtmlHelper html, string name, string selectedValue = StringHelper.Empty)
        {
            List<SelectListItem> itemList = new List<SelectListItem>();
            List<AreaEntity> entityList = XQYCItemsArea();

            for (int i = 0; i < entityList.Count; i++)
            {
                AreaEntity industryTypeItem = entityList[i];
                SelectListItem listItem = new SelectListItem();
                listItem.Text = industryTypeItem.AreaName;
                listItem.Value = industryTypeItem.AreaCode;
                if (industryTypeItem.AreaCode == selectedValue)
                {
                    listItem.Selected = true;
                }

                itemList.Add(listItem);
            }

            return html.DropDownList(name, itemList);
        }
        #endregion
    }
}