<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    String sessionId = request.getParameter("sessionId");
    String itemName = request.getParameter("itemName");
    if (sessionId == null || sessionId.isEmpty()) {
        sessionId = "알 수 없는 사용자";
    }
    if (itemName == null || itemName.isEmpty()) {
        itemName = "물품";
    }
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>나눔 요청 완료</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=contextPath%>/assets/css/style.css"/>
    <style>
        .share-success-card {
            max-width: 640px;
            margin: 40px auto;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(102, 126, 234, 0.25);
            background: linear-gradient(135deg, #f8f9ff 0%, #ffffff 100%);
            padding: 40px;
            text-align: center;
        }
        .share-success-card h1 {
            font-size: 1.8rem;
            margin-bottom: 20px;
            color: #4a4e69;
        }
        .share-success-card p {
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 30px;
        }
        .share-success-card .btn-group {
            display: flex;
            gap: 12px;
            justify-content: center;
        }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main class="container">
    <div class="share-success-card">
        <div class="mb-3">
            <span style="font-size:3rem;">🎉</span>
        </div>
        <h1><%=sessionId%>님의 <span style="color:#5a67d8;"><%=itemName%></span> 나눔 요청이 정상적으로 전달되었습니다!</h1>
        <p>물품 주인에게 요청 알림이 전달되었어요. 잠시 후 답장을 기다려 주세요.</p>
        <div class="btn-group">
            <a href="<%=contextPath%>/items/list.jsp" class="btn btn-primary px-4">다른 물품 보기</a>
            <a href="<%=contextPath%>/index.jsp" class="btn btn-outline-secondary px-4">홈으로 가기</a>
        </div>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>

