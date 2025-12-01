<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    // POST 요청 처리 지원
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String contextPath = request.getContextPath();
    java.util.List tips = null;
    try {
        com.surviveshare.dao.TipDAO dao = new com.surviveshare.dao.TipDAO();
        tips = dao.getRecentTips(15);
    } catch (Exception e) {
        e.printStackTrace();
        tips = new java.util.ArrayList();
    }
    if (tips == null) {
        tips = new java.util.ArrayList();
    }
    request.setAttribute("tips", tips);
%>
<!DOCTYPE html>
<html>
<head>
    <title>꿀팁 - SurviveShare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=contextPath%>/assets/css/style.css"/>
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
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .tips-list {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
        }
        .tip-item {
            padding: 20px;
            border-bottom: 1px solid #eee;
            transition: background 0.3s;
        }
        .tip-item:hover {
            background: #f8f9fa;
        }
        .tip-item:last-child {
            border-bottom: none;
        }
        .tip-title {
            font-size: 1.2em;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .tip-title a {
            color: #0018A8;
            text-decoration: none;
        }
        .tip-title a:hover {
            text-decoration: underline;
        }
        .tip-meta {
            display: flex;
            gap: 15px;
            color: #999;
            font-size: 0.9em;
        }
        .tip-hashtags {
            margin-top: 10px;
        }
        .tip-hashtags span {
            display: inline-block;
            background: #e3f2fd;
            color: #0018A8;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.85em;
            margin-right: 5px;
        }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<div class="p-5 mb-4 bg-body-tertiary rounded-3">
    <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold">꿀팁 공유</h1>
    </div>
</div>
<main style="padding: 20px; max-width: 1200px; margin: 0 auto;">
    <div class="page-header">
        <h2>꿀팁</h2>
        <a class="btn btn-primary" href="<%=contextPath%>/tips/write.jsp">새 글쓰기</a>
    </div>
    <div class="tips-list">
        <%
            if (tips != null && !tips.isEmpty()) {
                for (Object tipObj : tips) {
                    com.surviveshare.model.Tip tip = (com.surviveshare.model.Tip) tipObj;
                    out.println("<div class=\"tip-item\">");
                    out.println("<div class=\"tip-title\">");
                    out.println("<a href=\"" + contextPath + "/tips/detail.jsp?id=" + tip.getTipId() + "\">" + 
                        (tip.getTitle() != null ? tip.getTitle() : "") + "</a>");
                    out.println("</div>");
                    out.println("<div class=\"tip-meta\">");
                    out.println("<span>추천: " + tip.getRecommendCount() + "</span>");
                    if (tip.getCreatedAt() != null) {
                        out.println("<span>" + 
                            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd").format(tip.getCreatedAt()) + 
                            "</span>");
                    }
                    out.println("</div>");
                    if (tip.getHashtags() != null && !tip.getHashtags().isEmpty()) {
                        out.println("<div class=\"tip-hashtags\">");
                        String[] tags = tip.getHashtags().split(",");
                        for (String tag : tags) {
                            out.println("<span>#" + tag.trim() + "</span>");
                        }
                        out.println("</div>");
                    }
                    out.println("</div>");
                }
            }
        %>
        <c:if test="${empty tips}">
            <div style="text-align: center; padding: 40px; color: #999;">
                등록된 꿀팁이 없습니다.
            </div>
        </c:if>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
