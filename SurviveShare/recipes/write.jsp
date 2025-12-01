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
    <title>레시피 등록 - SurviveShare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
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
        function addStep() {
            const container = document.getElementById('steps-container');
            const stepCount = container.children.length + 1;
            const stepDiv = document.createElement('div');
            stepDiv.className = 'input-group mb-2';
            stepDiv.innerHTML = `
                <input type="text" class="form-control" name="step_instruction" placeholder="단계 ${stepCount} 설명" required>
                <button class="btn btn-outline-danger" type="button" onclick="this.parentElement.remove()">삭제</button>
            `;
            container.appendChild(stepDiv);
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
            <h2 class="mb-4">레시피 등록</h2>
            <form action="<%=contextPath%>/RecipeServlet" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">세션 아이디</label>
                    <div class="form-control-plaintext" style="background-color: #f8f9fa; padding: 10px; border-radius: 5px;">
                        <%=sessionId%>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="name" class="form-label">음식 이름</label>
                    <input type="text" class="form-control" id="name" name="name" required>
                </div>
                <div class="mb-3">
                    <label for="ingredients" class="form-label">필요한 재료 (줄바꿈으로 구분)</label>
                    <textarea class="form-control" id="ingredients" name="ingredients" rows="5" required placeholder="예:&#10;계란 2개&#10;라면 1개&#10;물 500ml"></textarea>
                </div>
                <div class="mb-3">
                    <label for="time_required" class="form-label">소요 시간 (분)</label>
                    <input type="number" class="form-control" id="time_required" name="time_required" min="1" required>
                </div>
                <div class="mb-3">
                    <label for="price_tag" class="form-label">예상 비용 태그</label>
                    <select class="form-select" id="price_tag" name="price_tag" required>
                        <option value="">선택하세요</option>
                        <option value="1000">1,000원 이하</option>
                        <option value="5000">5,000원 이하</option>
                        <option value="10000">10,000원 이하</option>
                        <option value="30000">30,000원 이하</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="image" class="form-label">사진 업로드 (선택, JPG/PNG, 2MB 이하)</label>
                    <input type="file" class="form-control" id="image" name="image" accept="image/*">
                </div>
                <div class="mb-3">
                    <label class="form-label">조리 방법</label>
                    <button type="button" class="btn btn-success mb-3" onclick="addStep()">+ 단계 추가</button>
                    <div id="steps-container">
                        <div class="input-group mb-2">
                            <input type="text" class="form-control" name="step_instruction" placeholder="단계 1 설명" required>
                        </div>
                    </div>
                </div>
                <div class="d-grid gap-2">
                    <button class="btn btn-primary btn-lg" type="submit">레시피 등록</button>
                </div>
            </form>
        </div>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>

