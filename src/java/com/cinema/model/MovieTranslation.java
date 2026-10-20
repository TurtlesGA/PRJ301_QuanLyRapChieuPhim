package com.cinema.model;

import java.sql.Timestamp;

public class MovieTranslation {
    private int translationId;
    private int movieId;
    private String langCode;
    private String title;
    private String genre;
    private String description;
    private String director;
    private String cast;
    private Timestamp updatedAt;

    public MovieTranslation() {
    }

    public MovieTranslation(int movieId, String langCode, String title, String genre, String description, String director, String cast) {
        this.movieId = movieId;
        this.langCode = langCode;
        this.title = title;
        this.genre = genre;
        this.description = description;
        this.director = director;
        this.cast = cast;
    }

    public int getTranslationId() {
        return translationId;
    }

    public void setTranslationId(int translationId) {
        this.translationId = translationId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public String getLangCode() {
        return langCode;
    }

    public void setLangCode(String langCode) {
        this.langCode = langCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getCast() {
        return cast;
    }

    public void setCast(String cast) {
        this.cast = cast;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
