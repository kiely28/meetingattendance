<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="historylogs.aspx.cs" Inherits="meetingattendance.historylogs" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>Meeting Attendance Tapping</title>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Nunito">

    <!-- Custom styles -->
    <link href="~/Content/styles.css" rel="stylesheet" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Font Awesome Free 5.15.4 -->
    <script src="~/Scripts/all.min.js"></script>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>

<body class="sb-nav-fixed">
    <form id="form1" runat="server">
        <!-- Top Navbar -->
        <nav class="navbar navbar-expand" style="background-color: #10218B;" data-bs-theme="dark">
            <div class="container-fluid">
                <a class="navbar-brand ps-3" href="home.aspx" style="font-weight: bold; font-family: nunito; font-size: 17px;">Meeting Attendance Tapping</a>
                <!-- Sidebar Toggle-->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a class="nav-link" href="home.aspx">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="meetinglist.aspx">Meetings</a></li>
                        <li class="nav-item"><a class="nav-link active" href="history.aspx">History Logs</a></li>

                    </ul>
                </div>
                <!-- User Dropdown -->
                <ul class="navbar-nav ms-auto me-3">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="#">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>

        <main>
            <div class="container-fluid px-4">
                <h1 class="mt-3">History</h1>
                <ol class="breadcrumb mb-4 mt-3">
                    <li class="breadcrumb-item"><a href="home.aspx">Dashboard</a></li>
                    <li class="breadcrumb-item active">History</li>
                </ol>


                <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success d-flex align-items-center alert-dismissible fade show" Visible="false">
                    <i class="fa fa-check-circle me-2"></i>
                    <div>Saved successfully.</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </asp:Panel>

                <div class="row g-4">
                    <div class="container mt-4">
                        <div class="card">
                            <div class="card-header d-flex align-items-center">
                                <i class="bi bi-list me-2" style="font-size: 1.5rem; cursor: pointer;"></i>
                                <span>History Logs</span>
                            </div>
                            <div class="card-body">
                                <!-- Table -->

                                <asp:GridView ID="gvMeetings" runat="server" CssClass="table table-bordered" UseAccessibleHeader="true"
                                    AutoGenerateColumns="False" OnRowCommand="gvMeetings_RowCommand" DataKeyNames="MeetingId" OnRowCreated="gvMeetings_RowCreated" OnRowDataBound="gvMeetings_RowDataBound">
                                    <Columns>
                                        <asp:TemplateField HeaderText="#" HeaderStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex + 1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="MeetingId" HeaderText="Meeting ID" />
                                        <asp:BoundField DataField="Title" HeaderText="Title" />
                                        <asp:BoundField DataField="StartDateTime" HeaderText="Start Date" DataFormatString="{0:MM-dd-yyyy hh:mm tt}" />
                                        <asp:BoundField DataField="EndDateTime" HeaderText="End Date" DataFormatString="{0:MM-dd-yyyy hh:mm tt}" />
                                        <asp:BoundField DataField="Venue" HeaderText="Venue" />
                                        <asp:BoundField DataField="Organizer" HeaderText="Organizer" />
                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status1") %>' CssClass="badge"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>


                                        <asp:TemplateField>
                                            <HeaderTemplate>
                                                <i class="bi bi-gear-fill"></i> Actions
                                            </HeaderTemplate>
                                            <ItemTemplate>


                                                <asp:LinkButton ID="btnStartMeeting" runat="server"
                                                    CommandName="ViewAttendees"
                                                    CommandArgument='<%# Eval("MeetingId") %>'
                                                    CssClass="btn btn-sm btn-primary me-1"
                                                    ToolTip="View Meeting">
                                                    <i class="far fa-eye"></i> View Attendees
                                                </asp:LinkButton>


                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                <asp:Label ID="lblMessage" runat="server" CssClass="text-danger fw-bold"></asp:Label>
                                <!-- End Table -->
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </form>

    <!-- Scripts already in your footer -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="~/Scripts/scripts.js"></script>
    <script src="~/Scripts/simple-datatables.js"></script>
    <script src="~/Scripts/datatables-simple-demo.js"></script>

    <!-- Apply DataTable -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const table = document.querySelector("#<%= gvMeetings.ClientID %>");
            if (table) {
                new simpleDatatables.DataTable(table);
            }
        });
    </script>
</body>
</html>
