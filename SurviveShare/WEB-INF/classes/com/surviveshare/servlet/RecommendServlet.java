package com.surviveshare.servlet;

import com.surviveshare.dao.*;
import com.surviveshare.util.LevelCalculator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RecommendServlet", urlPatterns = "/RecommendServlet")
public class RecommendServlet extends HttpServlet {

    private final TipDAO tipDAO = new TipDAO();
    private final SessionDAO sessionDAO = new SessionDAO();
    private final ItemDAO itemDAO = new ItemDAO();
    private final ChallengeDAO challengeDAO = new ChallengeDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession httpSession = request.getSession();
        String sessionId = getOrCreateSessionId(httpSession);

        int tipId = Integer.parseInt(request.getParameter("tip_id"));
        if (tipDAO.addRecommendation(tipId, sessionId)) {
            // 추천한 사람의 세션 점수 업데이트 (추천받은 사람의 점수는 TipDAO에서 자동 업데이트)
            updateLevelScore(sessionId);
            response.sendRedirect("tips/detail.jsp?id=" + tipId + "&recommended=1");
        } else {
            response.sendRedirect("tips/detail.jsp?id=" + tipId + "&error=1");
        }
    }

    private String getOrCreateSessionId(HttpSession httpSession) {
        String sessionId = (String) httpSession.getAttribute("session_id");
        if (sessionId == null) {
            sessionId = java.util.UUID.randomUUID().toString();
            httpSession.setAttribute("session_id", sessionId);
            sessionDAO.createSession(sessionId);
        }
        return sessionId;
    }

    private void updateLevelScore(String sessionId) {
        int tipsCount = tipDAO.getTipCountBySession(sessionId);
        int itemsCount = itemDAO.getItemCountBySession(sessionId);
        int challengeCount = challengeDAO.getChallengeCountBySession(sessionId);
        int totalRecommend = tipDAO.getTotalRecommendCount(sessionId);
        int score = LevelCalculator.calculateLevelScore(tipsCount, itemsCount, challengeCount, totalRecommend);
        sessionDAO.updateLevelScore(sessionId, score);
    }
}



