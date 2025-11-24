<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    com.surviveshare.dao.ItemDAO itemDAO = new com.surviveshare.dao.ItemDAO();
    request.setAttribute("items", itemDAO.getAllItems());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Items - SurviveShare</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <div style="display:flex; justify-content:space-between; align-items:center;">
            <h2><fmt:message key="item.list"/></h2>
            <a class="button" href="upload.jsp"><fmt:message key="item.upload"/></a>
        </div>
        <table class="table">
            <tr>
                <th><fmt:message key="item.name"/></th>
                <th><fmt:message key="item.description"/></th>
                <th></th>
            </tr>
            <c:forEach items="${items}" var="item">
                <tr>
                    <td>${item.name}</td>
                    <td>${item.description}</td>
                    <td><a href="detail.jsp?id=${item.itemId}"><fmt:message key="item.view"/></a></td>
                </tr>
            </c:forEach>
        </table>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
