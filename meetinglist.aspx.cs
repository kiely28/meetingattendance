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
    public partial class meetinglist : System.Web.UI.Page
    {
        //protected void Page_Load(object sender, EventArgs e)
        //{
        //    if (!IsPostBack)
        //    {
        //        LoadMeetings();
        //    }
        //}

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMeetings();

                if (Session["MeetingEnded"] != null && Session["MeetingEnded"].ToString() == "true")
                {
                    // Show the success panel
                    pnlSuccess.Visible = true;

                    // Update the message if needed
                    pnlSuccess.Controls.Clear();
                    pnlSuccess.Controls.Add(new LiteralControl(
                        "<i class='fa fa-check-circle me-2'></i> Meeting ended successfully."
                    ));

                    // Clear the session so it only shows once
                    Session.Remove("MeetingEnded");
                }
            }
        }





        private void LoadMeetings()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;
            string currentUser = "B014172"; //Session["Username"].ToString(); //"B014172"; //Session["B014172"].ToString(); //User.Identity.Name; // or Session["Username"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("MA_GetUserMeetings", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CreatedBy", currentUser);

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        gvMeetings.DataSource = dt;
                        gvMeetings.DataBind();
                        lblMessage.Text = "";
                    }
                    else
                    {
                        lblMessage.Text = "No upcoming meetings found.";
                        gvMeetings.DataSource = null;
                        gvMeetings.DataBind();
                    }
                }
            }
        }




        protected void gvMeetings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string meetingId = e.CommandArgument.ToString();

            if (e.CommandName == "StartMeeting")
            {
                string connectionString = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;

                // Check status first
                string status = "";
                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("SELECT Status1 FROM Tbl_Meetings WHERE MeetingID = @MeetingID", conn))
                {
                    cmd.Parameters.AddWithValue("@MeetingID", meetingId);
                    conn.Open();
                    status = cmd.ExecuteScalar()?.ToString();
                }

                if (status == "Scheduled")
                {
                    // Update to Ongoing
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    using (SqlCommand cmd = new SqlCommand("MA_UpdateMeetingStatus", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@MeetingID", meetingId);
                        cmd.Parameters.AddWithValue("@Status", "Ongoing");

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Redirect to attendance page either way
                Response.Redirect($"meetingattendance.aspx?meetingId={meetingId}");
            }

            else if (e.CommandName == "EditMeeting")
            {
                Response.Redirect($"EditMeeting.aspx?meetingId={meetingId}");
            }

            else if (e.CommandName == "DeleteMeeting")
            {
                DeleteMeeting(meetingId);
                LoadMeetings();
            }
        }

        protected void gvMeetings_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.TableSection = TableRowSection.TableHeader;
            }
        }


        private void DeleteMeeting(string meetingId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("MA_DeleteMeeting", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MeetingId", meetingId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;
            string meetingId = "";
            string currentUser = "B014172"; // Later replace with Session["Username"] or User.Identity.Name

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand("MA_InsertMeeting", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                    cmd.Parameters.Add("@StartDateTime", SqlDbType.DateTime).Value = DateTime.Parse(txtStartDateTime.Text);
                    cmd.Parameters.Add("@EndDateTime", SqlDbType.DateTime).Value = DateTime.Parse(txtEndDateTime.Text);
                    cmd.Parameters.AddWithValue("@Venue", txtVenue.Text);
                    cmd.Parameters.AddWithValue("@Organizer", txtOrganizer.Text);
                    cmd.Parameters.AddWithValue("@CreatedBy", currentUser);

                    SqlParameter outputParam = new SqlParameter("@MeetingId", SqlDbType.NVarChar, 50)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outputParam);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();

                    meetingId = outputParam.Value.ToString();

                    // Show success panel
                    pnlSuccess.Visible = true;

                    // Refresh grid so new meeting shows up
                    LoadMeetings();

                    // Close modal + show success alert
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "saveSuccess",
                        "closeModal(); showSuccessAlert();", true);
                }
            }
            catch (SqlException sqlEx)
            {
                // SQL Server error
                lblMessage.Text = "Database error: " + sqlEx.Message;
                lblMessage.CssClass = "text-danger fw-bold";
            }
            catch (FormatException)
            {
                // Handle invalid date format
                lblMessage.Text = "Invalid date format. Please check Start/End Date fields.";
                lblMessage.CssClass = "text-danger fw-bold";
            }
            catch (Exception ex)
            {
                // General error
                lblMessage.Text = "Unexpected error: " + ex.Message;
                lblMessage.CssClass = "text-danger fw-bold";
            }
        }

        protected void gvMeetings_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Get the status text
                Label lblStatus = (Label)e.Row.FindControl("lblStatus");

                // Get the Edit button (server-side one)
                LinkButton editButton = (LinkButton)e.Row.FindControl("EditButton");

                if (lblStatus != null && lblStatus.Text == "Ongoing")
                {
                    if (editButton != null)
                    {
                        // Block editing and show alert
                        editButton.OnClientClick = "alert('You cannot edit a meeting that is already ongoing.'); return false;";
                    }
                }

                // Add Badge for Status
                if (lblStatus != null)
                {
                    //string status = lblStatus.Text.ToLower();
                    string status = lblStatus.Text.Trim().ToLower();

                    switch (status)
                    {
                        case "scheduled":
                            lblStatus.CssClass = "badge bg-info";
                            break;
                        case "ongoing":
                            lblStatus.CssClass = "badge bg-success";
                            break;
                        //case "missed":
                        //    lblStatus.CssClass = "badge bg-danger";
                        //    break;
                        default:
                            lblStatus.CssClass = "badge bg-secondary";
                            break;

                    }
                }
                LinkButton btnStart = (LinkButton)e.Row.FindControl("btnStartMeeting");

                if (lblStatus != null && btnStart != null)
                {
                    if (lblStatus.Text == "Ongoing")
                    {
                        // Meeting already ongoing → continue to attendance
                        btnStart.OnClientClick = "return confirm('This meeting is already ongoing. Do you want to continue?');";
                    }
                    else
                    {
                        // Scheduled → update to ongoing first
                        btnStart.OnClientClick = "return confirm('Do you want to start this meeting?');";
                    }
                }


            }
        }


        [System.Web.Services.WebMethod]
        public static object GetMeetingById(string meetingId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("GetMeetingById", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MeetingId", meetingId);
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        return new
                        {
                            MeetingId = dr["MeetingId"].ToString(),
                            Title = dr["Title"].ToString(),
                            StartDateTime = Convert.ToDateTime(dr["StartDateTime"]).ToString("yyyy-MM-ddTHH:mm"),
                            EndDateTime = Convert.ToDateTime(dr["EndDateTime"]).ToString("yyyy-MM-ddTHH:mm"),
                            Venue = dr["Venue"].ToString(),
                            Organizer = dr["Organizer"].ToString()
                        };
                    }
                }
            }
            return null;
        }

    }
}