<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    // POST 요청 처리 지원
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    com.surviveshare.dao.ItemDAO itemDAO = new com.surviveshare.dao.ItemDAO();
    request.setAttribute("items", itemDAO.getAllItems());
    String contextPath = request.getContextPath();
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>공유 물품 - SurviveShare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
    <script>
        var CONTEXT_PATH = '<%=contextPath%>';
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebar-overlay');
            if (sidebar && overlay) {
                sidebar.classList.toggle('open');
                overlay.classList.toggle('show');
            }
        }
    </script>
    <style>
        .items-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 20px;
        }
        .item-card {
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }
        .item-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        .item-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .item-card-content {
            padding: 15px;
        }
        .item-card-title {
            font-size: 1.1em;
            font-weight: 600;
            margin: 0;
            color: #333;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold"><fmt:message key="items.heading"/></h1>
        </div>
    </div>
    <div class="page-header">
        <h2><fmt:message key="items.subheading"/></h2>
        <div class="d-flex gap-2 flex-wrap">
            <a class="btn btn-primary" href="upload.jsp"><fmt:message key="items.register"/></a>
            <a class="btn btn-outline-primary" href="manage_owner.jsp"><fmt:message key="items.manageOwner"/></a>
            <a class="btn btn-outline-secondary" href="manage_requests.jsp"><fmt:message key="items.manageRequests"/></a>
        </div>
    </div>
    <div class="items-grid">
        <c:forEach items="${items}" var="item">
            <div class="item-card" onclick="location.href='detail.jsp?id=${item.itemId}'">
                <c:choose>
                    <c:when test="${not empty item.imagePath}">
                        <c:url value='/${item.imagePath}' var='itemImageUrl'/>
                        <img src="${itemImageUrl}" alt="${item.name}"/>
                    </c:when>
                    <c:otherwise>
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='200'%3E%3Crect fill='%23ddd' width='300' height='200'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' dy='.3em' fill='%23999'%3E이미지 없음%3C/text%3E%3C/svg%3E" alt="No image"/>
                    </c:otherwise>
                </c:choose>
                <div class="item-card-content">
                    <c:set var="itemDisplayName" value="${item.name}"/>
                    <c:choose>
                        <c:when test="${item.name eq '에어프라이어'}">
                            <fmt:message key="items.catalog.airfryer" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '다리미판'}">
                            <fmt:message key="items.catalog.ironingBoard" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '청소기'}">
                            <fmt:message key="items.catalog.vacuum" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '전자레인지'}">
                            <fmt:message key="items.catalog.microwave" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '책상'}">
                            <fmt:message key="items.catalog.desk" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '의자'}">
                            <fmt:message key="items.catalog.chair" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '선풍기'}">
                            <fmt:message key="items.catalog.fan" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '전기포트'}">
                            <fmt:message key="items.catalog.kettle" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '옷걸이 50개'}">
                            <fmt:message key="items.catalog.hangers" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                        <c:when test="${item.name eq '행거'}">
                            <fmt:message key="items.catalog.rack" var="translatedName"/>
                            <c:if test="${not empty translatedName}">
                                <c:set var="itemDisplayName" value="${translatedName}"/>
                            </c:if>
                        </c:when>
                    </c:choose>
                    <h3 class="item-card-title">${itemDisplayName}</h3>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty items}">
            <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #999;">
                <fmt:message key="items.empty"/>
            </div>
        </c:if>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
