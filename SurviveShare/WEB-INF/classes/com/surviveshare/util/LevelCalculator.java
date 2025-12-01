package com.surviveshare.util;

public class LevelCalculator {

    public static int calculateLevelScore(int tipsCount, int itemsCount, int challengeCount, int totalRecommend) {
        return (tipsCount * 2) + (itemsCount * 3) + (challengeCount * 5) + (totalRecommend * 1);
    }

    public static String getLevelName(int score) {
        if (score >= 51) return "Lv4 자취 신(神)";
        if (score >= 26) return "Lv3 생활 장인";
        if (score >= 11) return "Lv2 알아서 산다";
        return "Lv1 생존 초보";
    }

    public static int getLevelNumber(int score) {
        if (score >= 51) return 4;
        if (score >= 26) return 3;
        if (score >= 11) return 2;
        return 1;
    }

    public static int getNextThreshold(int score) {
        if (score < 11) return 11;
        if (score < 26) return 26;
        if (score < 51) return 51;
        return 100; // 최고 레벨
    }

    public static String getLevelIcon(int level) {
        switch (level) {
            case 4: return "👑";
            case 3: return "🔥";
            case 2: return "🐱";
            default: return "🍳";
        }
    }

    public static String getLevelColor(int level) {
        switch (level) {
            case 4: return "#FFD700"; // 금색
            case 3: return "#FF6B6B"; // 빨강
            case 2: return "#4ECDC4"; // 청록
            default: return "#95E1D3"; // 연두
        }
    }
}
