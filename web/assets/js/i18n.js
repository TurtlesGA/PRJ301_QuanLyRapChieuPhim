/**
 * CineStar Cinema - i18n (Internationalization) Engine
 * Supports Vietnamese (VN), English (US), French (FR) & custom languages via JSON
 * Features: Instant localStorage caching, Anti-FOUT synchronous streaming translation,
 * and zero-delay multi-page switching.
 */

(function () {
    'use strict';

    const STORAGE_KEY = 'cinema_lang';
    const CACHE_PREFIX = 'cinema_i18n_cache_';
    const CACHE_LANGS = 'cinema_i18n_cache_languages';

    // 1. Initial Language Detection
    let currentLang = 'vi';
    try {
        currentLang = localStorage.getItem(STORAGE_KEY) || document.documentElement.getAttribute('lang') || 'vi';
    } catch (e) {
        currentLang = document.documentElement.getAttribute('lang') || 'vi';
    }

    // Synchronize Cookie immediately so subsequent HTTP requests carry the language header
    try {
        document.cookie = 'cinema_lang=' + encodeURIComponent(currentLang) + ';path=/;max-age=31536000;SameSite=Lax';
    } catch (e) {}

    // Translations in-memory store
    let translations = { vi: null, en: null };

    // Dynamic list of active languages from languages.json / server
    let availableLanguages = [
        { code: 'vi', name: 'Ti\u1ebfng Vi\u1ec7t', country: 'Vi\u1ec7t Nam', flag: '/assets/images/flags/vn.svg' },
        { code: 'en', name: 'English', country: 'United States', flag: '/assets/images/flags/us.svg' }
    ];

    // Synchronously read cached language list and current language dictionary from localStorage
    try {
        const cachedLangs = localStorage.getItem(CACHE_LANGS);
        if (cachedLangs) {
            const parsedLangs = JSON.parse(cachedLangs);
            if (Array.isArray(parsedLangs) && parsedLangs.length > 0) {
                availableLanguages = parsedLangs;
            }
        }
        const cachedDict = localStorage.getItem(CACHE_PREFIX + currentLang);
        if (cachedDict) {
            translations[currentLang] = JSON.parse(cachedDict);
        }
    } catch (e) {
        console.warn('[i18n] Error reading localStorage cache:', e);
    }

    // Determine Base / Context Path dynamically
    function getContextPath() {
        if (typeof window.CONTEXT_PATH === 'string') return window.CONTEXT_PATH;
        const script = document.querySelector('script[src*="i18n.js"]');
        if (script && script.src) {
            try {
                const url = new URL(script.src, window.location.origin);
                return url.pathname.replace(/\/assets\/js\/.*$/, '');
            } catch (e) {}
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
        if (trimmed === 'Ho\u1ea1t \u0111\u1ed9ng') return currentLang === 'en' ? 'Active' : trimmed;
        if (trimmed === 'B\u1ecb kh\u00f3a') return currentLang === 'en' ? 'Banned' : trimmed;
        if (trimmed === 'T\u1ea1m d\u1eebng') return currentLang === 'en' ? 'Paused' : trimmed;
        if (trimmed === 'S\u1eafp chi\u1ebfu') return currentLang === 'en' ? 'Coming Soon' : trimmed;
        if (trimmed === '\u0110ang Chi\u1ebfu' || trimmed === '\u0110ang chi\u1ebfu') return currentLang === 'en' ? 'Now Showing' : trimmed;
        return text;
    }

    // Dynamic Movie Content Translation (Titles, Genres, Descriptions, Rooms)
    function translateDynamicMovieContent(data, root) {
        if (!data) return;
        root = root || document;
        const isEn = currentLang === 'en';
        const movieTitles = (data.movieData && data.movieData.titles) || {};
        const movieGenres = (data.movieData && data.movieData.genres) || {};
        const movieDescs = (data.movieData && data.movieData.descriptions) || {};
        const roomNames = (data.movieData && data.movieData.rooms) || {};

        function getEls(selector) {
            const list = root.querySelectorAll ? Array.from(root.querySelectorAll(selector)) : [];
            if (root.matches && root.matches(selector)) list.unshift(root);
            return list;
        }

        // 1. Movie Titles (Database Attribute First, JSON Fallback)
        getEls('.movie-title').forEach(el => {
            let orig = el.getAttribute('data-original-title');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-title', orig);
            }
            const dbTitle = el.getAttribute('data-title-' + currentLang);
            if (dbTitle) {
                el.textContent = dbTitle;
                if (el.hasAttribute('title')) el.setAttribute('title', dbTitle);
                return;
            }
            if (isEn) {
                const translated = movieTitles[orig];
                if (translated) {
                    el.textContent = translated;
                    if (el.hasAttribute('title')) el.setAttribute('title', translated);
                    return;
                }
            }
            el.textContent = orig;
            if (el.hasAttribute('title')) el.setAttribute('title', orig);
        });

        // 2. Movie Genres (Database Attribute First, JSON Fallback)
        getEls('.movie-genre').forEach(el => {
            let orig = el.getAttribute('data-original-genre');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-genre', orig);
            }
            const dbGenre = el.getAttribute('data-genre-' + currentLang);
            if (dbGenre) {
                el.textContent = dbGenre;
                return;
            }
            if (isEn) {
                if (movieGenres[orig]) {
                    el.textContent = movieGenres[orig];
                    return;
                }
                const parts = orig.split(',').map(s => s.trim());
                const translatedParts = parts.map(p => movieGenres[p] || p);
                el.textContent = translatedParts.join(', ');
                return;
            }
            el.textContent = orig;
        });

        // 3. Movie Descriptions (Database Attribute First, JSON Fallback)
        getEls('.movie-description').forEach(el => {
            let orig = el.getAttribute('data-original-desc');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-desc', orig);
            }
            const dbDesc = el.getAttribute('data-desc-' + currentLang);
            if (dbDesc) {
                el.textContent = dbDesc;
                return;
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
                    return;
                }
            }
            el.textContent = orig;
        });

        // 3b. Movie Director & Cast (Database Attributes)
        getEls('.movie-director').forEach(el => {
            let orig = el.getAttribute('data-original-director');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-director', orig);
            }
            const dbDir = el.getAttribute('data-director-' + currentLang);
            el.textContent = dbDir ? dbDir : orig;
        });

        getEls('.movie-cast').forEach(el => {
            let orig = el.getAttribute('data-original-cast');
            if (!orig) {
                orig = el.textContent.trim();
                el.setAttribute('data-original-cast', orig);
            }
            const dbCast = el.getAttribute('data-cast-' + currentLang);
            el.textContent = dbCast ? dbCast : orig;
        });

        // 4. Room Names
        getEls('.room-name').forEach(el => {
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
        getEls('option.movie-option, option[data-original-title]').forEach(opt => {
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
        getEls('option.room-option, option[data-original-room]').forEach(opt => {
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

    // Alerts & OTP Message Translation
    function translateAlertsAndOtp(lang, data, root) {
        if (!data) return;
        root = root || document;
        const isEn = lang === 'en';
        const alertsDict = data.alerts || {};

        function getEls(selector) {
            const list = root.querySelectorAll ? Array.from(root.querySelectorAll(selector)) : [];
            if (root.matches && root.matches(selector)) list.unshift(root);
            return list;
        }

        // 1. OTP alert box in Forgot Password
        getEls('.otp-notice-alert, .alert-info').forEach(alertEl => {
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
                        const enTemplate = (data.forgotPassword && data.forgotPassword.otpNoticeFormat)
                            ? data.forgotPassword.otpNoticeFormat
                            : 'Your OTP verification code is: {code} (Valid code to reset password)';
                        msgEl.textContent = enTemplate.replace('{code}', code);
                    } else {
                        const viTemplate = (data.forgotPassword && data.forgotPassword.otpNoticeFormat)
                            ? data.forgotPassword.otpNoticeFormat
                            : 'M\u00e3 x\u00e1c th\u1ef1c OTP c\u1ee7a b\u1ea1n l\u00e0: {code} (M\u00e3 c\u00f3 hi\u1ec7u l\u1ef1c \u0111\u1ec3 \u0111\u1ed5i m\u1eadt kh\u1ea9u)';
                        msgEl.textContent = origMsg || viTemplate.replace('{code}', code);
                    }
                }
            }
        });

        // 2. Auth error & success alerts
        getEls('.alert-danger, .alert-success, .alert-warning').forEach(alertEl => {
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

    // Synchronously translate a subtree/container
    function translateSubtree(root, data) {
        if (!data || !root) return;

        function getEls(selector) {
            const list = root.querySelectorAll ? Array.from(root.querySelectorAll(selector)) : [];
            if (root.matches && root.matches(selector)) list.unshift(root);
            return list;
        }

        // 1. Text elements
        getEls('[data-i18n]').forEach(el => {
            const key = el.getAttribute('data-i18n');
            const translation = getNestedValue(data, key);
            if (translation !== undefined && translation !== null) {
                el.textContent = translation;
            }
        });

        // 2. HTML elements
        getEls('[data-i18n-html]').forEach(el => {
            const key = el.getAttribute('data-i18n-html');
            const translation = getNestedValue(data, key);
            if (translation !== undefined && translation !== null) {
                el.innerHTML = translation;
            }
        });

        // 3. Placeholders
        getEls('[data-i18n-placeholder]').forEach(el => {
            const key = el.getAttribute('data-i18n-placeholder');
            const translation = getNestedValue(data, key);
            if (translation !== undefined && translation !== null) {
                el.placeholder = translation;
            }
        });

        // 4. Titles / aria-labels
        getEls('[data-i18n-title]').forEach(el => {
            const key = el.getAttribute('data-i18n-title');
            const translation = getNestedValue(data, key);
            if (translation !== undefined && translation !== null) {
                el.title = translation;
                el.setAttribute('aria-label', translation);
            }
        });

        // 5. SweetAlert2 data-confirm & data-title
        getEls('[data-i18n-confirm]').forEach(el => {
            const key = el.getAttribute('data-i18n-confirm');
            const translation = getNestedValue(data, key);
            if (translation) el.setAttribute('data-confirm', translation);
        });
        getEls('[data-i18n-confirm-title]').forEach(el => {
            const key = el.getAttribute('data-i18n-confirm-title');
            const translation = getNestedValue(data, key);
            if (translation) el.setAttribute('data-title', translation);
        });

        // 6. Dynamic status badges
        getEls('.badge-status, [data-i18n-status]').forEach(el => {
            const statusCode = el.getAttribute('data-status-code') || el.textContent.trim();
            if (!el.hasAttribute('data-status-code')) {
                el.setAttribute('data-status-code', statusCode);
            }
            const translated = t('status.' + statusCode);
            if (translated && translated !== 'status.' + statusCode) {
                el.textContent = translated;
            }
        });

        // 7. Dynamic Movie Content
        translateDynamicMovieContent(data, root);

        // 8. Alerts & OTP
        translateAlertsAndOtp(currentLang, data, root);
    }

    // Apply translations to the entire DOM
    async function applyLanguage(lang) {
        currentLang = lang;
        try {
            localStorage.setItem(STORAGE_KEY, lang);
            document.cookie = 'cinema_lang=' + encodeURIComponent(lang) + ';path=/;max-age=31536000;SameSite=Lax';
        } catch (e) {}
        document.documentElement.setAttribute('lang', lang);

        let data = translations[lang];
        if (!data) {
            data = await loadTranslations(lang);
        }
        if (!data) {
            document.documentElement.removeAttribute('data-i18n-loading');
            return;
        }

        translateSubtree(document.body || document.documentElement, data);
        translateDocumentTitle(lang, data);
        updateSwitcherUI(lang);
        document.documentElement.removeAttribute('data-i18n-loading');

        window.dispatchEvent(new CustomEvent('cinema:langChanged', { detail: { lang, data } }));
    }

    // Load available active languages (with background update & cache)
    async function loadAvailableLanguages(background) {
        const contextPath = getContextPath();
        const jsonUrl = (contextPath ? contextPath : '') + '/assets/i18n/languages.json?v=' + Date.now();
        try {
            const res = await fetch(jsonUrl);
            if (res.ok) {
                const data = await res.json();
                if (Array.isArray(data) && data.length > 0) {
                    availableLanguages = data;
                    try {
                        localStorage.setItem(CACHE_LANGS, JSON.stringify(data));
                    } catch (e) {}
                    renderLanguageDropdowns();
                    updateSwitcherUI(currentLang);
                }
            }
        } catch (e) {}
    }

    // Load translation JSON file (with background update & cache)
    async function loadTranslations(lang, background) {
        if (!background && translations[lang]) return translations[lang];

        const contextPath = getContextPath();
        const jsonUrl = (contextPath ? contextPath : '') + '/assets/i18n/' + lang + '.json?v=' + Date.now();

        try {
            const res = await fetch(jsonUrl);
            if (!res.ok) throw new Error('HTTP ' + res.status);
            const data = await res.json();
            translations[lang] = data;
            try {
                localStorage.setItem(CACHE_PREFIX + lang, JSON.stringify(data));
            } catch (e) {}
            return data;
        } catch (err) {
            try {
                const fallbackUrl = 'assets/i18n/' + lang + '.json';
                const res = await fetch(fallbackUrl);
                const data = await res.json();
                translations[lang] = data;
                try {
                    localStorage.setItem(CACHE_PREFIX + lang, JSON.stringify(data));
                } catch (e) {}
                return data;
            } catch (err2) {
                return translations[lang] || null;
            }
        }
    }

    // Render dropdown options dynamically for all language switchers on page
    function renderLanguageDropdowns() {
        const contextPath = getContextPath();
        document.querySelectorAll('.lang-dropdown').forEach(dropdown => {
            let html = '';
            availableLanguages.forEach(l => {
                const flagUrl = l.flag.startsWith('/') ? ((contextPath ? contextPath : '') + l.flag) : ((contextPath ? contextPath : '') + '/' + l.flag);
                const displayCode = l.code.toUpperCase();
                const isActive = l.code.toLowerCase() === currentLang.toLowerCase();
                html += '<li>'
                     + '<button type="button" data-lang="' + l.code.toLowerCase() + '" class="lang-option' + (isActive ? ' active' : '') + '">'
                     + '<img src="' + flagUrl + '" class="lang-flag-img" alt="' + displayCode + '">'
                     + '<span> - ' + displayCode + '</span>'
                     + '</button>'
                     + '</li>';
            });
            dropdown.innerHTML = html;
        });
    }

    // Update Language Switcher UI (Button label, flag image, active state)
    function updateSwitcherUI(lang) {
        const cur = availableLanguages.find(l => l.code.toLowerCase() === lang.toLowerCase()) || {
            code: lang,
            flag: lang === 'en' ? '/assets/images/flags/us.svg' : '/assets/images/flags/vn.svg'
        };
        const contextPath = getContextPath();
        const flagSrc = cur.flag.startsWith('/') ? ((contextPath ? contextPath : '') + cur.flag) : ((contextPath ? contextPath : '') + '/' + cur.flag);
        const labelText = ' - ' + cur.code.toUpperCase();

        document.querySelectorAll('.lang-switcher').forEach(switcher => {
            const flagEl = switcher.querySelector('.lang-flag');
            const labelEl = switcher.querySelector('.lang-label');
            if (flagEl) {
                flagEl.innerHTML = '<img src="' + flagSrc + '" class="lang-flag-img" alt="' + cur.code.toUpperCase() + '">';
            }
            if (labelEl) {
                labelEl.textContent = labelText;
            }

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
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.lang-btn');
            if (btn) {
                e.preventDefault();
                e.stopPropagation();
                const switcher = btn.closest('.lang-switcher');
                if (switcher) {
                    const isOpen = switcher.classList.contains('open');
                    document.querySelectorAll('.lang-switcher.open').forEach(s => s.classList.remove('open'));
                    if (!isOpen) {
                        switcher.classList.add('open');
                    }
                }
                return;
            }

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

            if (!e.target.closest('.lang-switcher')) {
                document.querySelectorAll('.lang-switcher.open').forEach(s => s.classList.remove('open'));
            }
        });
    }

    // Setup early MutationObserver to catch elements during initial DOM streaming
    if (window.MutationObserver && currentLang !== 'vi' && translations[currentLang]) {
        try {
            const observer = new MutationObserver(function (mutations) {
                const data = translations[currentLang];
                if (!data) return;
                for (let i = 0; i < mutations.length; i++) {
                    const added = mutations[i].addedNodes;
                    for (let j = 0; j < added.length; j++) {
                        const node = added[j];
                        if (node.nodeType === 1) {
                            translateSubtree(node, data);
                        }
                    }
                }
            });
            observer.observe(document.documentElement, { childList: true, subtree: true });
        } catch (e) {}
    }

    // Ready hook
    function onReady() {
        setupSwitcherEvents();
        renderLanguageDropdowns();
        updateSwitcherUI(currentLang);

        if (translations[currentLang]) {
            applyLanguage(currentLang);
        } else {
            loadTranslations(currentLang).then(() => {
                applyLanguage(currentLang);
            });
        }
        document.documentElement.removeAttribute('data-i18n-loading');

        // Silent background preload of all active languages into localStorage cache
        loadAvailableLanguages(true).then(() => {
            availableLanguages.forEach(l => {
                if (l.code !== currentLang && !translations[l.code]) {
                    loadTranslations(l.code, true);
                }
            });
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', onReady);
    } else {
        onReady();
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
        translateDocumentTitle: translateDocumentTitle,
        translateSubtree: translateSubtree
    };

})();
