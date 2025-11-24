package com.surviveshare.servlet;

import com.surviveshare.dao.ItemDAO;
import com.surviveshare.dao.UserDAO;
import com.surviveshare.model.Item;
import com.surviveshare.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet(name = "ItemServlet", urlPatterns = "/ItemServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ItemServlet extends HttpServlet {

    private final ItemDAO itemDAO = new ItemDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        Part image = request.getPart("image");
        String fileName = image != null ? System.currentTimeMillis() + "_" + image.getSubmittedFileName() : null;
        if (image != null && fileName != null && !fileName.isEmpty()) {
            String uploadDir = getServletContext().getRealPath("/uploads");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            image.write(uploadDir + File.separator + fileName);
        }
        Item item = new Item();
        item.setUserId(user.getUserId());
        item.setName(request.getParameter("name"));
        item.setDescription(request.getParameter("description"));
        item.setImagePath(fileName != null ? "uploads/" + fileName : null);

        if (itemDAO.createItem(item)) {
            userDAO.updateLevelScore(user.getUserId(), 2);
            response.sendRedirect("items/list.jsp?success=1");
        } else {
            response.sendRedirect("items/upload.jsp?error=1");
        }
    }
}
