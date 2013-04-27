﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Salary.Web.BasePage;

public partial class UI_Portal_Header : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            this.lbLoginName.Text = CurrentUserInfo.UserName;
        }
    }
}
