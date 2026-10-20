package com.cinema.model;

import java.sql.Timestamp;

public class Language {
    private String langCode;
    private String countryName;
    private String flagUrl;
    private boolean active;
    private boolean isDefault;
    private Timestamp createdAt;

    public Language() {
    }

    public Language(String langCode, String countryName, String flagUrl, boolean active, boolean isDefault) {
        this.langCode = langCode;
        this.countryName = countryName;
        this.flagUrl = flagUrl;
        this.active = active;
        this.isDefault = isDefault;
    }

    public String getLangCode() {
        return langCode;
    }

    public void setLangCode(String langCode) {
        this.langCode = langCode;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getFlagUrl() {
        return flagUrl;
    }

    public void setFlagUrl(String flagUrl) {
        this.flagUrl = flagUrl;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public boolean isDefaultLang() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
