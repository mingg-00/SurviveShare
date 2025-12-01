<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<c:if test="${sessionScope.user == null}">
    <jsp:forward page="../login.jsp"/>
</c:if>
<%
    com.surviveshare.dao.RentalDAO rentalDAO = new com.surviveshare.dao.RentalDAO();
    com.surviveshare.model.User me = (com.surviveshare.model.User) session.getAttribute("user");
    request.setAttribute("borrowList", rentalDAO.getRentalsForBorrower(me.getUserId()));
    request.setAttribute("ownList", rentalDAO.getRentalsForOwner(me.getUserId()));
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Page</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <h2><fmt:message key="mypage.greeting"/> ${sessionScope.user.nickname}</h2>
        <p><fmt:message key="mypage.level"/>: ${sessionScope.level_score}</p>
        <form action="../AuthServlet" method="post">
            <input type="hidden" name="action" value="logout"/>
            <button class="button secondary" type="submit"><fmt:message key="auth.logout"/></button>
        </form>
    </section>
    <section class="card">
        <h3><fmt:message key="mypage.borrowing"/></h3>
        <table class="table">
            <tr><th>ID</th><th><fmt:message key="rental.status"/></th></tr>
            <c:forEach items="${borrowList}" var="r">
                <tr>
                    <td>${r.itemId}</td>
                    <td>${r.status}</td>
                </tr>
            </c:forEach>
        </table>
    </section>
    <section class="card">
        <h3><fmt:message key="mypage.requests"/></h3>
        <table class="table">
            <tr><th>ID</th><th><fmt:message key="rental.status"/></th><th></th></tr>
            <c:forEach items="${ownList}" var="r">
                <tr>
                    <td>${r.itemId}</td>
                    <td>${r.status}</td>
                    <td>
                        <c:if test="${r.status == 'pending'}">
                            <form action="../RentalServlet" method="post">
                                <input type="hidden" name="action" value="update"/>
                                <input type="hidden" name="rental_id" value="${r.rentalId}"/>
                                <button class="button" name="status" value="accepted">OK</button>
                                <button class="button secondary" name="status" value="rejected">No</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
