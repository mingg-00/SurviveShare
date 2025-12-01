package com.surviveshare.servlet;

import com.surviveshare.dao.RentalDAO;
import com.surviveshare.dao.SessionDAO;
import com.surviveshare.model.Rental;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "RentalServlet", urlPatterns = "/RentalServlet")
public class RentalServlet extends HttpServlet {

    private final RentalDAO rentalDAO = new RentalDAO();
    private final SessionDAO sessionDAO = new SessionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession httpSession = request.getSession();
        String sessionId = getOrCreateSessionId(httpSession);

        String action = request.getParameter("action");
        if ("request".equals(action)) {
            handleRequest(request, response, sessionId);
        } else if ("update".equals(action)) {
            handleUpdate(request, response, sessionId);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response, String borrowerSession) throws IOException {
        Rental rental = new Rental();
        rental.setItemId(Integer.parseInt(request.getParameter("item_id")));
        rental.setOwnerSession(request.getParameter("owner_session"));
        rental.setBorrowerSession(borrowerSession);
        String itemName = request.getParameter("item_name");
        if (itemName == null) itemName = "";
        rental.setItemName(itemName);
        if (rentalDAO.createRental(rental)) {
            String redirectUrl = String.format("items/success_share.jsp?sessionId=%s&itemName=%s",
                    URLEncoder.encode(borrowerSession, StandardCharsets.UTF_8.name()),
                    URLEncoder.encode(itemName, StandardCharsets.UTF_8.name()));
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("items/detail.jsp?id=" + rental.getItemId() + "&error=1");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, String ownerSession) throws IOException {
        int rentalId = Integer.parseInt(request.getParameter("rental_id"));
        String status = request.getParameter("status");
        boolean updated = rentalDAO.updateStatus(rentalId, ownerSession, status);
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.isBlank()) {
            redirect = "user/session_info.jsp";
        }
        String statusParam = updated ? "updated=1" : "error=1";
        if (redirect.contains("?")) {
            redirect = redirect + "&" + statusParam;
        } else {
            redirect = redirect + "?" + statusParam;
        }
        response.sendRedirect(redirect);
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
}
