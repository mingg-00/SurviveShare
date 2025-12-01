<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.*, com.surviveshare.util.LevelCalculator, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    // POST 요청 처리 지원
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    ChallengeDAO challengeDAO = new ChallengeDAO();
    List<ChallengeDAO.SessionRank> ranking = challengeDAO.getRanking(20);
    request.setAttribute("ranking", ranking);
    
    String mySessionId = (String) session.getAttribute("session_id");
    request.setAttribute("mySessionId", mySessionId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>랭킹</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <%
        String contextPath = request.getContextPath();
    %>
    <link rel="stylesheet" href="<%=contextPath%>/assets/css/style.css"/>
    <style>
        .rank-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 10px 0;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .rank-item.my-rank {
            background: #fff9c4;
            border: 2px solid #fdd835;
        }
        .rank-number {
            font-size: 1.5em;
            font-weight: bold;
            width: 50px;
            text-align: center;
        }
        .rank-number.top1 { color: #FFD700; }
        .rank-number.top2 { color: #C0C0C0; }
        .rank-number.top3 { color: #CD7F32; }
        .rank-medal {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            font-weight: 700;
            color: #fff;
        }
        .rank-medal.gold { background: linear-gradient(135deg,#f5c242,#f7a928); }
        .rank-medal.silver { background: linear-gradient(135deg,#cfd3db,#aeb4c2); }
        .rank-medal.bronze { background: linear-gradient(135deg,#c28b6c,#a16446); }
    </style>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main style="padding: 20px; max-width: 1200px; margin: 0 auto;">
    <section class="card border-0 shadow-sm" style="background: #fff; border-radius: 16px; padding: 24px;">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
            <div>
                <h2 class="mb-1">생활 난이도 랭킹</h2>
                <p class="text-muted mb-0">상위 20명의 생활 고수들을 만나보세요</p>
            </div>
            <a href="<%=contextPath%>/challenge/today.jsp"
               class="btn btn-primary px-4 py-2 shadow-sm"
               style="border-radius: 999px;">
                챌린지 참여하기
            </a>
        </div>
        <c:choose>
            <c:when test="${not empty ranking}">
                <table class="table" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background: #f5f5f5;">
                            <th style="padding: 10px; text-align: left;">순위</th>
                            <th style="padding: 10px; text-align: left;">세션 ID</th>
                            <th style="padding: 10px; text-align: left;">점수</th>
                            <th style="padding: 10px; text-align: left;">레벨</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${ranking}" var="rank">
                            <tr style="border-bottom: 1px solid #eee;" class="${rank.getSessionId() == mySessionId ? 'my-rank' : ''}">
                                <td style="padding: 10px;">
                                    <c:choose>
                                        <c:when test="${rank.getRank() == 1}">
                                            <span class="rank-medal gold">1</span>
                                        </c:when>
                                        <c:when test="${rank.getRank() == 2}">
                                            <span class="rank-medal silver">2</span>
                                        </c:when>
                                        <c:when test="${rank.getRank() == 3}">
                                            <span class="rank-medal bronze">3</span>
                                        </c:when>
                                        <c:otherwise>
                                            <strong>${rank.getRank()}</strong>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="padding: 10px;">${rank.getSessionId().substring(0, 8)}...</td>
                                <td style="padding: 10px;"><strong>${rank.getScore()}</strong>점</td>
                                <td style="padding: 10px;">${LevelCalculator.getLevelName(rank.getScore())}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 40px; color: #999;">
                    랭킹 데이터가 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>

