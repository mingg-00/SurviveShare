package com.surviveshare.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LocaleServlet", urlPatterns = "/LocaleServlet")
public class LocaleServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lang = request.getParameter("lang");
        HttpSession session = request.getSession();
        session.setAttribute("lang", lang);
        String referer = request.getHeader("Referer");
        if (referer == null) {
            referer = "index.jsp";
        }
        response.sendRedirect(referer);
    }
}
