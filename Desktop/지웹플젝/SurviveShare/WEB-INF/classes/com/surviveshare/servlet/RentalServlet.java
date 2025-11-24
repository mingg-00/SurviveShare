package com.surviveshare.servlet;

import com.surviveshare.dao.RentalDAO;
import com.surviveshare.dao.UserDAO;
import com.surviveshare.model.Rental;
import com.surviveshare.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "RentalServlet", urlPatterns = "/RentalServlet")
public class RentalServlet extends HttpServlet {

    private final RentalDAO rentalDAO = new RentalDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String action = request.getParameter("action");
        if ("request".equals(action)) {
            handleRequest(request, response, (User) session.getAttribute("user"));
        } else if ("update".equals(action)) {
            handleUpdate(request, response, (User) session.getAttribute("user"));
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response, User borrower) throws IOException {
        Rental rental = new Rental();
        rental.setItemId(Integer.parseInt(request.getParameter("item_id")));
        rental.setOwnerId(Integer.parseInt(request.getParameter("owner_id")));
        rental.setBorrowerId(borrower.getUserId());
        if (rentalDAO.createRental(rental)) {
            userDAO.updateLevelScore(borrower.getUserId(), -1);
            response.sendRedirect("items/detail.jsp?id=" + rental.getItemId() + "&requested=1");
        } else {
            response.sendRedirect("items/detail.jsp?id=" + rental.getItemId() + "&error=1");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User owner) throws IOException {
        int rentalId = Integer.parseInt(request.getParameter("rental_id"));
        String status = request.getParameter("status");
        rentalDAO.updateStatus(rentalId, status);
        if ("accepted".equals(status)) {
            userDAO.updateLevelScore(owner.getUserId(), 2);
        }
        response.sendRedirect("user/mypage.jsp?updated=1");
    }
}
