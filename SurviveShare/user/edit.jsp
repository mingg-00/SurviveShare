<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<c:if test="${sessionScope.user == null}">
    <jsp:forward page="../login.jsp"/>
</c:if>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <h2><fmt:message key="mypage.edit"/></h2>
        <form action="#" method="post">
            <label><fmt:message key="auth.nickname"/>
                <input type="text" value="${sessionScope.user.nickname}"/>
            </label>
        </form>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
