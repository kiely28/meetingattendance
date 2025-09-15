using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace meetingattendance
{
    public partial class home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMeetingCounts();
            }
        }

        private void LoadMeetingCounts()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("MA_GetMeetingCounts", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();

                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        //lblTotalMeetings.Text = dr["TotalMeetings"].ToString();             
                        lblUpcomingMeetings.Text = dr["UpcomingMeetings"].ToString();
                        lblOngoingMeetings.Text = dr["OngoingMeetings"].ToString();
                        lblMissedMeetings.Text = dr["MissedMeetings"].ToString();
                        lblHistoryMeetings.Text = dr["HistoryMeetings"].ToString();
                    }
                }
            }
        }
    }
}