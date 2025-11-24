package com.surviveshare.util;

public class LevelCalculator {

    public static String resolveLevelName(int score) {
        if (score >= 41) return "Lv4 자취 신";
        if (score >= 21) return "Lv3 생활 장인";
        if (score >= 11) return "Lv2 알아서 산다";
        return "Lv1 생존 초보";
    }

    public static int nextThreshold(int score) {
        if (score >= 41) return 60;
        if (score >= 21) return 41;
        if (score >= 11) return 21;
        return 11;
    }
}
