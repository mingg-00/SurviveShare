package com.surviveshare.model;

import java.time.LocalDateTime;
import java.util.List;

public class Recipe {
    private int recipeId;
    private String sessionId;
    private String name;
    private String imagePath;
    private String ingredients;
    private int timeRequired;
    private Double price;
    private List<RecipeStep> steps;
    private LocalDateTime createdAt;

    public int getRecipeId() { return recipeId; }
    public void setRecipeId(int recipeId) { this.recipeId = recipeId; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getIngredients() { return ingredients; }
    public void setIngredients(String ingredients) { this.ingredients = ingredients; }

    public int getTimeRequired() { return timeRequired; }
    public void setTimeRequired(int timeRequired) { this.timeRequired = timeRequired; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public List<RecipeStep> getSteps() { return steps; }
    public void setSteps(List<RecipeStep> steps) { this.steps = steps; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

