<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.*, com.surviveshare.model.*, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    String sessionId = (String) session.getAttribute("session_id");
    SessionDAO sessionDAO = new SessionDAO();
    if (sessionId == null) {
        sessionId = UUID.randomUUID().toString();
        session.setAttribute("session_id", sessionId);
        sessionDAO.createSession(sessionId);
    }
    String contextPath = request.getContextPath();
    RentalDAO rentalDAO = new RentalDAO();
    List<Rental> myRequests = rentalDAO.getRentalsForBorrower(sessionId);
    java.time.format.DateTimeFormatter meetFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <title>내 요청 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=contextPath%>/assets/css/style.css"/>
    <style>
        .request-card {
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 16px;
            box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        }
        .status-pill {
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 0.85rem;
        }
        .status-pending { background: #fff4e6; color: #b35c00; }
        .status-accepted { background: #e6f4ea; color: #1b5e20; }
        .status-rejected { background: #fdecea; color: #c62828; }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="mb-1">내 요청 관리</h2>
            <p class="text-muted mb-0">내가 보낸 나눔 요청의 처리 상태를 확인하세요.</p>
        </div>
        <a class="btn btn-outline-primary" href="<%=contextPath%>/items/list.jsp">← 물품 목록으로</a>
    </div>

    <%
        if (myRequests.isEmpty()) {
    %>
    <div class="alert alert-info">아직 보낸 요청이 없습니다.</div>
    <%
        } else {
            for (Rental rent : myRequests) {
                String statusClass = "status-pending";
                String statusLabel = "대기중";
                if ("accepted".equalsIgnoreCase(rent.getStatus())) {
                    statusClass = "status-accepted";
                    statusLabel = "수락됨";
                } else if ("rejected".equalsIgnoreCase(rent.getStatus())) {
                    statusClass = "status-rejected";
                    statusLabel = "거절됨";
                }
    %>
    <div class="request-card">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <h5 class="mb-0"><%= rent.getItemName() != null ? rent.getItemName() : "알 수 없는 물품" %></h5>
            <span class="status-pill <%=statusClass%>"><%=statusLabel%></span>
        </div>
        <p class="mb-1"><small>요청일: <%= rent.getCreatedAt() != null ? rent.getCreatedAt().format(meetFormatter) : "-" %></small></p>
        <%
            if ("accepted".equalsIgnoreCase(rent.getStatus())) {
                String formattedTime = rent.getMeetTime() != null ? rent.getMeetTime().format(meetFormatter) : null;
                String place = rent.getMeetPlace();
                String successMessage;
                if (formattedTime != null && place != null && !place.isEmpty()) {
                    successMessage = String.format("수락됨! %s에 %s에서 만나세요!", formattedTime, place);
                } else if (formattedTime != null) {
                    successMessage = String.format("수락됨! %s에 만나세요!", formattedTime);
                } else if (place != null && !place.isEmpty()) {
                    successMessage = String.format("수락됨! %s에서 만나세요!", place);
                } else {
                    successMessage = "수락됨! 곧 만남 일정을 안내해 드릴게요.";
                }
        %>
        <p class="text-success mb-0"><%=successMessage%></p>
        <%
            } else if ("rejected".equalsIgnoreCase(rent.getStatus())) {
        %>
        <p class="text-danger mb-0">요청이 거절되었습니다.</p>
        <%
            } else {
        %>
        <p class="text-muted mb-0">요청이 확인되는 중입니다.</p>
        <%
            }
        %>
    </div>
    <%
            }
        }
    %>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>

