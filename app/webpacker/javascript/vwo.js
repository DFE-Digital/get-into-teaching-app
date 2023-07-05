import CookiePreferences from '../javascript/cookie_preferences';

export default class Vwo {
  constructor(id) {
    this.id = id;
  }

  init() {
    this.containerInitialized = false;

    this.initWindow();
    this.initContainer();
    this.listenForConsentChanges();
  }

  initWindow() {
    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({ originalLocation: this.originalLocation });
  }

  initContainer() {
    if (!this.cookiePreferences.cookieSet || this.containerInitialized || this.consentValue('non-functional') !== 'granted') {
      return;
    }

    this.containerInitialized = true;

    window._vwo_code =
      window._vwo_code ||
      (function () {
        const account_id = this.id;
        const version = 1.5;
        const settings_tolerance = 2000;
        const library_tolerance = 2500;
        const use_existing_jquery = false;
        const is_spa = 1;
        const hide_element = 'body';
        const hide_element_style =
          'opacity:0 !important;filter:alpha(opacity=0) !important;background:none !important';
        let f = false;
        const d = document;
        const vwoCodeEl = d.querySelector('#vwoCode');
        var code = {
          use_existing_jquery: function () {
            return use_existing_jquery;
          },
          library_tolerance: function () {
            return library_tolerance;
          },
          hide_element_style: function () {
            return '{' + hide_element_style + '}';
          },
          finish: function () {
            if (!f) {
              f = true;
              const e = d.getElementById('_vis_opt_path_hides');
              if (e) e.parentNode.removeChild(e);
            }
          },
          finished: function () {
            return f;
          },
          load: function (e) {
            const t = d.createElement('script');
            t.fetchPriority = 'high';
            t.src = e;
            t.type = 'text/javascript';
            t.onerror = function () {
              _vwo_code.finish();
            };
            d.getElementsByTagName('head')[0].appendChild(t);
          },
          getVersion: function () {
            return version;
          },
          getMatchedCookies: function (e) {
            let t = [];
            if (document.cookie) {
              t = document.cookie.match(e) || [];
            }
            return t;
          },
          getCombinationCookie: function () {
            let e = code.getMatchedCookies(
              /(?:^|;)\s?(vis_opt_exp\d+_combi=[^;$])/gi
            );
            e = e.map(function (e) {
              try {
                const t = decodeURIComponent(e);
                if (!/vis_opt_exp\d+_combi=(?:\d+,?)+\s*$/.test(t)) {
                  return '';
                }
                return t;
              } catch (e) {
                return '';
              }
            });
            const i = [];
            e.forEach(function (e) {
              const t = e.match(/([\d,]+)/g);
              t && i.push(t.join('-'));
            });
            return i.join('|');
          },
          init: function () {
            if (d.URL.indexOf('vwo_disable') > -1) return;
            window.settings_timer = setTimeout(function () {
              _vwo_code.finish();
            }, settings_tolerance);
            const e = d.createElement('style');
            const t = hide_element
              ? hide_element + '{' + hide_element_style + '}'
              : '';
            const i = d.getElementsByTagName('head')[0];
            e.setAttribute('id', '_vis_opt_path_hides');
            vwoCodeEl && e.setAttribute('nonce', vwoCodeEl.nonce);
            e.setAttribute('type', 'text/css');
            if (e.styleSheet) e.styleSheet.cssText = t;
            else e.appendChild(d.createTextNode(t));
            i.appendChild(e);
            const n = this.getCombinationCookie();
            this.load(
              'https://dev.visualwebsiteoptimizer.com/j.php?a=' +
                account_id +
                '&u=' +
                encodeURIComponent(d.URL) +
                '&f=' +
                +is_spa +
                '&vn=' +
                version +
                (n ? '&c=' + n : '')
            );
            return settings_timer;
          },
        };
        window._vwo_settings_timer = code.init();
        return code;
      })();
  }

  listenForConsentChanges() {
    document.addEventListener('cookies:accepted', () => {
      this.initContainer();
    });
  }

  consent() {
    return {
      analytics_storage: this.consentValue('non-functional'),
      ad_storage: this.consentValue('marketing'),
    };
  }

  consentValue(category) {
    return this.cookiePreferences.allowedCategories.includes(category)
      ? 'granted'
      : 'denied';
  }

  get originalLocation() {
    const l = window.location;
    return `${l.protocol}://${l.hostname}${l.pathname}${l.search}`;
  }

  get cookiePreferences() {
    return new CookiePreferences();
  }
}
