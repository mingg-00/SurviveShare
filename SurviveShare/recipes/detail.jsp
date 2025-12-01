<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="com.surviveshare.dao.RecipeDAO,com.surviveshare.model.Recipe" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String idParam = request.getParameter("id");
    Recipe recipe = null;
    if (idParam != null) {
        RecipeDAO dao = new RecipeDAO();
        recipe = dao.findById(Integer.parseInt(idParam));
    }
    if (recipe == null) {
        response.sendRedirect("list.jsp");
        return;
    }
    
    // 가격 태그 결정
    String priceTag = "";
    String priceTagClass = "";
    if (recipe.getPrice() != null) {
        double price = recipe.getPrice();
        if (price <= 1000) {
            priceTag = "1,000원 이하";
            priceTagClass = "price-tag-1000";
        } else if (price <= 5000) {
            priceTag = "5,000원 이하";
            priceTagClass = "price-tag-5000";
        } else if (price <= 10000) {
            priceTag = "10,000원 이하";
            priceTagClass = "price-tag-10000";
        } else if (price <= 30000) {
            priceTag = "30,000원 이하";
            priceTagClass = "price-tag-30000";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>${recipe.name} - SurviveShare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .recipe-detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .recipe-header-info {
            margin-bottom: 40px;
        }
        .recipe-image {
            width: 100%;
            height: auto;
            max-height: 600px;
            object-fit: cover;
            border-radius: 10px;
        }
        .recipe-info-card {
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: 100%;
        }
        .recipe-title-section {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 20px;
        }
        .recipe-title {
            font-size: 2.5em;
            font-weight: bold;
            color: #0018A8;
            margin: 0;
        }
        .price-tag {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
        }
        .price-tag-1000 {
            background-color: #e7f3ff;
            color: #004085;
        }
        .price-tag-5000 {
            background-color: #d4edda;
            color: #155724;
        }
        .price-tag-10000 {
            background-color: #fff3cd;
            color: #856404;
        }
        .price-tag-30000 {
            background-color: #cce5ff;
            color: #004085;
        }
        .recipe-meta {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-bottom: 30px;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #666;
            font-size: 1.1em;
        }
        .meta-item i {
            color: #0018A8;
            font-size: 1.2em;
        }
        .ingredients-section {
            margin-top: 20px;
        }
        .section-title {
            color: #0018A8;
            font-size: 1.5em;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .ingredients-list {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }
        .ingredient-item {
            padding: 8px 0;
            border-bottom: 1px solid #dee2e6;
            font-size: 1.05em;
        }
        .ingredient-item:last-child {
            border-bottom: none;
        }
        .recipe-steps-section {
            margin-top: 40px;
        }
        .steps-container {
            margin-top: 20px;
        }
        .step-card {
            border-left: 5px solid #0018A8;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .step-card:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
        }
        .step-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        .step-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background-color: #0018A8;
            color: #fff;
            border-radius: 50%;
            font-weight: bold;
            font-size: 1.2em;
        }
        .step-title {
            font-size: 1.3em;
            font-weight: 600;
            color: #0018A8;
        }
        .step-content {
            font-size: 1.1em;
            line-height: 1.8;
            color: #333;
        }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <div class="recipe-detail-container">
        <div class="recipe-header-info">
            <div class="row">
                <!-- 왼쪽: 음식 사진 -->
                <div class="col-md-5 mb-4">
                    <%
                        String imagePath = recipe.getImagePath();
                        if (imagePath != null && !imagePath.isEmpty()) {
                            String fullImagePath = "../" + imagePath;
                            String recipeName = recipe.getName() != null ? recipe.getName() : "";
                            out.println("<img src=\"" + fullImagePath + "\" alt=\"" + recipeName + "\" class=\"recipe-image img-fluid rounded shadow\"/>");
                        } else {
                            out.println("<div class=\"recipe-image-placeholder\">이미지 없음</div>");
                        }
                    %>
                </div>
                
                <!-- 오른쪽: 음식 이름, 필요한 재료, 소요 시간 -->
                <div class="col-md-7 mb-4">
                    <div class="recipe-info-card">
                        <div class="recipe-title-section mb-3">
                            <h1 class="recipe-title"><%=recipe.getName() != null ? recipe.getName() : ""%></h1>
                            <% if (!priceTag.isEmpty()) { %>
                                <span class="price-tag <%= priceTagClass %>">
                                    <%= priceTag %>
                                </span>
                            <% } %>
                        </div>
                        
                        <div class="recipe-meta mb-4">
                            <div class="meta-item">
                                <i class="bi bi-clock"></i>
                                <span>소요 시간: <%=recipe.getTimeRequired()%>분</span>
                            </div>
                            <c:if test="${not empty recipe.price}">
                                <div class="meta-item">
                                    <i class="bi bi-currency-dollar"></i>
                                    <span>예상 비용: ₩<fmt:formatNumber value="${recipe.price}" pattern="#,###"/></span>
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="ingredients-section">
                            <h3 class="section-title">필요한 재료</h3>
                            <div class="ingredients-list">
                                <%
                                    String ingredients = recipe.getIngredients();
                                    if (ingredients != null) {
                                        String[] lines = ingredients.split("\n");
                                        for (String line : lines) {
                                            out.println("<div class=\"ingredient-item\">" + line.trim() + "</div>");
                                        }
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 아래: 조리 방법 단계별 -->
        <div class="recipe-steps-section">
            <h3 class="section-title mb-4">조리 방법</h3>
            <div class="steps-container">
                <%
                    java.util.List<com.surviveshare.model.RecipeStep> steps = recipe.getSteps();
                    if (steps != null && !steps.isEmpty()) {
                        for (com.surviveshare.model.RecipeStep step : steps) {
                            out.println("<div class=\"card step-card mb-3 shadow-sm\">");
                            out.println("<div class=\"card-body\">");
                            out.println("<div class=\"step-header\">");
                            out.println("<span class=\"step-badge\">" + step.getStepNumber() + "</span>");
                            out.println("<h5 class=\"step-title mb-0\">단계 " + step.getStepNumber() + "</h5>");
                            out.println("</div>");
                            out.println("<p class=\"step-content mt-3 mb-0\">");
                            out.println(step.getInstruction() != null ? step.getInstruction() : "");
                            out.println("</p>");
                            out.println("</div>");
                            out.println("</div>");
                        }
                    } else {
                        out.println("<div class=\"alert alert-info\">조리 방법이 등록되지 않았습니다.</div>");
                    }
                %>
            </div>
        </div>
        
        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
            <a href="list.jsp" class="btn btn-outline-primary">목록으로</a>
        </div>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>
