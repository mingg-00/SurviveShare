package com.surviveshare.servlet;

import com.surviveshare.dao.TipDAO;
import com.surviveshare.dao.UserDAO;
import com.surviveshare.model.Tip;
import com.surviveshare.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "TipServlet", urlPatterns = "/TipServlet")
public class TipServlet extends HttpServlet {

    private final TipDAO tipDAO = new TipDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        Tip tip = new Tip();
        tip.setUserId(user.getUserId());
        tip.setTitle(request.getParameter("title"));
        tip.setContent(request.getParameter("content"));

        if (tipDAO.createTip(tip)) {
            userDAO.updateLevelScore(user.getUserId(), 1);
            response.sendRedirect("tips/list.jsp?success=1");
        } else {
            response.sendRedirect("tips/write.jsp?error=1");
        }
    }
}
