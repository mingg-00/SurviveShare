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
    <title>Upload Item</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
    <script src="../assets/js/validation.js" defer></script>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <h2><fmt:message key="item.upload"/></h2>
        <form action="../ItemServlet" method="post" enctype="multipart/form-data" onsubmit="return validateItem(this)">
            <label><fmt:message key="item.name"/>
                <input type="text" name="name" required>
            </label><br/>
            <label><fmt:message key="item.description"/>
                <textarea name="description" required></textarea>
            </label><br/>
            <label><fmt:message key="item.image"/>
                <input type="file" name="image" accept="image/*">
            </label><br/>
            <button class="button" type="submit"><fmt:message key="item.save"/></button>
        </form>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
