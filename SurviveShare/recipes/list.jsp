<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    com.surviveshare.dao.RecipeDAO recipeDAO = new com.surviveshare.dao.RecipeDAO();
    request.setAttribute("recipes", recipeDAO.getAllRecipes());
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>레시피북 - SurviveShare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
    <script>
        var CONTEXT_PATH = '<%=contextPath%>';
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('sidebar-overlay');
            sidebar.classList.toggle('open');
                overlay.classList.toggle('show');
            }
    </script>
    <style>
        .recipes-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 20px;
        }
        .recipe-card {
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }
        .recipe-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        .recipe-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .recipe-card-content {
            padding: 15px;
        }
        .recipe-card-title {
            font-size: 1.1em;
            font-weight: 600;
            margin: 0;
            color: #333;
        }
        .price-badge {
            display: inline-block;
            margin-top: 8px;
            padding: 6px 12px;
            background-color: #667eea;
            color: #ffffff;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
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
                <h1 class="display-5 fw-bold">레시피 공유</h1>
            </div>
        </div>
    <div class="page-header">
        <h2>자취생들을 위한 레시피북</h2>
        <a class="btn btn-primary" href="write.jsp">레시피 등록</a>
    </div>
    <div class="recipes-grid">
        <%
            java.util.List<com.surviveshare.model.Recipe> recipesList = (java.util.List<com.surviveshare.model.Recipe>) request.getAttribute("recipes");
            if (recipesList != null && !recipesList.isEmpty()) {
                for (com.surviveshare.model.Recipe recipe : recipesList) {
                    out.println("<div class=\"recipe-card\" onclick=\"location.href='detail.jsp?id=" + recipe.getRecipeId() + "'\">");
                    
                    // 이미지 처리
                    String imagePath = null;
                    if (recipe.getImagePath() != null && !recipe.getImagePath().isEmpty()) {
                        imagePath = "../" + recipe.getImagePath();
                    }
                    if (imagePath != null) {
                        String recipeName = recipe.getName() != null ? recipe.getName().replace("\"", "&quot;") : "";
                        out.println("<img src=\"" + imagePath + "\" alt=\"" + recipeName + "\"/>");
                    } else {
                        out.println("<img src=\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='300' height='200'%3E%3Crect fill='%23ddd' width='300' height='200'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' dy='.3em' fill='%23999'%3E이미지 없음%3C/text%3E%3C/svg%3E\" alt=\"No image\"/>");
                    }
                    
                    out.println("<div class=\"recipe-card-content\">");
                    out.println("<h3 class=\"recipe-card-title\">" + (recipe.getName() != null ? recipe.getName() : "") + "</h3>");
                    
                    // 가격 표시 - 둥근 버튼 모양 태그
                    if (recipe.getPrice() != null) {
                        java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");
                        out.println("<span class=\"price-badge\">₩" + df.format(recipe.getPrice()) + "원 이하</span>");
                    }
                    
                    out.println("</div>");
                    out.println("</div>");
                }
            } else {
                out.println("<div style=\"grid-column: 1 / -1; text-align: center; padding: 40px; color: #999;\">");
                out.println("등록된 레시피가 없습니다.");
                out.println("</div>");
            }
        %>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>