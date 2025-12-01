<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.surviveshare.dao.*, java.util.*" %>
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
    
    ChallengeDAO challengeDAO = new ChallengeDAO();
    String todayChallenge = challengeDAO.getRandomChallenge();
    request.setAttribute("todayChallenge", todayChallenge);
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>오늘의 챌린지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=contextPath%>/assets/css/style.css"/>
</head>
<body>
<jsp:include page="../includes/header.jspf"/>
<main class="container py-4">
    <div class="row g-4">
        <div class="col-lg-8">
            <section class="card border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
                        <div>
                            <h2 class="mb-1">오늘의 챌린지</h2>
                            <p class="text-muted mb-0">인증하고 +5점을 획득하세요!</p>
                        </div>
                        <a href="ranking.jsp" class="btn btn-outline-primary px-4">
                            랭킹 보기
                        </a>
                    </div>
                    <c:if test="${param.success == '1'}">
                        <div class="alert alert-success" role="alert">
                            챌린지 완료! +5점이 적립되었습니다.
                        </div>
                    </c:if>
                    <c:if test="${param.error == '1'}">
                        <div class="alert alert-danger" role="alert">
                            챌린지 등록에 실패했습니다. 잠시 후 다시 시도해주세요.
                        </div>
                    </c:if>
                    <div class="bg-light rounded-4 p-4 mb-4">
                        <h3 class="h4 mb-2">${todayChallenge}</h3>
                        <p class="text-muted mb-0">도전 완료 시 5점을 획득할 수 있습니다.</p>
                    </div>
                    <form action="../ChallengeServlet" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="description" value="${todayChallenge}"/>
                        <div class="mb-3">
                            <label class="form-label">인증 사진 업로드 <span class="text-muted">(JPG/PNG, 2MB 이하)</span></label>
                            <input type="file" class="form-control" name="image" accept="image/*" required>
                        </div>
                        <button class="btn btn-primary w-100 py-2" type="submit">챌린지 완료하기</button>
                    </form>
                </div>
            </section>
        </div>
        <div class="col-lg-4">
            <section class="card border-0 shadow-sm h-100">
                <div class="card-body p-4">
                    <h5 class="card-title">참여 방법</h5>
                    <ul class="list-unstyled mt-3 mb-0">
                        <li class="d-flex gap-3 align-items-start mb-3">
                            <span class="badge bg-primary rounded-pill px-3 py-2">1</span>
                            <div>
                                <strong>오늘의 챌린지 확인</strong>
                                <p class="mb-0 text-muted small">상단 카드에서 오늘의 미션을 확인하세요.</p>
                            </div>
                        </li>
                        <li class="d-flex gap-3 align-items-start mb-3">
                            <span class="badge bg-primary rounded-pill px-3 py-2">2</span>
                            <div>
                                <strong>인증 사진 촬영</strong>
                                <p class="mb-0 text-muted small">챌린지를 수행한 모습을 사진으로 남겨주세요.</p>
                            </div>
                        </li>
                        <li class="d-flex gap-3 align-items-start mb-0">
                            <span class="badge bg-primary rounded-pill px-3 py-2">3</span>
                            <div>
                                <strong>사진 업로드 후 제출</strong>
                                <p class="mb-0 text-muted small">파일을 업로드하고 챌린지 완료하기 버튼을 누르면 끝!</p>
                            </div>
                        </li>
                    </ul>
                </div>
            </section>
        </div>
    </div>
</main>
<jsp:include page="../includes/footer.jspf"/>
</body>
</html>



