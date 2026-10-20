package com.cinema.model;

import java.sql.Date;

public class Movie {
    private int movieId;
    private String title;
    private String genre;
    private int duration; // in minutes
    private Date releaseDate;
    private Date endDate;
    private String director;
    private String cast;
    private String description;
    private String posterUrl;
    private String trailerUrl;
    private String ageRating; // P, K, T13, T16, T18
    private String status; // NOW_SHOWING, COMING_SOON, STOPPED

    public Movie() {
    }

    public Movie(int movieId, String title, String genre, int duration, Date releaseDate, Date endDate,
                 String director, String cast, String description, String posterUrl, String trailerUrl,
                 String ageRating, String status) {
        this.movieId = movieId;
        this.title = title;
        this.genre = genre;
        this.duration = duration;
        this.releaseDate = releaseDate;
        this.endDate = endDate;
        this.director = director;
        this.cast = cast;
        this.description = description;
        this.posterUrl = posterUrl;
        this.trailerUrl = trailerUrl;
        this.ageRating = ageRating;
        this.status = status;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
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

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }

    public String getTrailerUrl() {
        return trailerUrl;
    }

    public void setTrailerUrl(String trailerUrl) {
        this.trailerUrl = trailerUrl;
    }

    public String getAgeRating() {
        return ageRating;
    }

    public void setAgeRating(String ageRating) {
        this.ageRating = ageRating;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    private java.util.Map<String, MovieTranslation> translations = new java.util.HashMap<>();

    public java.util.Map<String, MovieTranslation> getTranslations() {
        return translations;
    }

    public void setTranslations(java.util.Map<String, MovieTranslation> translations) {
        this.translations = translations != null ? translations : new java.util.HashMap<>();
    }

    public MovieTranslation getTranslation(String langCode) {
        if (translations == null || langCode == null) return null;
        return translations.get(langCode.toLowerCase());
    }

    public void addTranslation(MovieTranslation t) {
        if (t != null && t.getLangCode() != null) {
            if (this.translations == null) this.translations = new java.util.HashMap<>();
            this.translations.put(t.getLangCode().toLowerCase(), t);
        }
    }
}
