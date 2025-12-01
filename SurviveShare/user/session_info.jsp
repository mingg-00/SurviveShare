<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.*, com.surviveshare.util.LevelCalculator, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    String sessionId = (String) session.getAttribute("session_id");
    SessionDAO sessionDAO = new SessionDAO();
    if (sessionId == null) {
        sessionId = UUID.randomUUID().toString();
        session.setAttribute("session_id", sessionId);
        sessionDAO.createSession(sessionId);
    }
    
    TipDAO tipDAO = new TipDAO();
    ItemDAO itemDAO = new ItemDAO();
    ChallengeDAO challengeDAO = new ChallengeDAO();
    RentalDAO rentalDAO = new RentalDAO();
    
    int tipsCount = tipDAO.getTipCountBySession(sessionId);
    int itemsCount = itemDAO.getItemCountBySession(sessionId);
    int challengeCount = challengeDAO.getChallengeCountBySession(sessionId);
    int totalRecommend = tipDAO.getTotalRecommendCount(sessionId);
    int levelScore = LevelCalculator.calculateLevelScore(tipsCount, itemsCount, challengeCount, totalRecommend);
    
    String levelName = LevelCalculator.getLevelName(levelScore);
    int levelNumber = LevelCalculator.getLevelNumber(levelScore);
    String levelIcon = LevelCalculator.getLevelIcon(levelNumber);
    String levelColor = LevelCalculator.getLevelColor(levelNumber);
    int nextThreshold = LevelCalculator.getNextThreshold(levelScore);
    
    List<Rental> borrowList = rentalDAO.getRentalsForBorrower(sessionId);
    List<Rental> ownList = rentalDAO.getRentalsForOwner(sessionId);
    request.setAttribute("borrowList", borrowList);
    request.setAttribute("ownList", ownList);
%>
<!DOCTYPE html>
<html>
<head>
    <title>내 활동</title>
    <link rel="stylesheet" href="../assets/css/style.css"/>
    <style>
        .level-gauge {
            width: 100%;
            background: #e1e1e1;
            border-radius: 10px;
            height: 30px;
            overflow: hidden;
            margin: 10px 0;
        }
        .level-bar {
            height: 30px;
            border-radius: 10px;
            transition: width 0.3s;
        }
        .stat-box {
            display: flex;
            gap: 20px;
            margin: 20px 0;
        }
        .stat-item {
            flex: 1;
            padding: 15px;
            background: #f9f9f9;
            border-radius: 8px;
            text-align: center;
        }
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #0083b0;
        }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main>
    <section class="card">
        <h2>내 활동 정보</h2>
        <div class="level-info">
            <span class="level-icon" style="font-size:3em;"><%=levelIcon%></span>
            <div style="flex: 1;">
                <h3><%=levelName%></h3>
                <p>현재 점수: <strong><%=levelScore%></strong>점</p>
                <div class="level-gauge">
                    <div class="level-bar" style="width:<%=Math.min(100, (levelScore * 100 / nextThreshold))%>%; background:<%=levelColor%>;"></div>
                </div>
            </div>
        </div>
        
        <div class="stat-box">
            <div class="stat-item">
                <div class="stat-number"><%=tipsCount%></div>
                <div>꿀팁 작성</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%=itemsCount%></div>
                <div>물품 공유</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%=challengeCount%></div>
                <div>챌린지 완료</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%=totalRecommend%></div>
                <div>받은 추천</div>
            </div>
        </div>
    </section>
    
    <section class="card">
        <h3>내가 빌린 물건</h3>
        <table class="table">
            <tr><th>물품 ID</th><th>상태</th></tr>
            <c:forEach items="${borrowList}" var="r">
                <tr>
                    <td>${r.itemId}</td>
                    <td>${r.status}</td>
                </tr>
            </c:forEach>
        </table>
    </section>
    
    <section class="card">
        <h3>내 물품 대여 요청</h3>
        <table class="table">
            <tr><th>물품 ID</th><th>상태</th><th>처리</th></tr>
            <c:forEach items="${ownList}" var="r">
                <tr>
                    <td>${r.itemId}</td>
                    <td>${r.status}</td>
                    <td>
                        <c:if test="${r.status == 'pending'}">
                            <form action="../RentalServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="update"/>
                                <input type="hidden" name="rental_id" value="${r.rentalId}"/>
                                <button class="button" name="status" value="accepted">승인</button>
                                <button class="button secondary" name="status" value="rejected">거절</button>
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



