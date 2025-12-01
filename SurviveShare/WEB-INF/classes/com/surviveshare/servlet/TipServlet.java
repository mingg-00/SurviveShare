package com.surviveshare.servlet;

import com.surviveshare.dao.*;
import com.surviveshare.model.Tip;
import com.surviveshare.util.LevelCalculator;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "TipServlet", urlPatterns = "/TipServlet")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class TipServlet extends HttpServlet {

    private final TipDAO tipDAO = new TipDAO();
    private final SessionDAO sessionDAO = new SessionDAO();
    private final ItemDAO itemDAO = new ItemDAO();
    private final ChallengeDAO challengeDAO = new ChallengeDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession httpSession = request.getSession();
        String sessionId = getOrCreateSessionId(httpSession);

        Tip tip = new Tip();
        tip.setSessionId(sessionId);
        tip.setTitle(request.getParameter("title"));
        tip.setContent(request.getParameter("content"));
        tip.setHashtags(request.getParameter("hashtags"));

        // 이미지 업로드 처리
        Part image = request.getPart("image");
        if (image != null && image.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + image.getSubmittedFileName();
            String uploadDir = getServletContext().getRealPath("/uploads");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            image.write(uploadDir + File.separator + fileName);
            tip.setImagePath("uploads/" + fileName);
        }

        if (tipDAO.createTip(tip)) {
            updateLevelScore(sessionId);
            response.sendRedirect("tips/list.jsp?success=1");
        } else {
            response.sendRedirect("tips/write.jsp?error=1");
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
