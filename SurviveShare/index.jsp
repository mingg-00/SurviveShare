<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.*, com.surviveshare.model.*, com.surviveshare.util.LevelCalculator, java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang != null ? sessionScope.lang : 'ko'}"/>
<fmt:setBundle basename="i18n.messages"/>
<%
    // POST 요청 처리 지원
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    // 세션 ID 생성 또는 가져오기
    String sessionId = (String) session.getAttribute("session_id");
    SessionDAO sessionDAO = new SessionDAO();
    if (sessionId == null) {
        sessionId = UUID.randomUUID().toString();
        session.setAttribute("session_id", sessionId);
        sessionDAO.createSession(sessionId);
    }

    // 난이도 점수 계산
    TipDAO tipDAO = new TipDAO();
    ItemDAO itemDAO = new ItemDAO();
    ChallengeDAO challengeDAO = new ChallengeDAO();
    
    int tipsCount = tipDAO.getTipCountBySession(sessionId);
    int itemsCount = itemDAO.getItemCountBySession(sessionId);
    int challengeCount = challengeDAO.getChallengeCountBySession(sessionId);
    int totalRecommend = tipDAO.getTotalRecommendCount(sessionId);
    int levelScore = LevelCalculator.calculateLevelScore(tipsCount, itemsCount, challengeCount, totalRecommend);
    
    // DB에 점수 업데이트
    sessionDAO.updateLevelScore(sessionId, levelScore);
    
    // 레벨 정보
    String levelName = LevelCalculator.getLevelName(levelScore);
    int levelNumber = LevelCalculator.getLevelNumber(levelScore);
    String levelIcon = LevelCalculator.getLevelIcon(levelNumber);
    String levelColor = LevelCalculator.getLevelColor(levelNumber);
    int nextThreshold = LevelCalculator.getNextThreshold(levelScore);
    if (nextThreshold <= levelScore) {
        nextThreshold = levelScore + 5;
    }
    int nextDiff = Math.max(0, nextThreshold - levelScore);
    int levelProgressPercent = nextThreshold > 0
        ? Math.min(100, (int) Math.round((levelScore * 100.0) / nextThreshold))
        : 0;
    String safeLevelIcon = (levelIcon != null && !levelIcon.isEmpty()) ? levelIcon : "🙂";
    
    // 최근 꿀팁 10개
    java.util.List<Tip> recentTips = tipDAO.getRecentTips(10);
    if (recentTips == null) {
        recentTips = java.util.Collections.emptyList();
    }
    request.setAttribute("recentTips", recentTips);
    
    // 최근 물품 (캐러셀용 - 최대 10개)
    java.util.List<Item> recentItems = itemDAO.getRecentItems(10);
    if (recentItems == null) {
        recentItems = java.util.Collections.emptyList();
    }
    request.setAttribute("recentItems", recentItems);
    
    // 오늘의 챌린지
    String todayChallenge = challengeDAO.getRandomChallenge();
    request.setAttribute("todayChallenge", todayChallenge);
    String contextPath = request.getContextPath();
    
    // i18n 메시지 로드
    String lang = (String) session.getAttribute("lang");
    if (lang == null || lang.isEmpty()) {
        lang = "ko";
        session.setAttribute("lang", lang);
    }
    java.util.Locale locale;
    if ("jp".equals(lang)) {
        locale = new java.util.Locale("ja", "JP");
    } else {
        locale = new java.util.Locale(lang);
    }
    java.util.ResourceBundle messages = java.util.ResourceBundle.getBundle("i18n.messages", locale);
    request.setAttribute("messages", messages);
%>
<!DOCTYPE html>
<html>
<head>
    <title>SurviveShare</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
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
        // 캐러셀 자동 슬라이드 초기화
        document.addEventListener('DOMContentLoaded', function() {
            const carouselElement = document.querySelector('#carouselExampleCaptions');
            if (carouselElement) {
                const carousel = new bootstrap.Carousel(carouselElement, {
                    interval: 3000,
                    wrap: true,
                    pause: 'hover',
                    ride: 'carousel'
                });
            }
            
            // 챌린지 이미지 전환 버튼
            const challengeButtons = document.querySelectorAll('.challenge-btn');
            const challengeImage = document.getElementById('challengeImage');
            challengeButtons.forEach(function(btn) {
                btn.addEventListener('click', function() {
                    const imagePath = this.getAttribute('data-image');
                    if (challengeImage && imagePath) {
                        challengeImage.src = imagePath;
                    }
                    // 활성 버튼 스타일 업데이트
                    challengeButtons.forEach(function(b) {
                        b.classList.remove('active');
                    });
                    this.classList.add('active');
                });
            });
            // 첫 번째 버튼을 기본 활성화
            if (challengeButtons.length > 0) {
                challengeButtons[0].classList.add('active');
            }
        });
    </script>
    <style>
        .main-layout {
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 20px;
            margin-bottom: 20px;
            align-items: start;
        }
        .left-panel {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .level-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 25px;
            color: white;
            min-height: 300px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .level-icon-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            margin-bottom: 20px;
            border: 4px solid rgba(255,255,255,0.3);
        }
        .level-info-text {
            text-align: center;
            width: 100%;
        }
        .level-info-text h2 {
            margin: 10px 0;
            font-size: 1.8em;
        }
        .level-info-text .level-name {
            font-size: 1.3em;
            margin: 10px 0;
        }
        .level-gauge-vertical {
            width: 20px;
            height: 150px;
            background: rgba(255,255,255,0.3);
            border-radius: 10px;
            overflow: hidden;
            margin: 15px auto;
            position: relative;
        }
        .level-bar-vertical {
            width: 100%;
            background: white;
            position: absolute;
            bottom: 0;
            border-radius: 10px;
            transition: height 0.5s;
        }
        .challenge-card {
            background: transparent;
            border-radius: 15px;
            padding: 0;
            box-shadow: none;
            display: flex;
            flex-direction: column;
            position: relative;
        }
        .challenge-image-container {
            position: relative;
            width: 100%;
        }
        .challenge-image {
            width: 100%;
            height: auto;
            border-radius: 10px;
            object-fit: contain;
            display: block;
        }
        .challenge-buttons {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 10;
        }
        .challenge-btn.active {
            background-color: #dee2e6;
            color: #fff;
            border-color: #dee2e6;
        }
        .carousel-container {
            background: #fff;
            border-radius: 18px;
            padding: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            overflow: hidden;
            position: relative;
            display: flex;
            flex-direction: column;
            align-self: stretch;
            min-height: 100%;
        }
        #carouselExampleCaptions {
            width: 100%;
        }
        .carousel-inner {
            width: 100%;
            overflow: hidden;
            border-radius: 14px;
        }
        .carousel-item {
            width: 100%;
            display: none;
        }
        .carousel-item.active {
            display: block;
        }
        .carousel-item img {
            width: 100%;
            height: 640px;
            object-fit: cover;
            border-radius: 12px;
            transition: opacity 0.3s;
        }
        .carousel-item a:hover img {
            opacity: 0.9;
        }
        .carousel-caption {
            background: rgba(0, 0, 0, 0.6);
            border-radius: 12px;
            padding: 12px 16px;
            bottom: 18px;
            left: 18px;
            right: 18px;
        }
        .carousel-caption h5 {
            color: #fff;
            font-weight: 600;
            font-size: 1.2rem;
            margin-bottom: 6px;
        }
        .carousel-caption p {
            color: #fff;
            margin: 0;
            font-size: 0.95rem;
            line-height: 1.4;
        }
        .carousel-control-prev,
        .carousel-control-next {
            width: 50px;
            height: 50px;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.5);
            border-radius: 50%;
            opacity: 0.8;
        }
        .carousel-control-prev:hover,
        .carousel-control-next:hover {
            opacity: 1;
        }
        .carousel-control-prev {
            left: 10px;
        }
        .carousel-control-next {
            right: 10px;
        }
        .tips-board {
            background: #fff;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .tips-table {
            width: 100%;
            border-collapse: collapse;
        }
        .tips-table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
        }
        .tips-table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }
        .tips-table tr:hover {
            background: #f8f9fa;
        }
        .tips-table a {
            color: #333;
            text-decoration: none;
        }
        .tips-table a:hover {
            color: #667eea;
            text-decoration: underline;
        }
        .recommend-badge {
            background: #ff6b6b;
            color: white;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.85em;
            margin-left: 10px;
        }
    </style>
</head>
<body>
<jsp:include page="includes/header.jspf"/>
<main>
    <div class="main-layout">
        <!-- 왼쪽 패널: 레벨 게이지 + 챌린지 -->
        <div class="left-panel">
            <!-- 생활 난이도 게이지 -->
            <section class="level-card">
                <div class="level-icon-circle">
                    <%=safeLevelIcon%>
                </div>
                <div class="level-info-text">
                    <div class="level-name"><%=levelName%></div>

                    <p style="font-size:0.9em; opacity:0.9;"><fmt:message key="home.currentScoreText"/>: <strong><%=levelScore%></strong><fmt:message key="home.points"/></p>
                    <div class="level-gauge-vertical">
                        <div class="level-bar-vertical" style="height:<%=levelProgressPercent%>%; background:white;"></div>
                    </div>
                    <p style="font-size:0.85em; opacity:0.8;"><fmt:message key="home.nextLevelText"/><br/><strong><%=nextDiff%></strong><fmt:message key="home.points"/></p>
                </div>
            </section>
            
            <!-- 오늘의 챌린지 -->
            <section class="challenge-card">
                <div class="challenge-image-container">
                    <div class="btn-toolbar mb-3 challenge-buttons" role="toolbar" aria-label="Toolbar with button groups">
                        <div class="btn-group me-2" role="group" aria-label="First group">
                            <button type="button" class="btn btn-outline-secondary challenge-btn" data-image="<%=contextPath%>/uploads/Home_challenge1.png">1</button>
                            <button type="button" class="btn btn-outline-secondary challenge-btn" data-image="<%=contextPath%>/uploads/Home_challenge2%20copy.png">2</button>
                        </div>
                    </div>
                    <img id="challengeImage" src="<%=contextPath%>/uploads/Home_challenge1.png" alt="오늘의 챌린지" class="challenge-image">
                </div>
            </section>
        </div>
        
        <!-- 오른쪽 패널: 캐러셀 -->
        <section class="carousel-container">
            <h3 style="margin-top:0; margin-bottom:15px;"><fmt:message key="home.recentItemsTitle"/></h3>
            <%
                if (recentItems != null && !recentItems.isEmpty()) {
            %>
            <div id="carouselExampleCaptions" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3000" data-bs-pause="hover" data-bs-wrap="true">
                <div class="carousel-indicators">
                    <%
                        for (int i = 0; i < recentItems.size(); i++) {
                            String activeClass = (i == 0) ? "active" : "";
                            out.println("<button type=\"button\" data-bs-target=\"#carouselExampleCaptions\" data-bs-slide-to=\"" + i + "\" class=\"" + activeClass + "\" aria-current=\"" + (i == 0 ? "true" : "false") + "\" aria-label=\"Slide " + (i + 1) + "\"></button>");
                        }
                    %>
                </div>
                <div class="carousel-inner">
                    <%
                        int index = 0;
                        for (Item item : recentItems) {
                            String activeClass = (index == 0) ? "active" : "";
                            String imagePath = null;
                            if (item.getImagePath() != null && !item.getImagePath().isEmpty()) {
                                imagePath = item.getImagePath().trim();
                                // 이미지 경로 정규화
                                if (!imagePath.startsWith("http")) {
                                    // 이미 contextPath가 포함되어 있으면 제거
                                    if (imagePath.startsWith(contextPath)) {
                                        imagePath = imagePath.substring(contextPath.length());
                                    }
                                    // 앞의 / 제거 후 정규화
                                    if (imagePath.startsWith("/")) {
                                        imagePath = imagePath.substring(1);
                                    }
                                    // 최종 경로 생성
                                    if (!imagePath.isEmpty()) {
                                        imagePath = contextPath + "/" + imagePath;
                                    } else {
                                        imagePath = null;
                                    }
                                }
                            }
                            
                            String itemName = (item.getName() != null) ? item.getName().replace("\"", "&quot;") : "";
                            String itemDescription = (item.getDescription() != null && !item.getDescription().isEmpty()) 
                                ? item.getDescription().replace("\"", "&quot;") 
                                : "";
                            if (itemDescription.length() > 100) {
                                itemDescription = itemDescription.substring(0, 100) + "...";
                            }
                    %>
                    <div class="carousel-item <%=activeClass%>">
                        <a href="<%=contextPath%>/items/detail.jsp?id=<%=item.getItemId()%>" style="display: block; cursor: pointer;">
                        <%
                            if (imagePath != null) {
                        %>
                        <img src="<%=imagePath%>" class="d-block w-100" alt="<%=itemName%>">
                        <%
                            } else {
                        %>
                        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='800' height='400'%3E%3Crect fill='%23ddd' width='800' height='400'/%3E%3Ctext x='50%25' y='50%25' text-anchor='middle' dy='.3em' fill='%23999' font-size='24'%3E이미지 없음%3C/text%3E%3C/svg%3E" class="d-block w-100" alt="No image">
                        <%
                            }
                        %>
                        </a>
                        <div class="carousel-caption d-none d-md-block">
                            <h5><a href="<%=contextPath%>/items/detail.jsp?id=<%=item.getItemId()%>" style="color: #fff; text-decoration: none;"><%=itemName%></a></h5>
                            <%
                                if (!itemDescription.isEmpty()) {
                            %>
                            <p><%=itemDescription%></p>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <%
                            index++;
                        }
                    %>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
            <%
                } else {
                    java.util.ResourceBundle msgs = (java.util.ResourceBundle) request.getAttribute("messages");
            %>
            <div style="text-align: center; padding: 40px; color: #999;">
                <p><%=msgs.getString("home.noRecent")%></p>
            </div>
            <%
                }
            %>
        </section>
    </div>
    
    <!-- 최근 등록 물품 아래에 꿀팁 게시판 -->
    <section class="tips-board">
        <h3><fmt:message key="home.recentTips"/></h3>
        <table class="tips-table">
            <thead>
                <tr>
                    <th style="width:60px;"><fmt:message key="tips.table.number"/></th>
                    <th><fmt:message key="tips.table.title"/></th>
                    <th style="width:100px;"><fmt:message key="tips.table.recommend"/></th>
                    <th style="width:150px;"><fmt:message key="tips.table.date"/></th>
                </tr>
            </thead>
            <tbody>
                <%
                    // JSTL 대신 스크립틀릿으로 직접 출력
                    if (recentTips != null && !recentTips.isEmpty()) {
                        int idx = 1;
                        for (Tip tip : recentTips) {
                            out.println("<tr>");
                            out.println("<td>" + idx + "</td>");
                            out.println("<td><a href=\"tips/detail.jsp?id=" + tip.getTipId() + "\">" + 
                                (tip.getTitle() != null ? tip.getTitle().replace("\"", "&quot;") : "") + "</a></td>");
                            if (tip.getRecommendCount() > 0) {
                                out.println("<td><span class=\"recommend-badge\">👍 " + tip.getRecommendCount() + "</span></td>");
                            } else {
                                out.println("<td><span style=\"color:#999;\">-</span></td>");
                            }
                            if (tip.getCreatedAt() != null) {
                                out.println("<td style=\"color:#999; font-size:0.9em;\">" + 
                                    java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd").format(tip.getCreatedAt()) + "</td>");
                            } else {
                                out.println("<td style=\"color:#999; font-size:0.9em;\">-</td>");
                            }
                            out.println("</tr>");
                            idx++;
                        }
                    } else {
                        java.util.ResourceBundle msgs = (java.util.ResourceBundle) request.getAttribute("messages");
                        out.println("<tr><td colspan=\"4\" style=\"text-align:center; color:#999; padding:30px;\">" + msgs.getString("tips.table.noItems") + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </section>
</main>
<jsp:include page="includes/footer.jspf"/>
</body>
</html>