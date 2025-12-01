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
    ItemDAO itemDAO = new ItemDAO();
    RentalDAO rentalDAO = new RentalDAO();
    List<Item> myItems = itemDAO.getItemsBySession(sessionId);
    java.time.format.DateTimeFormatter meetFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    String updated = request.getParameter("updated");
    String updateError = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>내 물품 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=contextPath%>/assets/css/style.css"/>
    <style>
        .owner-item-card {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 20px;
            background: #fff;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
            margin-bottom: 24px;
        }
        .owner-item-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 12px;
        }
        .request-pill {
            border: 1px solid #e5e7f1;
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 12px;
            background: #f7f8ff;
        }
        .request-pill.pending { border-color: #ffd166; background: #fff7e6; }
        .request-pill.accepted { border-color: #4caf50; background: #e8f5e9; }
        .request-pill.rejected { border-color: #e57373; background: #fdecea; }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-3">
        <div>
            <h2 class="mb-1">내 물품 관리</h2>
            <p class="text-muted mb-0">등록한 물품과 들어온 나눔 요청을 여기에서 확인하고 처리하세요.</p>
        </div>
        <a class="btn btn-outline-primary" href="<%=contextPath%>/items/list.jsp">← 물품 목록으로</a>
    </div>

    <c:if test="${not empty param.updated}">
        <div class="alert alert-success">요청 상태가 업데이트되었습니다.</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">요청을 처리하지 못했습니다. 잠시 후 다시 시도해 주세요.</div>
    </c:if>

    <%
        if (myItems.isEmpty()) {
    %>
    <div class="alert alert-info">등록된 물품이 아직 없습니다. 먼저 물품을 등록해 주세요.</div>
    <%
        } else {
            for (Item ownerItem : myItems) {
                List<Rental> requests = rentalDAO.getRentalsByItem(ownerItem.getItemId());
    %>
    <div class="owner-item-card">
        <div>
            <%
                String imagePath = ownerItem.getImagePath() != null ? "../" + ownerItem.getImagePath() : null;
                if (imagePath != null) {
            %>
                <img src="<%=imagePath%>" alt="<%=ownerItem.getName()%>">
            <%
                } else {
            %>
                <img src="https://via.placeholder.com/280x200?text=No+Image" alt="no image">
            <%
                }
            %>
        </div>
        <div>
            <h4><%=ownerItem.getName()%></h4>
            <p class="text-muted mb-2"><%=ownerItem.getDescription()%></p>
            <%
                boolean hasMeetInfo = ownerItem.getMeetTime() != null ||
                        (ownerItem.getMeetPlace() != null && !ownerItem.getMeetPlace().isEmpty());
                if (hasMeetInfo) {
            %>
            <div class="mb-3 p-3 bg-light rounded">
                <strong>만남 정보</strong><br/>
                <%
                    if (ownerItem.getMeetTime() != null) {
                %>
                🕒 <%=ownerItem.getMeetTime().format(meetFormatter)%><br/>
                <%
                    }
                    if (ownerItem.getMeetPlace() != null && !ownerItem.getMeetPlace().isEmpty()) {
                %>
                📍 <%=ownerItem.getMeetPlace()%>
                <%
                    }
                %>
            </div>
            <%
                }
            %>
            <h5 class="mt-3">받은 나눔 요청</h5>
            <%
                if (requests.isEmpty()) {
            %>
                <div class="text-muted">아직 요청이 없습니다.</div>
            <%
                } else {
                    for (Rental rent : requests) {
                        String status = rent.getStatus() != null ? rent.getStatus().toLowerCase() : "pending";
                        String pillClass = "pending";
                        String statusLabel = "대기중";
                        if ("accepted".equals(status)) {
                            pillClass = "accepted";
                            statusLabel = "수락됨";
                        } else if ("rejected".equals(status)) {
                            pillClass = "rejected";
                            statusLabel = "거절됨";
                        }
            %>
                <div class="request-pill <%=pillClass%>">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                        <div>
                            <strong>요청자:</strong> <%=rent.getBorrowerSession()%><br/>
                            <small class="text-muted">요청일: <%=rent.getCreatedAt() != null ? rent.getCreatedAt().format(meetFormatter) : "-" %></small>
                        </div>
                        <div>
                            <span class="badge bg-light text-dark"><%=statusLabel%></span>
                        </div>
                    </div>
                    <%
                        if ("pending".equals(status)) {
                    %>
                    <div class="d-flex gap-2 mt-3">
                        <form method="post" action="<%=contextPath%>/RentalServlet" class="m-0">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="rental_id" value="<%=rent.getRentalId()%>">
                            <input type="hidden" name="status" value="accepted">
                            <input type="hidden" name="redirect" value="items/manage_owner.jsp">
                            <button class="btn btn-sm btn-success" type="submit">수락</button>
                        </form>
                        <form method="post" action="<%=contextPath%>/RentalServlet" class="m-0">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="rental_id" value="<%=rent.getRentalId()%>">
                            <input type="hidden" name="status" value="rejected">
                            <input type="hidden" name="redirect" value="items/manage_owner.jsp">
                            <button class="btn btn-sm btn-outline-danger" type="submit">거절</button>
                        </form>
                    </div>
                    <%
                        } else if ("accepted".equals(status)) {
                    %>
                    <p class="text-success mt-3 mb-0">나눔이 확정되었습니다.</p>
                    <%
                        } else if ("rejected".equals(status)) {
                    %>
                    <p class="text-danger mt-3 mb-0">요청을 거절했습니다.</p>
                    <%
                        }
                    %>
                </div>
            <%
                    }
                }
            %>
        </div>
    </div>
    <%
            }
        }
    %>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>

