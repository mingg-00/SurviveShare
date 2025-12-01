package com.surviveshare.dao;

import com.surviveshare.config.DBConnection;
import com.surviveshare.model.Recipe;
import com.surviveshare.model.RecipeStep;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RecipeDAO {

    public boolean createRecipe(Recipe recipe) {
        String sql = "INSERT INTO recipes(session_id, name, image_path, ingredients, time_required, price) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, recipe.getSessionId());
                ps.setString(2, recipe.getName());
                ps.setString(3, recipe.getImagePath());
                ps.setString(4, recipe.getIngredients());
                ps.setInt(5, recipe.getTimeRequired());
                if (recipe.getPrice() != null) {
                    ps.setDouble(6, recipe.getPrice());
                } else {
                    ps.setNull(6, java.sql.Types.DECIMAL);
                }
                ps.executeUpdate();
                
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int recipeId = rs.getInt(1);
                    // 단계 저장
                    if (recipe.getSteps() != null && !recipe.getSteps().isEmpty()) {
                        String stepSql = "INSERT INTO recipe_steps(recipe_id, step_number, instruction) VALUES (?, ?, ?)";
                        try (PreparedStatement stepPs = conn.prepareStatement(stepSql)) {
                            for (RecipeStep step : recipe.getSteps()) {
                                stepPs.setInt(1, recipeId);
                                stepPs.setInt(2, step.getStepNumber());
                                stepPs.setString(3, step.getInstruction());
                                stepPs.addBatch();
                            }
                            stepPs.executeBatch();
                        }
                    }
                    conn.commit();
                    return true;
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        return false;
    }

    public List<Recipe> getAllRecipes() {
        List<Recipe> recipes = new ArrayList<>();
        String sql = "SELECT * FROM recipes ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setCatalog("surviveshare");
            try (java.sql.Statement stmt = conn.createStatement()) {
                stmt.execute("SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci");
            }
            try (PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    recipes.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return recipes;
    }

    public Recipe findById(int recipeId) {
        String sql = "SELECT * FROM recipes WHERE recipe_id=?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setCatalog("surviveshare");
            try (java.sql.Statement stmt = conn.createStatement()) {
                stmt.execute("SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci");
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, recipeId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    Recipe recipe = mapRow(rs);
                    // 단계 가져오기
                    recipe.setSteps(getStepsByRecipeId(recipeId));
                    return recipe;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<RecipeStep> getStepsByRecipeId(int recipeId) {
        List<RecipeStep> steps = new ArrayList<>();
        String sql = "SELECT * FROM recipe_steps WHERE recipe_id=? ORDER BY step_number";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setCatalog("surviveshare");
            try (java.sql.Statement stmt = conn.createStatement()) {
                stmt.execute("SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci");
            }
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, recipeId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    RecipeStep step = new RecipeStep();
                    step.setStepId(rs.getInt("step_id"));
                    step.setRecipeId(rs.getInt("recipe_id"));
                    step.setStepNumber(rs.getInt("step_number"));
                    
                    // UTF-8로 직접 읽기
                    String instruction = rs.getString("instruction");
                    step.setInstruction(instruction);
                    steps.add(step);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return steps;
    }

    private Recipe mapRow(ResultSet rs) throws SQLException {
        Recipe recipe = new Recipe();
        recipe.setRecipeId(rs.getInt("recipe_id"));
        recipe.setSessionId(rs.getString("session_id"));
        
        // UTF-8 인코딩으로 직접 읽기
        String name = rs.getString("name");
        recipe.setName(name);
        
        String imagePath = rs.getString("image_path");
        recipe.setImagePath(imagePath);
        
        String ingredients = rs.getString("ingredients");
        recipe.setIngredients(ingredients);
        
        recipe.setTimeRequired(rs.getInt("time_required"));
        double priceValue = rs.getDouble("price");
        if (!rs.wasNull()) {
            recipe.setPrice(priceValue);
        }
        java.sql.Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            recipe.setCreatedAt(timestamp.toLocalDateTime());
        }
        return recipe;
    }
}

