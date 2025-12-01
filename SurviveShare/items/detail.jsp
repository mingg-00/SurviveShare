<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.ItemDAO,com.surviveshare.model.Item" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    String idParam = request.getParameter("id");
    Item item = null;
    if (idParam != null) {
        ItemDAO dao = new ItemDAO();
        item = dao.findById(Integer.parseInt(idParam));
    }
    if (item == null) {
        response.sendRedirect("list.jsp");
        return;
    }
    request.setAttribute("item", item);
    String sessionId = (String) session.getAttribute("session_id");
    if (sessionId == null) {
        sessionId = java.util.UUID.randomUUID().toString();
        session.setAttribute("session_id", sessionId);
        com.surviveshare.dao.SessionDAO sessionDAO = new com.surviveshare.dao.SessionDAO();
        sessionDAO.createSession(sessionId);
    }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>${item.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=contextPath%>/assets/css/style.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var CONTEXT_PATH = '<%=contextPath%>';
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebar-overlay');
            if (sidebar && overlay) {
                sidebar.classList.toggle('open');
                overlay.classList.toggle('show');
            }
        }
    </script>
    <style>
        .item-detail-container {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 30px;
            margin-top: 20px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            padding: 20px;
        }
        .item-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .item-info {
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .item-title {
            font-size: 2em;
            margin: 0;
            color: #0018A8;
        }
        .item-description {
            font-size: 1.1em;
            line-height: 1.8;
            white-space: pre-wrap;
            color: #333;
        }
        .item-price {
            font-size: 1.5em;
            font-weight: bold;
            color: #0018A8;
        }
        .item-schedule {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 16px;
            background: #f8f9ff;
        }
        .item-schedule-title {
            font-weight: 600;
            margin-bottom: 8px;
            color: #4a4e69;
        }
        .item-schedule-detail {
            margin: 0;
            color: #333;
        }
        .rental-form {
            margin-top: 0;
        }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <div class="item-detail-container">
        <div>
            <%
                String imagePath = null;
                if (item.getImagePath() != null && !item.getImagePath().isEmpty()) {
                    String storedPath = item.getImagePath();
                    String encodedPath = storedPath;
                    int slashIndex = storedPath.lastIndexOf('/');
                    try {
                        if (slashIndex >= 0) {
                            String dir = storedPath.substring(0, slashIndex);
                            String filename = storedPath.substring(slashIndex + 1);
                            filename = java.net.URLEncoder.encode(filename, "UTF-8").replace("+", "%20");
                            encodedPath = dir + "/" + filename;
                        } else {
                            encodedPath = java.net.URLEncoder.encode(storedPath, "UTF-8").replace("+", "%20");
                        }
                    } catch (java.io.UnsupportedEncodingException ignore) {
                    }
                    imagePath = contextPath + "/" + encodedPath;
                }
                String itemName = (item.getName() != null) ? item.getName().replace("\"", "&quot;") : "";
                if (imagePath != null) {
            %>
            <img src="<%=imagePath%>" alt="<%=itemName%>" class="item-image"/>
            <%
                } else {
            %>
            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='400' height='400'%3E%3Crect fill='%23ddd' width='400' height='400'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' dy='.3em' fill='%23999'%3E이미지 없음%3C/text%3E%3C/svg%3E" alt="No image" class="item-image"/>
            <%
                }
            %>
        </div>
        <div class="item-info">
            <h2 class="item-title"><%=item.getName() != null ? item.getName() : ""%></h2>
            <div class="item-description"><%=item.getDescription() != null ? item.getDescription().replace("\n", "<br/>") : ""%></div>
            <%
                java.time.format.DateTimeFormatter meetFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                boolean hasMeetInfo = item.getMeetTime() != null || (item.getMeetPlace() != null && !item.getMeetPlace().isEmpty());
                if (hasMeetInfo) {
            %>
            <div class="item-schedule">
                <div class="item-schedule-title"><fmt:message key="item.meetInfo"/></div>
                <%
                    if (item.getMeetTime() != null) {
                %>
                <p class="item-schedule-detail">🕒 <fmt:message key="item.meetTime"/>: <%=item.getMeetTime().format(meetFormatter)%></p>
                <%
                    }
                    if (item.getMeetPlace() != null && !item.getMeetPlace().isEmpty()) {
                %>
                <p class="item-schedule-detail">📍 <fmt:message key="item.meetPlace"/>: <%=item.getMeetPlace()%></p>
                <%
                    }
                %>
            </div>
            <%
                }
            %>
            <div class="rental-form">
                <form action="<%=contextPath%>/RentalServlet" method="post">
                    <input type="hidden" name="action" value="request"/>
                    <input type="hidden" name="item_id" value="<%=item.getItemId()%>"/>
                    <input type="hidden" name="owner_session" value="<%=item.getSessionId()%>"/>
                    <input type="hidden" name="item_name" value="<%= item.getName() != null ? item.getName().replace("\"", "&quot;") : "" %>"/>
                    <button class="button" type="submit" style="font-size: 1.2em; padding: 15px 30px; width: 100%;">나눔 요청</button>
                </form>
            </div>
        </div>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
