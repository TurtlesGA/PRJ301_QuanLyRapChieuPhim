/**
 * CineStar Cinema - i18n (Internationalization) Engine
 * Supports Vietnamese (VN) & English (US) via JSON files
 */

(function () {
    'use strict';

    const STORAGE_KEY = 'cinema_lang';
    let currentLang = localStorage.getItem(STORAGE_KEY) || 'vi';
    let translations = { vi: null, en: null };

    // Determine Base / Context Path dynamically
    function getContextPath() {
        if (typeof window.CONTEXT_PATH === 'string') return window.CONTEXT_PATH;
        const script = document.querySelector('script[src*="i18n.js"]');
        if (script && script.src) {
            try {
                const url = new URL(script.src, window.location.origin);
                return url.pathname.replace(/\/assets\/js\/.*$/, '');
            } catch (e) {
                // fallback
            }
        }
        return '';
    }

    // Deep lookup helper (e.g. "admin.dashboard.title")
    function getNestedValue(obj, keyPath) {
        if (!obj || !keyPath) return null;
        const keys = keyPath.split('.');
        let val = obj;
        for (let i = 0; i < keys.length; i++) {
            if (val === undefined || val === null) return null;
            val = val[keys[i]];
        }
        return val;
    }

    // Load translation JSON file
    async function loadTranslations(lang) {
        if (translations[lang]) return translations[lang];

        const contextPath = getContextPath();
        const jsonUrl = (contextPath ? contextPath : '') + '/assets/i18n/' + lang + '.json?v=' + Date.now();

        try {
            const res = await fetch(jsonUrl);
            if (!res.ok) throw new Error('HTTP ' + res.status);
            const data = await res.json();
            translations[lang] = data;
            return data;
        } catch (err) {
            console.warn('[i18n] Failed to fetch ' + jsonUrl + ', retrying relative path...', err);
            try {
                const fallbackUrl = 'assets/i18n/' + lang + '.json';
                const res = await fetch(fallbackUrl);
                const data = await res.json();
                translations[lang] = data;
                return data;
            } catch (err2) {
                console.error('[i18n] Could not load language JSON: ' + lang, err2);
                return null;
            }
        }
    }

    // Helper: Translate key
    function t(key, defaultVal) {
        const langData = translations[currentLang];
        if (!langData) return defaultVal || key;
        const val = getNestedValue(langData, key);
        return val !== null && val !== undefined ? val : (defaultVal || key);
    }

    // Status translation helper
    function translateStatusText(text) {
        if (!text) return text;
        const trimmed = text.trim();
        const mapped = t('status.' + trimmed);
        if (mapped && mapped !== 'status.' + trimmed) return mapped;
        // Check common status labels using unicode escapes
        if (trimmed === 'Ho\u1ea1t \u0111\u1ed9ng') return currentLang === 'en' ? 'Active' : trimmed;
        if (trimmed === 'B\u1ecb kh\u00f3a') return currentLang === 'en' ? 'Banned' : trimmed;
        if (trimmed === 'T\u1ea1m d\u1eebng') return currentLang === 'en' ? 'Paused' : trimmed;
        if (trimmed === 'S\u1eafp chi\u1ebfu') return currentLang === 'en' ? 'Coming Soon' : trimmed;
        if (trimmed === '\u0110ang Chi\u1ebfu' || trimmed === '\u0110ang chi\u1ebfu') return currentLang === 'en' ? 'Now Showing' : trimmed;
        return text;
    }

    // Dynamic Movie Content Translation (Titles, Genres, Descriptions, Rooms)
    function translateDynamicMovieContent(data) {
        if (!data) return;
        const isEn = currentLang === 'en';
        const movieTitles = (data.movieData && data.movieData.titles) || {};
        const movieGenres = (data.movieData && data.movieData.genres) || {};
        const movieDescs = (data.movieData && data.movieData.descriptions) || {};
        const roomNames = (data.movieData && data.movieData.rooms) || {};

        // 1. Movie Titles
        document.querySelectorAll('.movie-title').forEach(el => {
            let orig = el.getAttribute('data-original-title');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-title', orig);
            }
            if (isEn) {
                const translated = movieTitles[orig];
                if (translated) {
                    el.textContent = translated;
                    if (el.hasAttribute('title')) el.setAttribute('title', translated);
                }
            } else {
                el.textContent = orig;
                if (el.hasAttribute('title')) el.setAttribute('title', orig);
            }
        });

        // 2. Movie Genres
        document.querySelectorAll('.movie-genre').forEach(el => {
            let orig = el.getAttribute('data-original-genre');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-genre', orig);
            }
            if (isEn) {
                if (movieGenres[orig]) {
                    el.textContent = movieGenres[orig];
                } else {
                    const parts = orig.split(',').map(s => s.trim());
                    const translatedParts = parts.map(p => movieGenres[p] || p);
                    el.textContent = translatedParts.join(', ');
                }
            } else {
                el.textContent = orig;
            }
        });

        // 3. Movie Descriptions
        document.querySelectorAll('.movie-description').forEach(el => {
            let orig = el.getAttribute('data-original-desc');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-desc', orig);
            }
            const movieKey = el.getAttribute('data-movie-title');
            if (isEn) {
                let translated = null;
                if (movieKey && movieDescs[movieKey]) {
                    translated = movieDescs[movieKey];
                } else {
                    for (const key of Object.keys(movieDescs)) {
                        if (orig.includes(key) || key.includes(orig.substring(0, 15))) {
                            translated = movieDescs[key];
                            break;
                        }
                    }
                }
                if (translated) {
                    el.textContent = translated;
                }
            } else {
                el.textContent = orig;
            }
        });

        // 4. Room Names
        document.querySelectorAll('.room-name').forEach(el => {
            let orig = el.getAttribute('data-original-room');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-room', orig);
            }
            if (isEn) {
                if (roomNames[orig]) {
                    el.textContent = roomNames[orig];
                } else {
                    el.textContent = orig.replace(/Ph\u00f2ng Cinema/g, 'Cinema Room');
                }
            } else {
                el.textContent = orig;
            }
        });

        // 5. Select Movie Options (Showtime Add form)
        document.querySelectorAll('option.movie-option, option[data-original-title]').forEach(opt => {
            let origTitle = opt.getAttribute('data-original-title');
            let duration = opt.getAttribute('data-duration');
            if (!origTitle) {
                const text = opt.textContent.trim();
                const m = text.match(/^(.*?)\s*\((\d+)\s*(?:ph\u00fat|mins?|minutes)\)$/i);
                if (m) {
                    origTitle = m[1].trim();
                    duration = m[2];
                    opt.setAttribute('data-original-title', origTitle);
                    opt.setAttribute('data-duration', duration);
                } else {
                    origTitle = text;
                    opt.setAttribute('data-original-title', origTitle);
                }
            }
            if (isEn) {
                const enTitle = movieTitles[origTitle] || origTitle;
                opt.textContent = duration ? (enTitle + ' (' + duration + ' mins)') : enTitle;
            } else {
                opt.textContent = duration ? (origTitle + ' (' + duration + ' ph\u00fat)') : origTitle;
            }
        });

        // 6. Select Room Options (Showtime Add form)
        document.querySelectorAll('option.room-option, option[data-original-room]').forEach(opt => {
            let origRoom = opt.getAttribute('data-original-room');
            if (!origRoom) {
                origRoom = opt.textContent.trim();
                opt.setAttribute('data-original-room', origRoom);
            }
            if (isEn) {
                let enRoom = roomNames[origRoom];
                if (!enRoom) {
                    enRoom = origRoom.replace(/Ph\u00f2ng Cinema/g, 'Cinema Room');
                }
                opt.textContent = enRoom;
            } else {
                opt.textContent = origRoom;
            }
        });
    }

    // Alerts & OTP Message Translation (Zero Mojibake with Orig Cache + Unicode Escapes)
    function translateAlertsAndOtp(lang, data) {
        const isEn = lang === 'en';
        const alertsDict = (data && data.alerts) || {};

        // 1. OTP alert box in Forgot Password
        document.querySelectorAll('.otp-notice-alert, .alert-info').forEach(alertEl => {
            const text = alertEl.textContent || '';
            if (text.includes('OTP') || alertEl.classList.contains('otp-notice-alert')) {
                const match = text.match(/\b\d{4,6}\b/);
                const code = alertEl.getAttribute('data-otp') || (match ? match[0] : '');
                const msgEl = alertEl.querySelector('.otp-message') || alertEl.querySelector('strong');
                if (code && msgEl) {
                    let origMsg = alertEl.getAttribute('data-original-msg');
                    if (!origMsg) {
                        origMsg = msgEl.textContent.trim();
                        alertEl.setAttribute('data-original-msg', origMsg);
                    }
                    if (isEn) {
                        const enTemplate = (data && data.forgotPassword && data.forgotPassword.otpNoticeFormat)
                            ? data.forgotPassword.otpNoticeFormat
                            : 'Your OTP verification code is: {code} (Valid code to reset password)';
                        msgEl.textContent = enTemplate.replace('{code}', code);
                    } else {
                        const viTemplate = (data && data.forgotPassword && data.forgotPassword.otpNoticeFormat)
                            ? data.forgotPassword.otpNoticeFormat
                            : 'M\u00e3 x\u00e1c th\u1ef1c OTP c\u1ee7a b\u1ea1n l\u00e0: {code} (M\u00e3 c\u00f3 hi\u1ec7u l\u1ef1c \u0111\u1ec3 \u0111\u1ed5i m\u1eadt kh\u1ea9u)';
                        msgEl.textContent = origMsg || viTemplate.replace('{code}', code);
                    }
                }
            }
        });

        // 2. Auth error & success alerts
        document.querySelectorAll('.alert-danger, .alert-success, .alert-warning').forEach(alertEl => {
            if (alertEl.id === 'countdownTimer' || alertEl.querySelector('#countdownTimer')) return;
            const textSpan = alertEl.querySelector('.alert-text');
            if (textSpan) {
                let orig = textSpan.getAttribute('data-original-text');
                if (!orig) {
                    orig = textSpan.textContent.trim();
                    textSpan.setAttribute('data-original-text', orig);
                }
                if (isEn) {
                    if (alertsDict[orig]) {
                        textSpan.textContent = alertsDict[orig];
                    }
                } else {
                    textSpan.textContent = orig;
                }
            } else {
                let orig = alertEl.getAttribute('data-original-text');
                const icon = alertEl.querySelector('i');
                if (!orig) {
                    if (icon && icon.nextSibling) {
                        orig = icon.nextSibling.textContent.trim();
                    } else {
                        orig = alertEl.textContent.trim();
                    }
                    alertEl.setAttribute('data-original-text', orig);
                }
                if (isEn && alertsDict[orig]) {
                    if (icon && icon.nextSibling) {
                        icon.nextSibling.textContent = ' ' + alertsDict[orig];
                    } else {
                        alertEl.textContent = alertsDict[orig];
                    }
                } else if (!isEn && orig) {
                    if (icon && icon.nextSibling) {
                        icon.nextSibling.textContent = ' ' + orig;
                    } else {
                        alertEl.textContent = orig;
                    }
                }
            }
        });
    }

    // Document Title Translation
    function translateDocumentTitle(lang, data) {
        if (!data) return;
        const isEn = lang === 'en';
        const pageTitles = data.pageTitles || {};
        const movieTitles = (data.movieData && data.movieData.titles) || {};

        let baseDocTitle = document.documentElement.getAttribute('data-original-doc-title');
        if (!baseDocTitle) {
            baseDocTitle = document.title;
            document.documentElement.setAttribute('data-original-doc-title', baseDocTitle);
        }

        if (baseDocTitle.includes('Chi Ti\u1ebft Phim') || baseDocTitle.includes('Movie Details')) {
            const titleEl = document.querySelector('.movie-detail-title, .movie-title');
            let origMovie = titleEl ? (titleEl.getAttribute('data-original-title') || titleEl.textContent.trim()) : '';
            if (isEn) {
                const enTitle = movieTitles[origMovie] || origMovie;
                document.title = enTitle + (pageTitles.movieDetailSuffix || ' - Movie Details CineStar');
            } else {
                document.title = origMovie + (pageTitles.movieDetailSuffix || ' - Chi Ti\u1ebft Phim CineStar');
            }
            return;
        }

        if (isEn) {
            if (baseDocTitle.includes('Trang Ch\u1ee7')) document.title = pageTitles.home || 'CineStar - Online Movie Ticket Booking';
            else if (baseDocTitle.includes('\u0110\u0103ng Nh\u1eadp')) document.title = pageTitles.login || 'Login - CineStar';
            else if (baseDocTitle.includes('\u0110\u0103ng K\u00fd')) document.title = pageTitles.register || 'Create Account - CineStar';
            else if (baseDocTitle.includes('Qu\u00ean M\u1eadt Kh\u1ea9u')) document.title = pageTitles.forgotPassword || 'Forgot Password - CineStar';
            else if (baseDocTitle.includes('Danh S\u00e1ch Phim')) document.title = pageTitles.movies || 'Movie List - CineStar';
            else if (baseDocTitle.includes('Ch\u1ecdn Gh\u1ebf')) document.title = pageTitles.seatSelection || 'Select Seats - CineStar';
            else if (baseDocTitle.includes('Thanh To\u00e1n')) document.title = pageTitles.payment || 'Online Payment - CineStar';
            else if (baseDocTitle.includes('\u0110\u1eb7t V\u00e9 Th\u00e0nh C\u00f4ng')) document.title = pageTitles.bookingSuccess || 'Booking Successful - CineStar';
            else if (baseDocTitle.includes('V\u00e9 C\u1ee7a T\u00f4i')) document.title = pageTitles.myBookings || 'My Tickets - CineStar';
            else if (baseDocTitle.includes('Th\u00f4ng Tin T\u00e0i Kho\u1ea3n')) document.title = pageTitles.profile || 'Account Information - CineStar';
        } else {
            document.title = baseDocTitle;
        }
    }

    // Apply translations to the DOM
    async function applyLanguage(lang) {
        currentLang = lang;
        localStorage.setItem(STORAGE_KEY, lang);
        document.documentElement.setAttribute('lang', lang);

        let data = translations[lang];
        if (!data) {
            data = await loadTranslations(lang);
        }
        if (!data) return;

        // 1. Text elements
        document.querySelectorAll('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            const translation = getNestedValue(data, key);
            if (translation !== undefined && translation !== null) {
                el.textContent = translation;
            }
        });

        // 2. HTML elements
        document.querySelectorAll('[data-i18n-html]').forEach(el => {
            const key = el.getAttribute('data-i18n-html');
            const translation = getNestedValue(data, key);
            if (translation !== undefined && translation !== null) {
                el.innerHTML = translation;
            }
        });

        // 3. Placeholders
        document.querySelectorAll('[data-i18n-placeholder]').forEach(el => {
            const key = el.getAttribute('data-i18n-placeholder');
            const translation = getNestedValue(data, key);
            if (translation !== undefined && translation !== null) {
                el.placeholder = translation;
            }
        });

        // 4. Titles / aria-labels
        document.querySelectorAll('[data-i18n-title]').forEach(el => {
            const key = el.getAttribute('data-i18n-title');
            const translation = getNestedValue(data, key);
            if (translation !== undefined && translation !== null) {
                el.title = translation;
                el.setAttribute('aria-label', translation);
            }
        });

        // 5. SweetAlert2 data-confirm & data-title
        document.querySelectorAll('[data-i18n-confirm]').forEach(el => {
            const key = el.getAttribute('data-i18n-confirm');
            const translation = getNestedValue(data, key);
            if (translation) el.setAttribute('data-confirm', translation);
        });
        document.querySelectorAll('[data-i18n-confirm-title]').forEach(el => {
            const key = el.getAttribute('data-i18n-confirm-title');
            const translation = getNestedValue(data, key);
            if (translation) el.setAttribute('data-title', translation);
        });

        // 6. Dynamic status badges
        document.querySelectorAll('.badge-status, [data-i18n-status]').forEach(el => {
            const statusCode = el.getAttribute('data-status-code') || el.textContent.trim();
            if (!el.hasAttribute('data-status-code')) {
                el.setAttribute('data-status-code', statusCode);
            }
            const translated = t('status.' + statusCode);
            if (translated && translated !== 'status.' + statusCode) {
                el.textContent = translated;
            }
        });

        // 7. Dynamic Movie Content (Titles, Genres, Descriptions, Rooms)
        translateDynamicMovieContent(data);

        // 8. Dynamic Alerts & OTP Messages
        translateAlertsAndOtp(lang, data);

        // 9. Document / Tab Title
        translateDocumentTitle(lang, data);

        // 10. Update Language Switcher UI Widgets
        updateSwitcherUI(lang);

        // 11. Fire event for other dynamic components
        window.dispatchEvent(new CustomEvent('cinema:langChanged', { detail: { lang, data } }));
    }

    // Update Language Switcher UI (Button label, flag image, active state)
    function updateSwitcherUI(lang) {
        const isVN = lang === 'vi';
        const labelText = isVN ? ' - VN' : ' - US';
        const contextPath = getContextPath();
        const flagFile = isVN ? 'vn.svg' : 'us.svg';
        const flagSrc = (contextPath ? contextPath : '') + '/assets/images/flags/' + flagFile;

        document.querySelectorAll('.lang-switcher').forEach(switcher => {
            const flagEl = switcher.querySelector('.lang-flag');
            const labelEl = switcher.querySelector('.lang-label');
            if (flagEl) {
                flagEl.innerHTML = '<img src="' + flagSrc + '" class="lang-flag-img" alt="' + (isVN ? 'VN' : 'US') + '">';
            }
            if (labelEl) {
                labelEl.textContent = labelText;
            }

            // Highlight options
            switcher.querySelectorAll('.lang-option').forEach(opt => {
                const optLang = opt.getAttribute('data-lang');
                if (optLang === lang) {
                    opt.classList.add('active');
                } else {
                    opt.classList.remove('active');
                }
            });
        });
    }

    // Setup event listeners for language switchers
    function setupSwitcherEvents() {
        // Toggle dropdown on button click
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.lang-btn');
            if (btn) {
                e.preventDefault();
                e.stopPropagation();
                const switcher = btn.closest('.lang-switcher');
                if (switcher) {
                    const isOpen = switcher.classList.contains('open');
                    // Close all others
                    document.querySelectorAll('.lang-switcher.open').forEach(s => s.classList.remove('open'));
                    if (!isOpen) {
                        switcher.classList.add('open');
                    }
                }
                return;
            }

            // Click option in dropdown
            const optionBtn = e.target.closest('.lang-option');
            if (optionBtn) {
                e.preventDefault();
                const newLang = optionBtn.getAttribute('data-lang');
                if (newLang && newLang !== currentLang) {
                    applyLanguage(newLang);
                }
                document.querySelectorAll('.lang-switcher.open').forEach(s => s.classList.remove('open'));
                return;
            }

            // Click outside closes dropdowns
            if (!e.target.closest('.lang-switcher')) {
                document.querySelectorAll('.lang-switcher.open').forEach(s => s.classList.remove('open'));
            }
        });
    }

    // Public API
    window.CinemaI18n = {
        getLang: () => currentLang,
        setLang: (lang) => applyLanguage(lang),
        t: t,
        translateStatusText: translateStatusText,
        apply: () => applyLanguage(currentLang),
        translateDynamicMovieContent: translateDynamicMovieContent,
        translateAlertsAndOtp: translateAlertsAndOtp,
        translateDocumentTitle: translateDocumentTitle
    };

    // Preload & Apply on DOM Ready
    document.addEventListener('DOMContentLoaded', async function () {
        setupSwitcherEvents();
        await loadTranslations(currentLang);
        // Also prefetch the other language in the background for instant switching
        loadTranslations(currentLang === 'vi' ? 'en' : 'vi');
        applyLanguage(currentLang);
    });

})();
