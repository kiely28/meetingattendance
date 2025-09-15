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
    public partial class meetingattendance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string meetingId = Request.QueryString["meetingId"];
                if (!string.IsNullOrEmpty(meetingId))
                {
                    LoadMeetingDetails(meetingId);
                }
                else
                {
                    lblTitle.Text = "Invalid Meeting";
                    lblDateTime.Text = "";
                }
            }
            // Always focus on the textbox after page load or postback
            Page.SetFocus(txtCardSerial);
        }

        private void LoadMeetingDetails(string meetingId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("MA_GetMeetingDetails", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MeetingId", meetingId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblTitle.Text = reader["Title"].ToString();
                    //lblDateTime.Text = $"{Convert.ToDateTime(reader["StartDateTime"]):MM-dd-yyyy hh:mm tt} - {Convert.ToDateTime(reader["EndDateTime"]):MM-dd-yyyy hh:mm tt}";
                    lblDateTime.Text = $"{reader["Venue"]} / {Convert.ToDateTime(reader["StartDateTime"]):MMMM dd, yyyy hh:mm tt} - {Convert.ToDateTime(reader["EndDateTime"]):hh:mm tt}";
                    hfMeetingID.Value = meetingId;
                }
                else
                {
                    lblTitle.Text = "Meeting not found";
                    lblDateTime.Text = "";
                }
            }
        }

        protected void btnViewAttendees_Click(object sender, EventArgs e)
        {
            string meetingId = hfMeetingID.Value; // assuming it's stored
            Response.Redirect($"viewattendees.aspx?meetingId={meetingId}");
        }

        //protected void btnEndMeeting_Click(object sender, EventArgs e)
        //{
        //    if (string.IsNullOrEmpty(hfMeetingID.Value))
        //    {
        //        ShowAlert("No Meeting ID found!", "danger");
        //        return;
        //    }

        //    string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;

        //    using (SqlConnection con = new SqlConnection(connStr))
        //    {
        //        SqlCommand cmd = new SqlCommand("EndMeeting", con);
        //        cmd.CommandType = CommandType.StoredProcedure;
        //        cmd.Parameters.AddWithValue("@meetingid", hfMeetingID.Value);

        //        con.Open();
        //        var result = cmd.ExecuteScalar();
        //        string message = result != null ? result.ToString() : "Meeting update failed.";

        //        ShowAlert(message, message.Contains("Completed") ? "success" : "danger");
        //    }

        //    // Optionally disable buttons after ending
        //    //btnTap.Enabled = false;
        //    //btnEndMeeting.Enabled = false;
        //} 


        private void ShowAlert(string heading, string fullName, string dept, string cssClass)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = $"alert {cssClass} alert-dismissible fade show";

            lblAlertHeading.Text = heading;
            lblAlertName.Text = fullName;
            lblAlertDept.Text = dept;
            lblAlertDateTime.Text = DateTime.Now.ToString("MMMM dd, yyyy hh:mm:ss tt");

            // auto fade-out
            ScriptManager.RegisterStartupScript(this, GetType(), "fadeOutAlert", "fadeOutAlert();", true);
        }



        protected void txtCardSerial_TextChanged(object sender, EventArgs e)
        {
            string cardSerial = txtCardSerial.Text.Trim();
            string meetingId = hfMeetingID.Value;

            // Prefer real posted radio value; fallback to the hidden field (hfTapMode)
            string tapMode = Request.Form["tapMode"];
            if (string.IsNullOrEmpty(tapMode))
                tapMode = hfTapMode.Value ?? "In";

            if (string.IsNullOrEmpty(cardSerial))
            {
                ShowAlert("Invalid Tap", "Please place your card on the reader.", "", "alert-warning");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Validate employee first
                    string empName = "";
                    string dept = "";

                    using (SqlCommand cmd = new SqlCommand("MA_CheckEmployeeByCard", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@CardSerialNo", cardSerial);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                txtCardSerial.Text = "";
                                ShowAlert("Card Not Registered", "Unknown Card", "", "alert-danger");
                                return;
                            }
                            empName = (reader["FirstName"] ?? "").ToString().Trim() + " " + (reader["MiddleName"] ?? "").ToString().Trim() + " " + (reader["LastName"] ?? "").ToString().Trim();
                            dept = (reader["DivisionName"] ?? "").ToString().Trim() + " " + (reader["DepartmentName"] ?? "").ToString().Trim() + " " + (reader["SectionName"] ?? "").ToString().Trim();
                        }
                    }

                    if (tapMode.Equals("In", StringComparison.OrdinalIgnoreCase))
                    {
                        using (SqlCommand insertCmd = new SqlCommand("MA_InsertAttendee", conn))
                        {
                            insertCmd.CommandType = CommandType.StoredProcedure;
                            insertCmd.Parameters.AddWithValue("@MeetingId", meetingId);
                            insertCmd.Parameters.AddWithValue("@CardSerialNo", cardSerial);

                            object resObj = insertCmd.ExecuteScalar();
                            int res = (resObj != null && int.TryParse(resObj.ToString(), out int tmp)) ? tmp : -1;

                            if (res == 0)
                                ShowAlert("Already Tapped In", empName, dept, "alert-warning");
                            else if (res == 1)
                                ShowAlert("You have tapped in successfully!", empName, dept, "alert-success");
                            else
                                ShowAlert("Tap-in failed", empName, dept, "alert-danger");
                        }
                    }
                    else // Out
                    {
                        using (SqlCommand updateCmd = new SqlCommand("MA_UpdateAttendeeTimeout", conn))
                        {
                            updateCmd.CommandType = CommandType.StoredProcedure;
                            updateCmd.Parameters.AddWithValue("@MeetingId", meetingId);
                            updateCmd.Parameters.AddWithValue("@CardSerialNo", cardSerial);

                            object result = updateCmd.ExecuteScalar();
                            int rows = (result != null && int.TryParse(result.ToString(), out int r)) ? r : 0;

                            if (rows > 0)
                                ShowAlert("You have tapped out successfully!", empName, dept, "alert-info");
                            else
                                ShowAlert("Already tapped out or no tap-in found", empName, dept, "alert-warning");
                        }
                    }

                    // Reset input and focus
                    txtCardSerial.Text = "";
                    ScriptManager.RegisterStartupScript(this, GetType(), "setFocus",
                        $"document.getElementById('{txtCardSerial.ClientID}').focus();", true);
                }
            }
            catch (Exception ex)
            {
                // Temporary debugging; in production log this instead
                ShowAlert("Error", ex.Message, "", "alert-danger");
            }
        }


        protected void btnEndMeeting_Click(object sender, EventArgs e)
        {
            string meetingId = hfMeetingID.Value; // Or however you store the current MeetingId

            string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("MA_EndMeeting", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@MeetingId", meetingId);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        // Store a session flag
                        Session["MeetingEnded"] = "true";

                        // Redirect to meeting list
                        Response.Redirect("meetinglist.aspx");
                    }
                    else
                    {
                        ShowAlert("Unable to end meeting. Please check Meeting ID.", "", "", "alert-danger");
                    }


                    //if (rows > 0)
                    //{
                    //    // Meeting ended successfully → redirect to meeting list
                    //    Response.Redirect("meetinglist.aspx");
                    //}
                    //else
                    //{
                    //    // Show error but stay on the page
                    //    ShowAlert("Unable to end meeting. Please check Meeting ID.", "", "", "alert-danger");
                    //}
                }
            }
        }




        //protected void txtCardSerial_TextChanged(object sender, EventArgs e)
        //{
        //    string cardSerial = txtCardSerial.Text.Trim();
        //    string meetingId = hfMeetingID.Value;
        //    string tapMode = hfTapMode.Value; // "In" or "Out"

        //    if (string.IsNullOrEmpty(cardSerial))
        //    {
        //        ShowAlert("Invalid Tap", "Please place your card on the reader.", "", "alert-warning");
        //        return;
        //    }

        //    string connStr = ConfigurationManager.ConnectionStrings["MeetingDb"].ConnectionString;

        //    using (SqlConnection conn = new SqlConnection(connStr))
        //    {
        //        conn.Open();

        //        // 1. Validate Employee
        //        string empName = "";
        //        string dept = "";
        //        //string sec = "";

        //        using (SqlCommand cmd = new SqlCommand("MA_CheckEmployeeByCard", conn))
        //        {
        //            cmd.CommandType = CommandType.StoredProcedure;
        //            cmd.Parameters.AddWithValue("@CardSerialNo", cardSerial);

        //            SqlDataReader reader = cmd.ExecuteReader();
        //            if (!reader.Read())
        //            {
        //                ShowAlert("Card Not Registered", "Unknown Card", "", "alert-danger");
        //                return;
        //            }

        //            empName = reader["FirstName"].ToString() + " " + reader["MiddleName"].ToString() + " " + reader["LastName"].ToString();
        //            dept = reader["DivisionName"].ToString() + " " + reader["DepartmentName"].ToString() + " " + reader["SectionName"].ToString();
        //            //sec = reader["Section"].ToString();
        //            reader.Close();
        //        }

        //        // 2. Tap-In or Tap-Out
        //        if (tapMode == "In")
        //        {
        //            using (SqlCommand insertCmd = new SqlCommand("MA_InsertAttendee", conn))
        //            {
        //                insertCmd.CommandType = CommandType.StoredProcedure;
        //                insertCmd.Parameters.AddWithValue("@MeetingId", meetingId);
        //                insertCmd.Parameters.AddWithValue("@CardSerialNo", cardSerial);

        //                object result = insertCmd.ExecuteScalar();

        //                if (result != null && result.ToString() == "0")
        //                {
        //                    //ShowAlert("Already Tapped In", empName, $"{dept} - {sec}", "alert-warning");
        //                    ShowAlert("Already Tapped In", empName, dept, "alert-warning");
        //                }
        //                else
        //                {
        //                    ShowAlert("You have tapped in successfully!", empName, dept, "alert-success");
        //                }
        //            }
        //        }
        //        else if (tapMode == "Out")
        //        {
        //            using (SqlCommand updateCmd = new SqlCommand("MA_UpdateAttendeeTimeout", conn))
        //            {
        //                updateCmd.CommandType = CommandType.StoredProcedure;
        //                updateCmd.Parameters.AddWithValue("@MeetingId", meetingId);
        //                updateCmd.Parameters.AddWithValue("@CardSerialNo", cardSerial);

        //                object result = updateCmd.ExecuteScalar();
        //                int rows = (result != null) ? Convert.ToInt32(result) : 0;

        //                if (rows > 0)
        //                {
        //                    ShowAlert("You have tapped out successfully!", empName, dept, "alert-info");
        //                }
        //                else
        //                {
        //                    ShowAlert("Already tapped out or no tap-in found", empName, dept, "alert-warning");
        //                }
        //            }
        //        }

        //        // 3. Reset for next tap
        //        txtCardSerial.Text = "";
        //        ScriptManager.RegisterStartupScript(this, GetType(), "setFocus",
        //            $"document.getElementById('{txtCardSerial.ClientID}').focus();", true);
        //    }
        //}



    }
}