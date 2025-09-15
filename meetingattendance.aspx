<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="meetingattendance.aspx.cs" Inherits="meetingattendance.meetingattendance" %>

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

    <style>
        .custom-input {
            font-size: 2rem;
            padding: 1rem 1.5rem;
            /*font-family: 'nunito', sans-serif;*/
        }

        .form-check input[type="radio"] {
            width: 1.5em;
            height: 1.5em;
        }

        .form-check label {
            font-size: 1.25rem;
            padding-left: 0.5em;
        }

        .btn-lg-custom {
            font-size: 2rem;
            padding: 1.2rem 2rem;
            border-radius: 0.5rem;
        }
    </style>
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
                        <%--<li class="nav-item"><a class="nav-link" href="#">History Logs</a></li>--%>
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

                <h1 class="mt-3">
                    <asp:Label ID="lblTitle" runat="server" Text="Title"></asp:Label>
                </h1>
                <ol class="breadcrumb mb-4 mt-3">
                    <li class="breadcrumb-item active">
                        <asp:Label ID="lblDateTime" runat="server" Text="Date / Time"></asp:Label>
                    </li>
                </ol>

                <!-- Hidden Meeting ID -->
                <asp:HiddenField ID="hfMeetingID" runat="server" />

                <div class="row">
                    <div class="col-3 col-lg-3 mb-3">
                        <input type="radio" class="btn-check" name="tapMode" id="radioIn" value="In" autocomplete="off">
                        <label class="btn btn-outline-primary w-100 btn-lg btn-lg-custom" for="radioIn">In</label>
                    </div>
                    <div class="col-3 col-lg-3 mb-3">
                        <input type="radio" class="btn-check" name="tapMode" id="radioOut" value="Out" autocomplete="off">
                        <label class="btn btn-outline-secondary w-100 btn-lg btn-lg-custom" for="radioOut">Out</label>
                    </div>
                    <div class="col-6 d-flex justify-content-end">
                        <div>
                            <asp:Button ID="btnViewAttendees" runat="server" CssClass="btn btn-info text-white me-2 w-auto"
                                Text="View Attendees" OnClick="btnViewAttendees_Click" />
                            <asp:Button ID="btnEndMeeting" runat="server" CssClass="btn btn-danger w-auto"
                                Text="End Meeting" OnClick="btnEndMeeting_Click" />
                        </div>
                    </div>
                </div>

                <!-- Hidden field to hold selected mode -->
                <asp:HiddenField ID="hfTapMode" runat="server" />

                <div class="mb-3">
                    <asp:TextBox ID="txtCardSerial" runat="server" CssClass="form-control custom-input"
                        placeholder="Place your ID card on the reader"
                        AutoPostBack="true" OnTextChanged="txtCardSerial_TextChanged"></asp:TextBox>
                </div>

                <div class="mt-3">
                    <asp:Panel ID="pnlAlert" runat="server" Visible="false"
                        CssClass="alert alert-dismissible fade show" role="alert">
                        <h5 class="alert-heading">
                            <asp:Label ID="lblAlertHeading" runat="server"></asp:Label>
                        </h5>

                        <hr>
                        <p class="mb-0 fs-5">
                            <asp:Label ID="lblAlertName" runat="server"></asp:Label>
                        </p>
                        <p class="fs-6">
                            <asp:Label ID="lblAlertDept" runat="server"></asp:Label>
                        </p>
                        <p class="mb-0">
                            <asp:Label ID="lblAlertDateTime" runat="server"></asp:Label>
                        </p>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </asp:Panel>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <!-- Auto fade-out -->
                <script type="text/javascript">
                    function fadeOutAlert() {
                        var alertBox = document.getElementById('<%= pnlAlert.ClientID %>');
                        if (alertBox && alertBox.style.display !== "none") {
                            setTimeout(function () {
                                var bsAlert = new bootstrap.Alert(alertBox);
                                bsAlert.close();
                            }, 3000); // disappear after 3s
                        }
                    }
                </script>





            </div>
        </main>
    </form>

    <%--<script type="text/javascript">
        document.querySelectorAll('input[name="tapMode"]').forEach(function (radio) {
            radio.addEventListener('change', function () {
                document.getElementById('<%= hfTapMode.ClientID %>').value = this.value;
            });
        });

        // Initialize default (In) on page load
        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById('<%= hfTapMode.ClientID %>').value = "In";
    });
    </script>--%>

    <script type="text/javascript">
        // When user changes radio button, update hidden field
        document.querySelectorAll('input[name="tapMode"]').forEach(function (radio) {
            radio.addEventListener('change', function () {
                document.getElementById('<%= hfTapMode.ClientID %>').value = this.value;
        });
    });

        // On page load, restore the radio button from hidden field
        document.addEventListener("DOMContentLoaded", function () {
            var savedMode = document.getElementById('<%= hfTapMode.ClientID %>').value;

        if (!savedMode) {
            savedMode = "In"; // default
            document.getElementById('<%= hfTapMode.ClientID %>').value = savedMode;
        }

        // Uncheck all radios first
        document.querySelectorAll('input[name="tapMode"]').forEach(function (r) {
            r.checked = false;
        });

        // Check only the saved one
        var radioToCheck = document.getElementById("radio" + savedMode);
        if (radioToCheck) {
            radioToCheck.checked = true;
        }
    });
    </script>


    <!-- Scripts already in your footer -->
    <%--<script src="~/Scripts/bootstrap.bundle.min.js"></script>--%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="~/Scripts/scripts.js"></script>
    <script src="~/Scripts/simple-datatables.js"></script>
    <script src="~/Scripts/datatables-simple-demo.js"></script>
</body>
</html>
