<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<!DOCTYPE html>
<html>
<head>
    <title>Register - SurviveShare</title>
    <link rel="stylesheet" href="assets/css/style.css"/>
    <script src="assets/js/validation.js" defer></script>
</head>
<body>
<jsp:include page="includes/header.jspf"/>
<main>
    <section class="card">
        <h2><fmt:message key="auth.register"/></h2>
        <form action="AuthServlet" method="post" onsubmit="return validateRegister(this);">
            <input type="hidden" name="action" value="register"/>
            <label><fmt:message key="auth.username"/>
                <input type="text" name="username" required>
            </label><br/>
            <label><fmt:message key="auth.password"/>
                <input type="password" name="password" required>
            </label><br/>
            <label><fmt:message key="auth.nickname"/>
                <input type="text" name="nickname" required>
            </label><br/>
            <button class="button" type="submit"><fmt:message key="auth.register"/></button>
        </form>
    </section>
</main>
<jsp:include page="includes/footer.jspf"/>
</body>
</html>
