<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.surviveshare.dao.*, com.surviveshare.model.*, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    Tip tip = null;
    if (id != null) {
        TipDAO dao = new TipDAO();
        tip = dao.findById(Integer.parseInt(id));
    }
    if (tip == null) {
        response.sendRedirect("list.jsp");
        return;
    }
    request.setAttribute("tip", tip);
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
    <title><%=tip.getTitle() != null ? tip.getTitle() : ""%> - SurviveShare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .board-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }
        .board-header {
            border-bottom: 2px solid #dee2e6;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .board-title {
            font-size: 2rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 15px;
            word-break: break-word;
        }
        .board-meta {
            display: flex;
            align-items: center;
            gap: 20px;
            color: #6c757d;
            font-size: 0.9rem;
        }
        .board-meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .board-body {
            padding: 30px 0;
            min-height: 300px;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 20px;
        }
        .board-content {
            font-size: 1.1rem;
            line-height: 1.8;
            white-space: pre-wrap;
            word-break: break-word;
            color: #212529;
        }
        .board-image {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin: 20px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .board-hashtags {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }
        .hashtag {
            display: inline-block;
            padding: 5px 12px;
            margin: 5px 5px 5px 0;
            background-color: #e7f3ff;
            color: #004085;
            border-radius: 20px;
            font-size: 0.9rem;
            text-decoration: none;
        }
        .hashtag:hover {
            background-color: #cce5ff;
            color: #004085;
        }
        .board-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 0;
        }
        .recommend-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .recommend-count {
            font-size: 1.2rem;
            font-weight: 600;
            color: #0018A8;
        }
        .board-actions {
            display: flex;
            gap: 10px;
        }
        @media (max-width: 768px) {
            .board-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .board-footer {
                flex-direction: column;
                gap: 15px;
                align-items: stretch;
            }
            .board-actions {
                width: 100%;
            }
            .board-actions .btn {
                flex: 1;
            }
        }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <div class="board-container">
        <div class="card shadow-sm">
            <div class="card-body">
                <!-- 게시글 헤더 -->
                <div class="board-header">
                    <h1 class="board-title"><%=tip.getTitle() != null ? tip.getTitle() : ""%></h1>
                    <div class="board-meta">
                        <div class="board-meta-item">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-calendar" viewBox="0 0 16 16">
                                <path d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4H1z"/>
                            </svg>
                            <span>
                                <%
                                    if (tip.getCreatedAt() != null) {
                                        java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH:mm");
                                        out.print(tip.getCreatedAt().format(formatter));
                                    }
                                %>
                            </span>
                        </div>
                        <div class="board-meta-item">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person" viewBox="0 0 16 16">
                                <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm2-3a2 2 0 1 1-4 0 2 2 0 0 1 4 0zm4 8c0 1-1 1-1 1H3s-1 0-1-1 1-4 6-4 6 3 6 4zm-1-.004c-.001-.246-.154-.986-.832-1.664C11.516 10.68 10.289 10 8 10c-2.29 0-3.516.68-4.168 1.332-.678.678-.83 1.418-.832 1.664h10z"/>
                            </svg>
                            <span>세션: <%=tip.getSessionId() != null ? tip.getSessionId() : ""%></span>
                        </div>
                        <div class="board-meta-item">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-hand-thumbs-up" viewBox="0 0 16 16">
                                <path d="M8.864.046C7.908-.193 7.02.53 6.956 1.466c-.072 1.051-.23 2.016-.428 2.59-.125.36-.479 1.013-1.04 1.639-.557.623-1.282 1.178-2.131 1.41C2.685 7.288 2 7.87 2 8.5v3c0 .863.393 1.621 1 2.121V15a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1v-1.5a1 1 0 0 1 1-1h1a1 1 0 0 1 1 1V15a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1v-4.879c.607-.5 1-1.258 1-2.121v-3c0-.63-.685-1.212-1.357-1.415-.849-.232-1.574-.787-2.131-1.41-.561-.626-.915-1.279-1.04-1.639-.198-.574-.356-1.539-.428-2.59-.064-.936-.952-1.659-1.908-1.42zM11 7.5c0 .276-.895.5-2 .5s-2-.224-2-.5.895-.5 2-.5 2 .224 2 .5z"/>
                            </svg>
                            <span>추천 <%=tip.getRecommendCount()%></span>
                        </div>
                    </div>
                </div>

                <!-- 게시글 본문 -->
                <div class="board-body">
                    <%
                        if (tip.getImagePath() != null && !tip.getImagePath().isEmpty()) {
                            String storedPath = tip.getImagePath();
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
                            String tipImagePath = contextPath + "/" + encodedPath;
                            out.println("<img src=\"" + tipImagePath + "\" alt=\"" + (tip.getTitle() != null ? tip.getTitle().replace("\"", "&quot;") : "") + "\" class=\"board-image\"/>");
                        }
                    %>
                    <div class="board-content"><%=tip.getContent() != null ? tip.getContent().replace("\n", "<br/>") : ""%></div>
                    
                    <%
                        if (tip.getHashtags() != null && !tip.getHashtags().isEmpty()) {
                            out.println("<div class=\"board-hashtags\">");
                            String[] tags = tip.getHashtags().split("[, ]+");
                            for (String tag : tags) {
                                if (tag != null && !tag.trim().isEmpty()) {
                                    out.println("<a href=\"list.jsp?hashtag=" + java.net.URLEncoder.encode(tag.trim(), "UTF-8") + "\" class=\"hashtag\">#" + tag.trim() + "</a>");
                                }
                            }
                            out.println("</div>");
                        }
                    %>
                </div>

                <!-- 게시글 푸터 -->
                <div class="board-footer">
                    <div class="recommend-section">
                        <div class="recommend-count">👍 <%=tip.getRecommendCount()%></div>
                        <form action="<%=contextPath%>/RecommendServlet" method="post" style="margin: 0;">
                            <input type="hidden" name="tip_id" value="<%=tip.getTipId()%>"/>
                            <button class="btn btn-primary" type="submit">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-hand-thumbs-up" viewBox="0 0 16 16">
                                    <path d="M8.864.046C7.908-.193 7.02.53 6.956 1.466c-.072 1.051-.23 2.016-.428 2.59-.125.36-.479 1.013-1.04 1.639-.557.623-1.282 1.178-2.131 1.41C2.685 7.288 2 7.87 2 8.5v3c0 .863.393 1.621 1 2.121V15a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1v-1.5a1 1 0 0 1 1-1h1a1 1 0 0 1 1 1V15a1 1 0 0 0 1 1h1a1 1 0 0 0 1-1v-4.879c.607-.5 1-1.258 1-2.121v-3c0-.63-.685-1.212-1.357-1.415-.849-.232-1.574-.787-2.131-1.41-.561-.626-.915-1.279-1.04-1.639-.198-.574-.356-1.539-.428-2.59-.064-.936-.952-1.659-1.908-1.42zM11 7.5c0 .276-.895.5-2 .5s-2-.224-2-.5.895-.5 2-.5 2 .224 2 .5z"/>
                                </svg>
                                추천하기
                            </button>
                        </form>
                    </div>
                    <div class="board-actions">
                        <a href="list.jsp" class="btn btn-outline-secondary">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-list" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M2.5 12a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4a.5.5 0 0 1 .5-.5h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/>
                            </svg>
                            목록으로
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
