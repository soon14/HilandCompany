﻿using System;
using System.Collections.Generic;
using HiLand.Framework.FoundationLayer;
using HiLand.Framework4.Permission;
using HiLand.General.BLL;
using HiLand.General.Entity;
using HiLand.Utility.Data;
using HiLand.Utility.Enums;
using XQYC.Business.BLL;
using XQYC.Business.Enums;

namespace XQYC.Business.Entity
{
    /// <summary>
    /// 劳务人员实体
    /// </summary>
    public class LaborEntity : BusinessUserEx<LaborEntity>, IResource
    {
        public new static LaborEntity Empty
        {
            get
            {
                LaborEntity entity = new LaborEntity();
                entity.isEmpty = true;
                return entity;
            }
        }

        /*
            字段UserGuid跟[CoreUser]表中的字段UserGuid是对应的
         */
        #region 属性信息

        private int laborID;
        public int LaborID
        {
            get { return laborID; }
            set { laborID = value; }
        }

        private string laborCode = String.Empty;
        /// <summary>
        /// 劳务人员的工号
        /// </summary>
        /// <remarks>
        /// 劳务人员前后可能被派往多家企业，每家企业都会给其编号，
        /// 这里记录的是最新一家企业给其的编号（这个信息是有LaborContract内的数据同步过来），
        /// 历史企业给其的编号在LaborContract表中。
        /// </remars>     
        public string LaborCode
        {
            get { return laborCode; }
            set { laborCode = value; }
        }

        private string nativePlace = String.Empty;
        /// <summary>
        /// 籍贯
        /// </summary>
        public string NativePlace
        {
            get { return nativePlace; }
            set { nativePlace = value; }
        }

        private string currentPlace = String.Empty;
        /// <summary>
        /// 现住地
        /// </summary>
        public string CurrentPlace
        {
            get { return currentPlace; }
            set { currentPlace = value; }
        }

        private string idCardPlace = String.Empty;
        /// <summary>
        /// 身份证地址
        /// </summary>
        public string IDCardPlace
        {
            get { return idCardPlace; }
            set { idCardPlace = value; }
        }

        private HouseHoldTypes houseHoldType = HouseHoldTypes.Other;
        /// <summary>
        /// 户口类型
        /// </summary>
        public HouseHoldTypes HouseHoldType
        {
            get { return houseHoldType; }
            set { houseHoldType = value; }
        }

        private string workSkill = String.Empty;
        /// <summary>
        /// 工作技能
        /// </summary>
        public string WorkSkill
        {
            get { return workSkill; }
            set { workSkill = value; }
        }

        private string workSkillPaper = String.Empty;
        /// <summary>
        /// 所持证件
        /// </summary>
        public string WorkSkillPaper
        {
            get { return workSkillPaper; }
            set { workSkillPaper = value; }
        }

        private string workSituation = String.Empty;
        /// <summary>
        /// 工作状况
        /// </summary>
        public string WorkSituation
        {
            get { return workSituation; }
            set { workSituation = value; }
        }

        private string preWorkSituation = String.Empty;
        /// <summary>
        /// 上份工作
        /// </summary>
        public string PreWorkSituation
        {
            get { return preWorkSituation; }
            set { preWorkSituation = value; }
        }

        private string hopeWorkSituation = String.Empty;
        /// <summary>
        /// 现希望从事工作
        /// </summary>
        public string HopeWorkSituation
        {
            get { return hopeWorkSituation; }
            set { hopeWorkSituation = value; }
        }

        private string hopeWorkSalary = String.Empty;
        /// <summary>
        /// 希望工资待遇
        /// </summary>
        public string HopeWorkSalary
        {
            get { return hopeWorkSalary; }
            set { hopeWorkSalary = value; }
        }

        private string urgentLinkMan = String.Empty;
        /// <summary>
        /// 紧急联系人
        /// </summary>
        public string UrgentLinkMan
        {
            get { return urgentLinkMan; }
            set { urgentLinkMan = value; }
        }

        private string urgentTelephone = String.Empty;
        /// <summary>
        /// 紧急联系人电话
        /// </summary>
        public string UrgentTelephone
        {
            get { return urgentTelephone; }
            set { urgentTelephone = value; }
        }

        private string urgentRelationship = String.Empty;
        /// <summary>
        /// 紧急联系人关系
        /// </summary>
        public string UrgentRelationship
        {
            get { return urgentRelationship; }
            set { urgentRelationship = value; }
        }

        private string informationComeFrom = String.Empty;
        /// <summary>
        /// 信息来源
        /// </summary>
        public string InformationComeFrom
        {
            get { return informationComeFrom; }
            set { informationComeFrom = value; }
        }

        private Guid providerUserGuid = Guid.Empty;
        /// <summary>
        /// 信息提供人员Guid
        /// </summary>
        public Guid ProviderUserGuid
        {
            get { return providerUserGuid; }
            set { providerUserGuid = value; }
        }

        private string providerUserName = String.Empty;
        /// <summary>
        /// 信息提供人员姓名
        /// </summary>
        public string ProviderUserName
        {
            get { return providerUserName; }
            set { providerUserName = value; }
        }

        private Guid recommendUserGuid = Guid.Empty;
        /// <summary>
        /// 推荐人员Guid
        /// </summary>
        public Guid RecommendUserGuid
        {
            get { return recommendUserGuid; }
            set { recommendUserGuid = value; }
        }

        private string recommendUserName = String.Empty;
        /// <summary>
        /// 推荐人员姓名
        /// </summary>
        public string RecommendUserName
        {
            get { return recommendUserName; }
            set { recommendUserName = value; }
        }

        private Guid serviceUserGuid = Guid.Empty;
        /// <summary>
        /// 客服人员Guid
        /// </summary>
        public Guid ServiceUserGuid
        {
            get { return serviceUserGuid; }
            set { serviceUserGuid = value; }
        }

        private string serviceUserName = String.Empty;
        /// <summary>
        /// 客服人员姓名
        /// </summary>
        public string ServiceUserName
        {
            get { return serviceUserName; }
            set { serviceUserName = value; }
        }

        private Guid financeUserGuid = Guid.Empty;
        /// <summary>
        /// 财务人员Guid
        /// </summary>
        public Guid FinanceUserGuid
        {
            get { return financeUserGuid; }
            set { financeUserGuid = value; }
        }

        private string financeUserName = String.Empty;
        /// <summary>
        /// 财务人员姓名
        /// </summary>
        public string FinanceUserName
        {
            get { return financeUserName; }
            set { financeUserName = value; }
        }

        private Guid businessUserGuid = Guid.Empty;
        /// <summary>
        /// 安置人员Guid
        /// </summary>
        public Guid BusinessUserGuid
        {
            get { return businessUserGuid; }
            set { businessUserGuid = value; }
        }

        private string businessUserName = String.Empty;
        /// <summary>
        /// 业务人员姓名
        /// </summary>
        public string BusinessUserName
        {
            get { return businessUserName; }
            set { businessUserName = value; }
        }

        private Guid settleUserGuid = Guid.Empty;
        /// <summary>
        /// 安置人员
        /// </summary>
        public Guid SettleUserGuid
        {
            get { return settleUserGuid; }
            set { settleUserGuid = value; }
        }

        private string settleUserName = String.Empty;
        /// <summary>
        /// 安置人员
        /// </summary>
        public string SettleUserName
        {
            get { return settleUserName; }
            set { settleUserName = value; }
        }

        private Guid informationBrokerUserGuid = Guid.Empty;
        public Guid InformationBrokerUserGuid
        {
            get { return informationBrokerUserGuid; }
            set { informationBrokerUserGuid = value; }
        }

        private string informationBrokerUserName = String.Empty;
        public string InformationBrokerUserName
        {
            get { return informationBrokerUserName; }
            set { informationBrokerUserName = value; }
        }


        private int insureType;
        public int InsureType
        {
            get { return insureType; }
            set { insureType = value; }
        }

        private LaborWorkStatuses laborWorkStatus = LaborWorkStatuses.NewWorker;
        public LaborWorkStatuses LaborWorkStatus
        {
            get { return laborWorkStatus; }
            set { laborWorkStatus = value; }
        }


        private string currentEnterpriseKey = String.Empty;
        public string CurrentEnterpriseKey
        {
            get { return currentEnterpriseKey; }
            set { currentEnterpriseKey = value; }
        }

        private string currentEnterpriseName = String.Empty;
        /// <summary>
        /// 当前务工企业的名称
        /// </summary>
        public string CurrentEnterpriseName
        {
            get { return currentEnterpriseName; }
            set { currentEnterpriseName = value; }
        }


        private string currentContractKey = String.Empty;
        public string CurrentContractKey
        {
            get { return currentContractKey; }
            set { currentContractKey = value; }
        }

        private string currentLaborDepartment = String.Empty;
        public string CurrentLaborDepartment
        {
            get { return currentLaborDepartment; }
            set { currentLaborDepartment = value; }
        }

        private string currentLaborWorkShop = String.Empty;
        public string CurrentLaborWorkShop
        {
            get { return currentLaborWorkShop; }
            set { currentLaborWorkShop = value; }
        }

        private DateTime currentContractStartDate = DateTimeHelper.Min;
        public DateTime CurrentContractStartDate
        {
            get { return currentContractStartDate; }
            set { currentContractStartDate = value; }
        }

        private DateTime currentContractStopDate = DateTimeHelper.Min;
        public DateTime CurrentContractStopDate
        {
            get { return currentContractStopDate; }
            set { currentContractStopDate = value; }
        }

        private string currentContractDesc = String.Empty;
        public string CurrentContractDesc
        {
            get { return currentContractDesc; }
            set { currentContractDesc = value; }
        }

        private DateTime currentContractDiscontinueDate = DateTimeHelper.Min;
        public DateTime CurrentContractDiscontinueDate
        {
            get { return currentContractDiscontinueDate; }
            set { currentContractDiscontinueDate = value; }
        }

        private string currentContractDiscontinueDesc = String.Empty;
        public string CurrentContractDiscontinueDesc
        {
            get { return currentContractDiscontinueDesc; }
            set { currentContractDiscontinueDesc = value; }
        }

        private string memo1 = String.Empty;
        /// <summary>
        /// 备注1
        /// </summary>
        public string Memo1
        {
            get { return memo1; }
            set { memo1 = value; }
        }

        private string memo2 = String.Empty;
        /// <summary>
        /// 备注2
        /// </summary>
        public string Memo2
        {
            get { return memo2; }
            set { memo2 = value; }
        }

        private string memo3 = String.Empty;
        /// <summary>
        /// 备注3
        /// </summary>
        public string Memo3
        {
            get { return memo3; }
            set { memo3 = value; }
        }

        private string memo4 = String.Empty;
        /// <summary>
        /// 备注4
        /// </summary>
        public string Memo4
        {
            get { return memo4; }
            set { memo4 = value; }
        }

        private string memo5 = String.Empty;
        /// <summary>
        /// 备注5
        /// </summary>
        public string Memo5
        {
            get { return memo5; }
            set { memo5 = value; }
        }

        private DispatchTypes currentDispatchType= DispatchTypes.UnSet;
        /// <summary>
        /// 劳务派遣类型
        /// </summary>
        public DispatchTypes CurrentDispatchType
        {
            get { return currentDispatchType; }
            set { currentDispatchType = value; }
        }

        private ComeFromTypes comeFromType= ComeFromTypes.ManageWrite;
        /// <summary>
        /// 劳务人员来源类型
        /// </summary>
        public ComeFromTypes ComeFromType
        {
            get { return comeFromType; }
            set { comeFromType = value; }
        }
        #endregion

        public Guid ResourceGuid
        {
            get { return this.UserGuid; }
        }

        public string ResourceName
        {
            get { return this.UserNameCN; }
        }

        private Logics isProtectedByOwner = Logics.True;
        /// <summary>
        /// 当前资源是否被保护（被保护的数据，仅能所有者修改，其他人仅能查看）
        /// </summary>
        public Logics IsProtectedByOwner
        {
            get { return this.isProtectedByOwner; }
            set { this.isProtectedByOwner = value; }
        }

        private List<string> ownerKeys = new List<string>();
        //Hack:xieran20121217 需要同步更新LaborController/Index内的查询条件
        /// <summary>
        /// 
        /// </summary>
        public List<string> OwnerKeys
        {
            get
            {
                if (ownerKeys.Count == 0)
                {
                    ownerKeys.Add(CreateUserKey);
                    ownerKeys.Add(LastUpdateUserKey);
                    ownerKeys.Add(ServiceUserGuid.ToString());
                    ownerKeys.Add(BusinessUserGuid.ToString());
                    ownerKeys.Add(SettleUserGuid.ToString());
                }

                return ownerKeys;
            }
        }

        /// <summary>
        /// 当前用户是否拥有资源的控制权（可以是编辑等权限）
        /// </summary>
        public bool IsOwning
        {
            get { return PermissionDataHelper.IsOwning(this); }
        }

        private string createUserKey = String.Empty;
        /// <summary>
        /// 资源创建人Key
        /// </summary>
        public string CreateUserKey
        {
            get { return createUserKey; }
            set { createUserKey = value; }
        }

        private string createUserName = String.Empty;
        /// <summary>
        /// 资源创建人名称
        /// </summary>
        public string CreateUserName
        {
            get { return createUserName; }
            set { createUserName = value; }
        }

        private DateTime createDate = DateTimeHelper.Min;
        /// <summary>
        /// 资源创建时间
        /// </summary>
        public DateTime CreateDate
        {
            get { return createDate; }
            set { createDate = value; }
        }

        private string lastUpdateUserKey = String.Empty;
        /// <summary>
        /// 资源最后更新人Key
        /// </summary>
        public string LastUpdateUserKey
        {
            get { return lastUpdateUserKey; }
            set { lastUpdateUserKey = value; }
        }

        private string lastUpdateUserName = String.Empty;
        /// <summary>
        /// 资源最后更新人名称
        /// </summary>
        public string LastUpdateUserName
        {
            get { return lastUpdateUserName; }
            set { lastUpdateUserName = value; }
        }

        private DateTime lastUpdateDate = DateTimeHelper.Min;
        /// <summary>
        /// 资源最后更新时间
        /// </summary>
        public DateTime LastUpdateDate
        {
            get { return lastUpdateDate; }
            set { lastUpdateDate = value; }
        }

        #region 延迟属性
        private LaborContractEntity currentLaborContract = LaborContractEntity.Empty;
        /// <summary>
        /// 劳务人员当前的劳务合同
        /// </summary>
        public LaborContractEntity CurrentLaborContract
        {
            get
            {
                if (currentLaborContract.IsEmpty == true)
                {
                    currentLaborContract = LaborContractBLL.Instance.GetCurrentContract(this.UserGuid);
                }

                return currentLaborContract;
            }
        }

        private BankEntity currentBank = BankEntity.Empty;
        /// <summary>
        /// 当前使用的银行卡信息
        /// </summary>
        public BankEntity CurrentBank
        {
            get
            {
                if (currentBank.IsEmpty == true)
                {
                    currentBank = BankBLL.Instance.GetPrimary(this.UserGuid);
                }

                return currentBank;
            }
        }

        /// <summary>
        /// 当前使用的银行卡账户名称
        /// </summary>
        public string CurrentBankAccountNumber
        {
            get
            {
                return this.CurrentBank.AccountNumber;
            }
        }
        #endregion
    }
}
