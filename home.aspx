<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="meetingattendance.home" %>

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
        <link href="css/styles.css" rel="stylesheet" />

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

        <script src="js/jquery-3.2.0.min.js"></script>
        <script src="js/all.min.js"></script>
    </head>
    <body class="sb-nav-fixed">
        <!-- Top Navbar -->
        <nav class="navbar navbar-expand" style="background-color: #10218B;" data-bs-theme="dark">
            <div class="container-fluid">
            <a class="navbar-brand ps-3" href="home.aspx" style="font-weight: bold; font-family: nunito; font-size: 17px;">Meeting Attendance Tapping</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active" href="index.html">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="meetinglist.aspx">Meetings</a></li>
                    <li class="nav-item dropdown">
                      <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        System Maintenance
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


    

            <!-- Main Content -->
                <main>
                   
                    <div class="container-fluid px-4">
                        <h1 class="mt-3">Dashboard</h1>
                        <ol class="breadcrumb mb-4 mt-3">
                            <li class="breadcrumb-item active">Dashboard</li>
                        </ol>

                        <div class="row g-4">
                            <!-- Total Reports Card -->                            
                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-light shadow-sm rounded-3">                                   
                                    <div class="card-body d-flex justify-content-between">
                                        <span>Upcoming Meetings</span>
                                        <i class="bi bi-calendar fs-5"></i>
                                    </div>
                                    <asp:Label ID="lblUpcomingMeetings" runat="server" CssClass="h2 px-3"></asp:Label>                                                                   
                                  <div class="card-footer text-body-secondary d-flex align-items-center justify-content-between rounded-bottom">
                                    <a class="small stretched-link" href="meetinglist.aspx">View Details</a>
                                    <div><i class="fas fa-angle-right"></i></div>
                                  </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-light shadow-sm rounded-3">                                
                                    <div class="card-body d-flex justify-content-between">
                                        <span>Ongoing</span>
                                        <i class="bi bi-calendar-event fs-5"></i>
                                    </div>
                                    <asp:Label ID="lblOngoingMeetings" runat="server" CssClass="h2 px-3"></asp:Label>
                                  <div class="card-footer text-body-secondary d-flex align-items-center justify-content-between rounded-bottom">
                                    <a class="small stretched-link" href="meetinglist.aspx">View Details</a>
                                    <div><i class="fas fa-angle-right"></i></div>
                                  </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-light shadow-sm rounded-3">
                                    <div class="card-body d-flex justify-content-between">
                                        <span>Missed</span>
                                        <i class="bi bi-calendar-x fs-5"></i>
                                    </div>
                                    <asp:Label ID="lblMissedMeetings" runat="server" CssClass="h2 px-3"></asp:Label>
                                  <div class="card-footer text-body-secondary d-flex align-items-center justify-content-between rounded-bottom">
                                    <a class="small stretched-link" href="meetinglist.aspx">View Details</a>
                                    <div><i class="fas fa-angle-right"></i></div>
                                  </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6">
                                <div class="card bg-light shadow-sm rounded-3">
                                    <div class="card-body d-flex justify-content-between">
                                        <span>Completed</span>
                                        <i class="bi bi-calendar-check fs-5"></i>
                                    </div>
                                    <asp:Label ID="lblHistoryMeetings" runat="server" CssClass="h2 px-3"></asp:Label>
                                  <div class="card-footer text-body-secondary d-flex align-items-center justify-content-between rounded-bottom">
                                    <a class="small stretched-link" href="historylogs.aspx">View Details</a>
                                    <div><i class="fas fa-angle-right"></i></div>
                                  </div>
                                </div>
                            </div>


                        </div>
                    </div>
                </main>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
