<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="meetinglist.aspx.cs" Inherits="meetingattendance.meetinglist" %>

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
    <%--<link href="css/styles.css" rel="stylesheet" />--%>
    <!-- ??? -->
    <link href="~/Content/styles.css" rel="stylesheet" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

    <!-- Existing JS -->
    <%--<script src="~/Scripts/jquery-3.2.0.min.js"></script>--%>

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
                        <li class="nav-item"><a class="nav-link active" href="meetinglist.aspx">Meetings</a></li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="MeetingsList.aspx" role="button" data-bs-toggle="dropdown" aria-expanded="false">System Maintenance
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Manage Roles</a></li>
                            </ul>
                        </li>
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
                <h1 class="mt-3">Meetings</h1>
                <ol class="breadcrumb mb-4 mt-3">
                    <li class="breadcrumb-item"><a href="home.aspx">Dashboard</a></li>
                    <li class="breadcrumb-item active">Meetings</li>
                </ol>


                <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert alert-success d-flex align-items-center alert-dismissible fade show" Visible="false">
                    <i class="fa fa-check-circle me-2"></i>
                    <div>Saved successfully.</div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </asp:Panel>

                <asp:LinkButton ID="btnAddNew" runat="server" CssClass="btn btn-primary mb-3"
                    OnClientClick="resetForm(); showModal(); return false;">
                    <i class="fa fa-plus"></i> Create New Meeting
                </asp:LinkButton>



                <div class="row g-4">
                    <div class="container mt-4">
                        <div class="card">
                            <div class="card-header d-flex align-items-center">
                                <i class="bi bi-list me-2" style="font-size: 1.5rem; cursor: pointer;"></i>
                                <span>Meetings List</span>
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
                                                    CommandName="StartMeeting"
                                                    CommandArgument='<%# Eval("MeetingId") %>'
                                                    CssClass="btn btn-sm text-primary me-1"
                                                    ToolTip="Start Meeting">
                                                    <i class="far fa-eye"></i>
                                                </asp:LinkButton>

                                                <asp:LinkButton ID="EditButton" runat="server"
                                                    CommandName="EditMeeting" CommandArgument='<%# Eval("MeetingId") %>'
                                                    CssClass="btn btn-sm text-warning me-1" ToolTip="Edit">
                                                    <i class="fas fa-pencil-alt"></i>
                                                </asp:LinkButton>

                                                <asp:LinkButton runat="server" CommandName="DeleteMeeting" CommandArgument='<%# Eval("MeetingId") %>' CssClass="btn btn-sm text-danger me-1" OnClientClick="return confirm('❓ Are you sure you want to delete this meeting?');" ToolTip="Delete Meeting">
                                                        <i class="fas fa-trash fs-6"></i>
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

                <!-- Modal -->
                <div class="modal fade" id="addNewModal" tabindex="-1" aria-labelledby="addNewModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addNewModalLabel"><i class="far fa-calendar-plus me-2"></i>Add New Meeting</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                            <!-- Wrap modal body in a form for Bootstrap validation -->
                            <%--<form id="formCreateMeeting" runat="server" class="needs-validation" novalidate>--%>
                            <div class="modal-body">

                                <!-- Title -->
                                <div class="mb-3">
                                    <label class="form-label">Title <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
                                    <div class="invalid-feedback">Title is required.</div>
                                    <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                                        ErrorMessage="Title is required." CssClass="text-danger" Display="Dynamic"
                                        ValidationGroup="CreateMeeting" />
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <!-- Start Date -->
                                        <label class="form-label">Start Date <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="txtStartDateTime" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                                        <div class="invalid-feedback">Start date is required.</div>
                                        <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="txtStartDateTime"
                                            ErrorMessage="Start date is required." CssClass="text-danger" Display="Dynamic"
                                            ValidationGroup="CreateMeeting" />
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <!-- End Date -->
                                        <label class="form-label">End Date <span class="text-danger">*</span></label>
                                        <asp:TextBox ID="txtEndDateTime" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                                        <div class="invalid-feedback">End date is required.</div>
                                        <asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="txtEndDateTime"
                                            ErrorMessage="End date is required." CssClass="text-danger" Display="Dynamic"
                                            ValidationGroup="CreateMeeting" />
                                    </div>
                                </div>

                                <!-- Venue -->
                                <div class="mb-3">
                                    <label class="form-label">Location <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtVenue" runat="server" CssClass="form-control" />
                                    <div class="invalid-feedback">Location is required.</div>
                                    <asp:RequiredFieldValidator ID="rfvVenue" runat="server" ControlToValidate="txtVenue"
                                        ErrorMessage="Location is required." CssClass="text-danger" Display="Dynamic"
                                        ValidationGroup="CreateMeeting" />
                                </div>

                                <!-- Organizer -->
                                <div class="mb-3">
                                    <label class="form-label">Organizer <span class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtOrganizer" runat="server" CssClass="form-control" />
                                    <div class="invalid-feedback">Organizer is required.</div>
                                    <asp:RequiredFieldValidator ID="rfvOrganizer" runat="server" ControlToValidate="txtOrganizer"
                                        ErrorMessage="Organizer is required." CssClass="text-danger" Display="Dynamic"
                                        ValidationGroup="CreateMeeting" />
                                </div>

                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                                    Cancel
                                </button>
                                <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary"
                                    Text="Save" OnClick="btnSave_Click" ValidationGroup="CreateMeeting" />
                            </div>
                            <%--</form>--%>
                        </div>
                    </div>
                </div>
                <!-- End Save Modal -->

            </div>
        </main>
    </form>

    <!-- Scripts already in your footer -->
    <%--<script src="~/Scripts/bootstrap.bundle.min.js"></script>--%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <%--<script src="-https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>--%>
    <script src="~/Scripts/scripts.js"></script>
    <script src="~/Scripts/simple-datatables.js"></script>
    <script src="~/Scripts/datatables-simple-demo.js"></script>
    <!-- Bootstrap JS -->

    <!-- Apply DataTable -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const table = document.querySelector("#<%= gvMeetings.ClientID %>");
            if (table) {
                new simpleDatatables.DataTable(table);
            }
        });
    </script>

    <!-- Bootstrap JS -->

    <script>
        function showModal() {
            var modal = new bootstrap.Modal(document.getElementById('addNewModal'));
            modal.show();
        }

        function resetForm() {
            document.getElementById('<%= txtTitle.ClientID %>').value = '';
            document.getElementById('<%= txtStartDateTime.ClientID %>').value = '';

            document.getElementById('<%= txtEndDateTime.ClientID %>').value = '';

            document.getElementById('<%= txtVenue.ClientID %>').value = '';
            document.getElementById('<%= txtOrganizer.ClientID %>').value = '';
        }

        function closeModal() {
            var modalEl = document.getElementById('addNewModal');
            var modal = bootstrap.Modal.getInstance(modalEl);
            modal.hide();
        }

        <%--function showSuccessAlert() {
            var alertBox = document.getElementById('<%= pnlSuccess.ClientID %>');
            if (alertBox) {
                alertBox.style.display = 'block';
                setTimeout(function () {
                    var bsAlert = new bootstrap.Alert(alertBox);
                    bsAlert.close();
                }, 3000); // auto-hide after 3 seconds
            }
        }--%>
    </script>

    <!--09/04/25 Date Validation-->
    <script>
        function validateDateRange(sender, args) {
            var startDate = document.getElementById("<%= txtStartDateTime.ClientID %>").value;
            var endDate = document.getElementById("<%= txtEndDateTime.ClientID %>").value;

            if (startDate && endDate) {
                var start = new Date(startDate);
                var end = new Date(endDate);
                args.IsValid = (end > start);
            } else {
                args.IsValid = true; // let required validators handle empty fields
            }
        }
    </script>

    <script>
        $('#gvMeetings').DataTable({
            "createdRow": function (row, data, dataIndex) {
                // Assuming StartDate is column index 2 and Status is column index 4
                var startDate = new Date(data[3]);
                var status = data[6];
                var now = new Date();

                if (status === "Scheduled") {
                    if (startDate < now) {
                        // Meeting time passed but still scheduled → missed
                        $('td', row).eq(2).addClass('text-white bg-danger');
                    } else if (startDate.toDateString() === now.toDateString() &&
                        startDate <= now) {
                        // Meeting started today but still scheduled → late
                        $('td', row).eq(2).addClass('text-dark bg-warning');
                    }
                }
            }
        });

    </script>

    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var alertBox = document.getElementById("<%= pnlSuccess.ClientID %>");
        if (alertBox && alertBox.style.display !== "none") {
            setTimeout(function () {
                var bsAlert = new bootstrap.Alert(alertBox);
                bsAlert.close();
            }, 3000); // disappear after 3s
        }
    });
    </script>


</body>
</html>
