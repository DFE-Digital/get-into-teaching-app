const Cookies = require('js-cookie') ;
import CookiePreferences from 'cookie_preferences' ;

describe('CookiePreferences', () => {
  let prefs = null ;

  function setCookie(name, content) {
    Cookies.set(name, content) ;
  }

  function setJsonCookie(name, data) {
    setCookie(name, JSON.stringify(data)) ;
  }

  beforeEach(() => { Cookies.remove(CookiePreferences.cookieName) })

  describe("cookieName", () => {
    it("should include version number", () => {
      expect(CookiePreferences.cookieName).toBe("git-cookie-preferences-v1")
    })
  })

  describe("with cookie set", () => {
    beforeEach(() => {
      setJsonCookie(CookiePreferences.cookieName, { required: true, marketing: false }) ;
      prefs = new CookiePreferences ;
    }) ;

    it("#all should load settings from cookie", () => {
      expect(prefs.all).toEqual({required: true, marketing: false}) ;
    }) ;

    describe("#allowed", () => {
      it("should return per category values",() => {
        expect(prefs.allowed('required')).toBe(true) ;
        expect(prefs.allowed('marketing')).toBe(false) ;
      })

      it("should return false for unknown categories", () => {
        expect(prefs.allowed('unknown')).toBe(false) ;
      })
    })

    describe("#categories", () => {
      it("should return the categories held in the cookie", () => {
        expect(prefs.categories).toEqual(["required", "marketing"]) ;
      }) ;
    }) ;

    describe("assigning #all", () => {
      beforeEach(() => { prefs.all = {required: false, functional: true} })

      it("should update", () => {
        expect(prefs.all).toEqual({required: false, functional: true})
      })

      it("should return new values for #allowed", () => {
        expect(prefs.allowed('required')).toBe(false)
        expect(prefs.allowed('functional')).toBe(true)
        expect(prefs.allowed('marketing')).toBe(false)
      })

      it("should update #categories list", () => {
        expect(prefs.categories).toEqual(['required', 'functional'])
      }) ;

      test.todo("should emit event for updates")
    }) ;

    describe("assigning existing category", () => {
      beforeEach(() => { prefs.setCategory('marketing', true) })

      it("updates allowed value", () => {
        expect(prefs.allowed('marketing')).toBe(true)
      })

      it("updates #all", () => {
        expect(prefs.all).toEqual({required: true, marketing: true})
      })

      it("does not update category list", () => {
        expect(prefs.categories).toEqual(['required', 'marketing'])
      })

      test.todo("emits event") ;
    })

    describe("assigning new category", () => {
      beforeEach(() => { prefs.setCategory('functional', true) })

      it("updates allowed value", () => {
        expect(prefs.allowed('functional')).toBe(true)
      })

      it("updates #all", () => {
        expect(prefs.all).toEqual({required: true, marketing: false, functional: true})
      })

      it("does not update category list", () => {
        expect(prefs.categories).toEqual(['required', 'marketing', 'functional'])
      })

      test.todo("emits event") ;
    })
  })

  describe("without cookie set", () => {
    beforeEach(() => { prefs = new CookiePreferences })

    describe("#all", () => {
      it("should be null", () => { expect(prefs.all).toEqual({}) })
    })

    describe("#allowed", () => {
      it("should return false for all categories", () => {
        expect(prefs.allowed('required')).toBe(false)
        expect(prefs.allowed('marketing')).toBe(false)
      })
    })

    describe("#categories", () => {
      it("should be empty", () => { expect(prefs.categories).toEqual([]) })
    })

    describe("assigning #all", () => {
      beforeEach(() => { prefs.all = {required: false, functional: true} })

      it("should update", () => {
        expect(prefs.all).toEqual({required: false, functional: true})
      })

      it("should return new values for #allowed", () => {
        expect(prefs.allowed('required')).toBe(false)
        expect(prefs.allowed('functional')).toBe(true)
        expect(prefs.allowed('marketing')).toBe(false)
      })

      it("should update #categories list", () => {
        expect(prefs.categories).toEqual(['required', 'functional'])
      }) ;

      test.todo("emits event for updates")
    }) ;

    describe("assigning new category", () => {
      beforeEach(() => { prefs.setCategory('functional', true) })

      it("updates allowed value", () => {
        expect(prefs.allowed('functional')).toBe(true)
      })

      it("updates #all", () => {
        expect(prefs.all).toEqual({functional: true})
      })

      it("does not update category list", () => {
        expect(prefs.categories).toEqual(['functional'])
      })

      test.todo("emits event") ;
    })
  }) ;
})  
