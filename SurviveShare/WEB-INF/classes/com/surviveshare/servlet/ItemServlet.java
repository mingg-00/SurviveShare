package com.surviveshare.servlet;

import com.surviveshare.dao.*;
import com.surviveshare.model.Item;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

@WebServlet(name = "ItemServlet", urlPatterns = "/ItemServlet")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class ItemServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final SessionDAO sessionDAO = new SessionDAO();
    private final TipDAO tipDAO = new TipDAO();
    private final ChallengeDAO challengeDAO = new ChallengeDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession httpSession = request.getSession();
        String sessionId = getOrCreateSessionId(httpSession);

        Part image = request.getPart("image");
        String fileName = null;
        if (image != null && image.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + image.getSubmittedFileName();
            String uploadDir = getServletContext().getRealPath("/uploads");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            image.write(uploadDir + File.separator + fileName);
        }

        Item item = new Item();
        item.setSessionId(sessionId);
        item.setName(request.getParameter("name"));
        item.setDescription(request.getParameter("description"));
        item.setImagePath(fileName != null ? "uploads/" + fileName : null);
        String priceStr = request.getParameter("price");
        if (priceStr != null && !priceStr.isEmpty()) {
            try {
                item.setPrice(new java.math.BigDecimal(priceStr));
            } catch (NumberFormatException e) {
                item.setPrice(null);
            }
        }
        String meetTimeStr = request.getParameter("meet_time");
        if (meetTimeStr != null && !meetTimeStr.isBlank()) {
            try {
                item.setMeetTime(LocalDateTime.parse(meetTimeStr));
            } catch (DateTimeParseException e) {
                item.setMeetTime(null);
            }
        }
        String meetPlace = request.getParameter("meet_place");
        if (meetPlace != null && !meetPlace.isBlank()) {
            item.setMeetPlace(meetPlace.trim());
        }

        if (itemDAO.createItem(item)) {
            updateLevelScore(sessionId);
            response.sendRedirect("items/list.jsp?success=1");
        } else {
            response.sendRedirect("items/upload.jsp?error=1");
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
