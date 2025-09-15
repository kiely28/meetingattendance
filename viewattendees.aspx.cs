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
    public partial class viewattendees : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string meetingId = Request.QueryString["MeetingId"];
                if (!string.IsNullOrEmpty(meetingId))
                {
                    LoadAttendees(meetingId);
                }
                else
                {
                    lblMessage.Text = "No Meeting ID provided.";
                }
            }
        }

        private void LoadAttendees(string meetingId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("MA_GetAttendeesByMeeting", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MeetingId", meetingId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    gvMeetings.DataSource = dt;
                    gvMeetings.DataBind();
                }
                else
                {
                    gvMeetings.DataSource = null;
                    gvMeetings.DataBind();
                    lblMessage.Text = "No attendees found for this meeting.";
                }
            }
        }
    }
}