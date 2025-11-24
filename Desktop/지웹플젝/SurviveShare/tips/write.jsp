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
    <title>Write Tip</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
    <script src="../assets/js/validation.js" defer></script>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <h2><fmt:message key="tip.write"/></h2>
        <form action="../TipServlet" method="post" onsubmit="return validateTip(this)">
            <label><fmt:message key="tip.title"/>
                <input type="text" name="title" required>
            </label><br/>
            <label><fmt:message key="tip.content"/>
                <textarea name="content" required></textarea>
            </label><br/>
            <button class="button" type="submit"><fmt:message key="tip.save"/></button>
        </form>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
