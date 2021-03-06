USE [xiaoqiyingcaidatabasemanage]
GO
SET IDENTITY_INSERT [dbo].[CoreRole] ON 

INSERT [dbo].[CoreRole] ([RoleID], [RoleGuid], [RoleName], [RoleDescrition], [CanUsable], [IsInnerRole], [PropertyNames], [PropertyValues]) VALUES (1, N'c884df15-8f7d-480e-8129-2d9b2f112a2d', N'EmployeeBirthdayRemindReceiver', N'提醒信息收取人', 1, 1, N'', N'')
SET IDENTITY_INSERT [dbo].[CoreRole] OFF
SET IDENTITY_INSERT [dbo].[CoreUser] ON 

INSERT [dbo].[CoreUser] ([UserID], [UserGuid], [UserName], [UserCode], [Password], [PasswordEncrytType], [PasswordEncrytSalt], [UserNameCN], [UserNameEN], [UserNameFirst], [UserNameLast], [UserNameMiddle], [DepartmentID], [DepartmentGuid], [DepartmentCode], [DepartmentUserType], [AreaCode], [UserEmail], [UserType], [UserStatus], [UserRemark], [UserCardID], [UserCardIDIssued], [DriversLicenceNumber], [DriversLicenceNumberIssued], [PassportCode], [PassportCodeIssued], [UserSex], [UserBirthDay], [MaritalStatus], [UserMobileNO], [UserRegisterDate], [UserAgreeDate], [UserWorkStartDate], [UserWorkEndDate], [CompanyMail], [UserTitle], [UserPosition], [WorkTelphone], [HomeTelephone], [UserPhoto], [UserMacAddress], [UserLastIP], [UserLastDateTime], [BrokerKey], [EnterpriseKey], [UserHeight], [UserWeight], [UserNation], [UserCountry], [UserEducationalBackground], [PropertyNames], [PropertyValues]) VALUES (1, N'0fac1828-5859-465d-b373-75d2e9a7a17c', N'admin', N'', N'123', 0, N'', N'', N'', N'yy', N'yy', N'yy', 0, N'6e1cbf82-80d4-48bc-b6b9-6fc640d51ff7', N'outer', NULL, N'', N'yy', 64, 1, N'', N'', NULL, NULL, NULL, NULL, NULL, 1, CAST(0x00009F5D00000000 AS DateTime), 10, N'y', CAST(0x00009F58010CFAA4 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), CAST(0xFFFF2E4600000000 AS DateTime), N'', N'rrsss', N'yy', N'yy', N'yy', N'', N'', N'0.0.0.0', CAST(0x0000A0D90118CFCB AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'', N'')
SET IDENTITY_INSERT [dbo].[CoreUser] OFF
SET IDENTITY_INSERT [dbo].[GeneralBasicSetting] ON 

INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (7, N'LabourContractTip', N'31', N'劳务人员劳务合同到期提醒的提前时间', N'TIP', N'劳务人员劳务合同到期提醒的提前时间', 0, 1, 0)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (8, N'LabourBirthdayTip', N'1', N'劳务人员生日提醒的提前时间', N'TIP', N'劳务人员生日提醒的提前时间', 0, 1, 0)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (9, N'EnterpriseContractTip', N'30', N'企业合同的到期提醒的提前时间', N'TIP', N'企业合同的到期提醒的提前时间', 0, 1, 0)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (10, N'EmployeeBirthdayTip', N'2', N'内部员工生日到期提醒的提前时间', N'TIP', N'内部员工生日到期提醒的提前时间', 0, 1, 0)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (11, N'LaborDispatch', N'1', N'劳务派遣', N'EnterpriseServiceType', N'劳务派遣', 0, 1, 1)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (12, N'HireBroke', N'2', N'代理招聘', N'EnterpriseServiceType', N'代理招聘', 0, 1, 1)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (13, N'JobFair', N'3', N'人才会场', N'EnterpriseServiceType', N'人才会场', 0, 1, 1)
INSERT [dbo].[GeneralBasicSetting] ([SettingID], [SettingKey], [SettingValue], [SettingDesc], [SettingCategory], [DisplayName], [OrderNumber], [CanUsable], [IsInnerSetting]) VALUES (14, N'OnlineService', N'4', N'百度用户', N'EnterpriseServiceType', N'百度用户', 0, 1, 1)
SET IDENTITY_INSERT [dbo].[GeneralBasicSetting] OFF
