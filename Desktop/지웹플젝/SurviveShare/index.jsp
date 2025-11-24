<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    Integer levelScore = (Integer) session.getAttribute("level_score");
    if (levelScore == null) {
        levelScore = 0;
    }
    int nextThreshold = com.surviveshare.util.LevelCalculator.nextThreshold(levelScore);
    request.setAttribute("levelName", com.surviveshare.util.LevelCalculator.resolveLevelName(levelScore));
    request.setAttribute("nextDiff", nextThreshold - levelScore);
%>
<!DOCTYPE html>
<html>
<head>
    <title>SurviveShare</title>
    <link rel="stylesheet" href="assets/css/style.css"/>
    <script src="assets/js/validation.js" defer></script>
</head>
<body>
<jsp:include page="includes/header.jspf"/>
<main>
    <section class="card">
        <h2><fmt:message key="home.level"/></h2>
        <c:set var="score" value="${sessionScope.level_score != null ? sessionScope.level_score : 0}"/>
        <c:set var="percent" value="${score * 100 / 40}"/>
        <div class="progress">
            <div class="progress-bar" style="width:${percent}%"></div>
        </div>
        <p><fmt:message key="home.currentScore"/>: ${score}</p>
        <p>${levelName} - <fmt:message key="home.currentScore"/> ${score}</p>
        <p><fmt:message key="home.nextLevel"/> ${nextDiff}</p>
    </section>

    <%
        com.surviveshare.dao.TipDAO tipDAO = new com.surviveshare.dao.TipDAO();
        request.setAttribute("recentTips", tipDAO.getRecentTips(5));
    %>
    <section class="card">
        <h3><fmt:message key="home.recentTips"/></h3>
        <ul>
            <c:forEach items="${recentTips}" var="tip">
                <li><a href="tips/detail.jsp?id=${tip.tipId}">${tip.title}</a></li>
            </c:forEach>
        </ul>
    </section>

    <section class="card">
        <h3><fmt:message key="home.recentItems"/></h3>
        <div class="recent-items">
            <c:if test="${not empty cookie.recentItems.value}">
                <c:forTokens items="${cookie.recentItems.value}" delims="," var="itemId">
                    <div class="recent-item">
                        <a href="items/detail.jsp?id=${itemId}"><fmt:message key="home.item"/> #${itemId}</a>
                    </div>
                </c:forTokens>
            </c:if>
            <c:if test="${empty cookie.recentItems.value}">
                <p><fmt:message key="home.noRecent"/></p>
            </c:if>
        </div>
    </section>
</main>
<jsp:include page="includes/footer.jspf"/>
</body>
</html>
