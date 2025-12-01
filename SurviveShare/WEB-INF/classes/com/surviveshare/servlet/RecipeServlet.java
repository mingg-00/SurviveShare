package com.surviveshare.servlet;

import com.surviveshare.dao.*;
import com.surviveshare.model.Recipe;
import com.surviveshare.model.RecipeStep;

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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RecipeServlet", urlPatterns = "/RecipeServlet")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class RecipeServlet extends HttpServlet {

    private final RecipeDAO recipeDAO = new RecipeDAO();
    private final SessionDAO sessionDAO = new SessionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession httpSession = request.getSession();
        String sessionId = getOrCreateSessionId(httpSession);

        Recipe recipe = new Recipe();
        recipe.setSessionId(sessionId);
        recipe.setName(request.getParameter("name"));
        recipe.setIngredients(request.getParameter("ingredients"));
        try {
            recipe.setTimeRequired(Integer.parseInt(request.getParameter("time_required")));
        } catch (NumberFormatException e) {
            recipe.setTimeRequired(0);
        }
        // 가격 태그를 가격으로 변환
        try {
            String priceTag = request.getParameter("price_tag");
            if (priceTag != null && !priceTag.trim().isEmpty()) {
                recipe.setPrice(Double.parseDouble(priceTag));
            }
        } catch (NumberFormatException e) {
            recipe.setPrice(null);
        }

        // 이미지 업로드 처리
        Part image = request.getPart("image");
        if (image != null && image.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + image.getSubmittedFileName();
            String uploadDir = getServletContext().getRealPath("/uploads");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            image.write(uploadDir + File.separator + fileName);
            recipe.setImagePath("uploads/" + fileName);
        }

        // 조리 단계 처리
        List<RecipeStep> steps = new ArrayList<>();
        String[] instructions = request.getParameterValues("step_instruction");
        if (instructions != null) {
            for (int i = 0; i < instructions.length; i++) {
                if (instructions[i] != null && !instructions[i].trim().isEmpty()) {
                    RecipeStep step = new RecipeStep();
                    step.setStepNumber(i + 1);
                    step.setInstruction(instructions[i].trim());
                    steps.add(step);
                }
            }
        }
        recipe.setSteps(steps);

        if (recipeDAO.createRecipe(recipe)) {
            response.sendRedirect("recipes/list.jsp?success=1");
        } else {
            response.sendRedirect("recipes/write.jsp?error=1");
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
}

