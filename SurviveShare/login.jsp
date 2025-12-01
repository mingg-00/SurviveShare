<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<!DOCTYPE html>
<html>
<head>
    <title>Login - SurviveShare</title>
    <link rel="stylesheet" href="assets/css/style.css"/>
</head>
<body>
<jsp:include page="includes/header.jspf"/>
<main>
    <section class="card">
        <h2><fmt:message key="auth.login"/></h2>
        <c:if test="${param.error == '1'}">
            <p class="alert"><fmt:message key="auth.loginFail"/></p>
        </c:if>
        <form action="AuthServlet" method="post">
            <input type="hidden" name="action" value="login"/>
            <label><fmt:message key="auth.username"/>
                <input type="text" name="username" required>
            </label><br/>
            <label><fmt:message key="auth.password"/>
                <input type="password" name="password" required>
            </label><br/>
            <button class="button" type="submit"><fmt:message key="auth.login"/></button>
            <a href="register.jsp"><fmt:message key="auth.needRegister"/></a>
        </form>
    </section>
</main>
<jsp:include page="includes/footer.jspf"/>
</body>
</html>
