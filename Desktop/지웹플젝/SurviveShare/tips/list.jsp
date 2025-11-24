<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    com.surviveshare.dao.TipDAO dao = new com.surviveshare.dao.TipDAO();
    request.setAttribute("tips", dao.getRecentTips(20));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Tips</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <div style="display:flex; justify-content:space-between; align-items:center;">
            <h2><fmt:message key="tip.list"/></h2>
            <a class="button" href="write.jsp"><fmt:message key="tip.write"/></a>
        </div>
        <ul>
            <c:forEach items="${tips}" var="tip">
                <li><a href="detail.jsp?id=${tip.tipId}">${tip.title}</a></li>
            </c:forEach>
        </ul>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
