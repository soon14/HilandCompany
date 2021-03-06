﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LaborCompare
{
    public partial class 导入银行卡号 : BaseForm
    {
        public 导入银行卡号()
        {
            //InitializeComponent();
        }

        protected override string exportFileName
        {
            get { return "导入银行卡成功的人员.txt"; }
        }

        protected override void InnerDoWork(ref List<string> resultData)
        {
            //导没有身份证的数据（*****在导入前，请已经确认人员姓名不会重复）
            string connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            //1.获取LaborBankCard表的所有数据
            DataTable dtOuter = new DataTable();
            string commandStringOuter = "SELECT [工号] ,[姓名] ,[银行卡号]  FROM [dbo].[LaborBankCard] WHERE [身份证号] is null";
            SqlDataAdapter daOuter = new SqlDataAdapter(commandStringOuter, connectionString);

            daOuter.Fill(dtOuter);


            //2.获取LaborImported表所有数据。
            DataTable dtInner = new DataTable();
            string commandStringInner = "SELECT [姓名],[身份证号码] ,[银行卡号]  FROM [dbo].[LaborAll]";
            SqlDataAdapter daInner = new SqlDataAdapter(commandStringInner, connectionString);

            daInner.Fill(dtInner);

            //3.进行判断
            int rowCountOuter = dtOuter.Rows.Count;
            for (int j = 0; j < dtOuter.Rows.Count; j++)
            {
                DataRow drOuter = dtOuter.Rows[j];

                bool isMartched = false;
                int martchedCount = 0;
                for (int i = 0; i < dtInner.Rows.Count; i++)
                {
                    DataRow drInner = dtInner.Rows[i];

                    if (drInner["姓名"].ToString() == drOuter["姓名"].ToString())
                    {
                        martchedCount++;
                    }
                }

                if (martchedCount == 1)
                {
                    isMartched = true;
                }

                if (isMartched == true)
                {
                    resultData.Add(string.Format("{0}-{1}", drOuter["姓名"].ToString(),drOuter["银行卡号"].ToString()));
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        string commString = string.Format("update [LaborAll] set [银行卡号]= '{0}' where [姓名]='{1}' ", drOuter["银行卡号"].ToString(), drOuter["姓名"].ToString());
                        using (SqlCommand comm = new SqlCommand(commString, conn))
                        {
                            conn.Open();
                            comm.ExecuteNonQuery();
                        }
                    }
                }

                base.backgroundWorker1.ReportProgress(100 * j / rowCountOuter);
            }

            //************导姓名和身份证可以对照的人员卡号
            //string connectionString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            ////1.获取LaborBankCard表的所有数据
            //DataTable dtOuter = new DataTable();
            //string commandStringOuter = "SELECT [工号] ,[姓名] ,[身份证号] ,[银行卡号]  FROM [dbo].[LaborBankCard]";
            //SqlDataAdapter daOuter = new SqlDataAdapter(commandStringOuter, connectionString);

            //daOuter.Fill(dtOuter);


            ////2.获取LaborImported表所有数据。
            //DataTable dtInner = new DataTable();
            //string commandStringInner = "SELECT [姓名],[身份证号码] ,[银行卡号]  FROM [dbo].[LaborAll]";
            //SqlDataAdapter daInner = new SqlDataAdapter(commandStringInner, connectionString);

            //daInner.Fill(dtInner);

            ////3.进行判断
            //int rowCountOuter = dtOuter.Rows.Count;
            //for (int j = 0; j < dtOuter.Rows.Count; j++)
            //{
            //    DataRow drOuter = dtOuter.Rows[j];

            //    bool isMartched = false;
            //    for (int i = 0; i < dtInner.Rows.Count; i++)
            //    {
            //        DataRow drInner = dtInner.Rows[i];

            //        if (drInner["姓名"].ToString() == drOuter["姓名"].ToString()
            //            && Convert.IsDBNull(drOuter["身份证号"]) == false
            //            && Convert.IsDBNull(drInner["身份证号码"]) == false
            //            && drInner["身份证号码"].ToString() == drOuter["身份证号"].ToString())
            //        {
            //            isMartched = true;
            //            break;
            //        }
            //    }

            //    if (isMartched == true)
            //    {
            //        resultData.Add(string.Format("{0}-{1}-{2}", drOuter["姓名"].ToString(), drOuter["身份证号"].ToString(), drOuter["银行卡号"].ToString()));
            //        using (SqlConnection conn = new SqlConnection(connectionString))
            //        {
            //            string commString = string.Format("update [LaborAll] set [银行卡号]= '{0}' where [姓名]='{1}' AND [身份证号码]='{2}' ", drOuter["银行卡号"].ToString(), drOuter["姓名"].ToString(), drOuter["身份证号"].ToString());
            //            using (SqlCommand comm = new SqlCommand(commString, conn))
            //            {
            //                conn.Open();
            //                comm.ExecuteNonQuery();
            //            }
            //        }
            //    }

            //    base.backgroundWorker1.ReportProgress(100 * j / rowCountOuter);
            //}
        }
    }
}
