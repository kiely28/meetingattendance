using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace meetingattendance
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (email == "B014172" && password == "isd")
            {
                Session["Username"] = email;
                Response.Redirect("home.aspx");
            }
            else
            {
                lblError.Text = "Login failed. Invalid credentials.";
                lblError.Visible = true;
            }
        }

        //protected void btnLogin_Click(object sender, EventArgs e)
        //{
        //    string email = txtEmail.Text.Trim();
        //    string password = txtPassword.Text;

        //    // TODO: Implement your login logic here
        //    if (email == "admin@example.com" && password == "admin123")
        //    {
        //        // Example: redirect to dashboard
        //        Response.Redirect("Dashboard.aspx");
        //    }
        //    else
        //    {
        //        // Example error message
        //        ValidationSummary1.HeaderText = "Login failed. Invalid credentials.";
        //    }
        //}
    }
}