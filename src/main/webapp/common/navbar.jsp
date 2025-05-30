<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String username = (String) session.getAttribute("username"); %>
<% boolean isLoggedIn = (username != null); %>
<style>
    .user-avatar {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background-color: #28a745;
        color: white;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-right: 5px;
        font-weight: bold;
        font-size: 1rem;
    }
    /* 防止内容被导航栏遮挡 */
    body {
        padding-top: 70px;
    }
</style>
<nav class="navbar navbar-expand-lg navbar-dark bg-danger fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/index.jsp">
            <i class="fas fa-hands-helping me-2"></i>志愿者服务平台
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link <%if("index.jsp".equals(request.getServletPath().substring(request.getServletPath().lastIndexOf("/")+1))) {%>active<%}%>" href="<%= request.getContextPath() %>/index.jsp">首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%if("project_list.jsp".equals(request.getServletPath().substring(request.getServletPath().lastIndexOf("/")+1))) {%>active<%}%>" href="<%= request.getContextPath() %>/project_list.jsp">志愿项目</a>
                </li>
                <% if (isLoggedIn) { %>
                <li class="nav-item">
                    <a class="nav-link <%if("volunteer_center.jsp".equals(request.getServletPath().substring(request.getServletPath().lastIndexOf("/")+1))) {%>active<%}%>" href="<%= request.getContextPath() %>/volunteer_center.jsp">个人中心</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown"
                       role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <div class="user-avatar">
                            <%= username.substring(0, 1).toUpperCase() %>
                        </div>
                        <span class="ms-1"><%= username %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end"
                        aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/volunteer_center.jsp"><i
                                class="fas fa-user me-2"></i>个人资料</a></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/project_list.jsp"><i
                                class="fas fa-list-alt me-2"></i>我的项目</a></li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item text-danger" href="<%= request.getContextPath() %>/logout.jsp"><i
                                class="fas fa-sign-out-alt me-2"></i>退出登录</a></li>
                    </ul>
                </li>
                <% } else { %>
                <li class="nav-item">
                    <a class="nav-link <%if("login.jsp".equals(request.getServletPath().substring(request.getServletPath().lastIndexOf("/")+1))) {%>active<%}%>" href="<%= request.getContextPath() %>/login.jsp">登录</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%if("register.jsp".equals(request.getServletPath().substring(request.getServletPath().lastIndexOf("/")+1))) {%>active<%}%>" href="<%= request.getContextPath() %>/register.jsp">注册</a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
