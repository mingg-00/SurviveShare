<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.ItemDAO,com.surviveshare.model.Item" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    String idParam = request.getParameter("id");
    Item item = null;
    if (idParam != null) {
        ItemDAO dao = new ItemDAO();
        item = dao.findById(Integer.parseInt(idParam));
    }
    if (item == null) {
        response.sendRedirect("list.jsp");
        return;
    }
    String cookieVal = idParam;
    javax.servlet.http.Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (javax.servlet.http.Cookie c : cookies) {
            if ("recentItems".equals(c.getName())) {
                cookieVal = c.getValue();
                if (!cookieVal.contains(idParam)) {
                    cookieVal = idParam + "," + c.getValue();
                }
            }
        }
    }
    javax.servlet.http.Cookie cookie = new javax.servlet.http.Cookie("recentItems", cookieVal);
    cookie.setMaxAge(60 * 60 * 24 * 7);
    response.addCookie(cookie);
%>
<!DOCTYPE html>
<html>
<head>
    <title>${item.name}</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <h2>${item.name}</h2>
        <c:if test="${not empty item.imagePath}">
            <img src="../${item.imagePath}" alt="${item.name}" width="200"/>
        </c:if>
        <p>${item.description}</p>
        <c:if test="${sessionScope.user != null}">
            <form action="../RentalServlet" method="post">
                <input type="hidden" name="action" value="request"/>
                <input type="hidden" name="item_id" value="${item.itemId}"/>
                <input type="hidden" name="owner_id" value="${item.userId}"/>
                <button class="button" type="submit"><fmt:message key="rental.request"/></button>
            </form>
        </c:if>
        <c:if test="${sessionScope.user == null}">
            <p><a href="../login.jsp"><fmt:message key="rental.needLogin"/></a></p>
        </c:if>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
