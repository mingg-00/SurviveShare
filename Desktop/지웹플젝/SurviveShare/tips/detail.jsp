<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.TipDAO,com.surviveshare.model.Tip" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    String id = request.getParameter("id");
    Tip tip = null;
    if (id != null) {
        TipDAO dao = new TipDAO();
        tip = dao.findById(Integer.parseInt(id));
    }
    if (tip == null) {
        response.sendRedirect("list.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>${tip.title}</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <h2>${tip.title}</h2>
        <p>${tip.content}</p>
        <a href="list.jsp"><fmt:message key="tip.back"/></a>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
