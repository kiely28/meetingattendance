<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="meetingattendance.login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Login</title>
    <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
</head>
<body>
    <form id="form1" runat="server">
        <section class="bg-light py-3 py-md-5">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-5 col-xxl-4">
                        <div class="card border border-light-subtle rounded-3 shadow-sm">
                            <div class="card-body p-3 p-md-4 p-xl-5">
                                <div class="text-center mb-3">
                                    <a href="#">
                                        <%--<img src="./assets/img/bsb-logo.svg" alt="Logo" width="175" height="57" />--%>
                                        <img src="./images/matlogo.png" alt="Logo" width="67" height="67" />
                                    </a>
                                </div>
                                <h2 class="fs-6 fw-normal text-center text-secondary mb-4">Log in to your account</h2>

                                <%--<asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="text-danger" />--%>
                                <%-- <asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false"></asp:Label>--%>
                                <%--<asp:Label ID="lblError" runat="server" CssClass="text-danger text-center d-block mb-2" Visible="false"></asp:Label>--%>
                                <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger text-center d-block mb-3" Visible="false"></asp:Label>



                                <div class="row gy-2 overflow-hidden">
                                    <div class="col-12">
                                        <div class="form-floating mb-2">
                                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="SingleLine" placeholder="name@example.com" required="required" />
                                            <label for="txtEmail" class="form-label" autocompletetype="Disabled">Username</label>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <div class="form-floating mb-2">
                                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password" required="required" />
                                            <label for="txtPassword" class="form-label">Password</label>
                                        </div>
                                    </div>
                                    <%--<div class="col-12">
                                        <div class="d-flex gap-2 justify-content-between">
                                            <div class="form-check">
                                                <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                                                <label class="form-check-label text-secondary" for="chkRememberMe">Keep me logged in</label>
                                            </div>
                                            <a href="#" class="link-primary text-decoration-none">Forgot password?</a>
                                        </div>
                                    </div>--%>
                                    <div class="col-12">
                                        <div class="d-flex gap-2 justify-content-end">
                                            <%--<div class="form-check">
                                                <asp:CheckBox ID="chkRememberMe" runat="server" CssClass="form-check-input" />
                                                <label class="form-check-label text-secondary" for="chkRememberMe">Keep me logged in</label>
                                            </div>--%>
                                            <a href="#" class="link-primary text-decoration-none">Forgot password?</a>
                                        </div>
                                    </div>
                                    <div class="col-12">
                                        <div class="d-grid my-3">
                                            <asp:Button ID="btnLogin" runat="server" Text="Log in" CssClass="btn btn-primary btn-lg" OnClick="btnLogin_Click" />
                                        </div>
                                    </div>
                                    <%--<div class="col-12">
                                        <p class="m-0 text-secondary text-center">
                                            Don't have an account? <a href="#" class="link-primary text-decoration-none">Sign up</a>
                                        </p>
                                    </div>--%>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </form>
</body>
</html>
