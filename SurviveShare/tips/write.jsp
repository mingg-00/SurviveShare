<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.*, java.util.*" %>
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
%>
<!DOCTYPE html>
<html>
<head>
    <title>꿀팁 작성 - SurviveShare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../assets/js/validation.js" defer></script>
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
        .upload-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .upload-card {
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <div class="upload-container">
        <div class="upload-card">
            <h2 class="mb-4"><fmt:message key="tip.write"/></h2>
            <form action="<%=contextPath%>/TipServlet" method="post" enctype="multipart/form-data" onsubmit="return validateTip(this)">
                <div class="mb-3">
                    <label class="form-label">세션 아이디</label>
                    <div class="form-control-plaintext" style="background-color: #f8f9fa; padding: 10px; border-radius: 5px;">
                        <%=sessionId%>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="title" class="form-label"><fmt:message key="tip.title"/></label>
                    <input type="text" class="form-control" id="title" name="title" required>
                </div>
                <div class="mb-3">
                    <label for="content" class="form-label"><fmt:message key="tip.content"/></label>
                    <textarea class="form-control" id="content" name="content" rows="10" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="image" class="form-label">사진 업로드 (선택, JPG/PNG, 2MB 이하)</label>
                    <input type="file" class="form-control" id="image" name="image" accept="image/*">
                </div>
                <div class="mb-3">
                    <label for="hashtags" class="form-label">해시태그 (쉼표로 구분)</label>
                    <input type="text" class="form-control" id="hashtags" name="hashtags" placeholder="예: 자취,요리,절약">
                </div>
                <div class="d-grid gap-2">
                    <button class="btn btn-primary btn-lg" type="submit"><fmt:message key="tip.save"/></button>
                </div>
            </form>
        </div>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
