import Redacter from 'redacter';

describe('Redacter', () => {
  function redact(string) {
    const redacter = new Redacter(string);
    return redacter.redacted;
  }

  describe('redacted', () => {
    it('should return the original string', () => {
      expect(redact('hello world')).toBe('hello world');
    });

    describe('with an email', () => {
      it('should scrub user@localhost', () => {
        expect(redact('hello user@localhost')).toBe('hello [EMAIL]');
      });

      it('should scrub user@localhost.com', () => {
        expect(redact('hello user@localhost.com')).toBe('hello [EMAIL]');
      });

      it('should scrub user.name@somedept.gov.uk', () => {
        expect(redact('hello user.name@somedept.gov.uk')).toBe('hello [EMAIL]');
      });

      it('should scrub user.name@somedept.gov.uk', () => {
        expect(redact('user.name@somedept.gov.uk')).toBe('[EMAIL]');
      });
    });

    describe('with a postcode', () => {
      it('should scrub a short postcode without whitespace', () => {
        expect(redact('near M12WD')).toBe('near [POSTCODE]');
      });

      it('should scrub a long postcode with whitespace', () => {
        expect(redact('near TE57 1NG')).toBe('near [POSTCODE]');
      });
    });

    describe('with a date', () => {
      it('should scrub long form', () => {
        expect(redact('01 January 1980')).toBe('[DATE]');
      });

      it('should scrub short form', () => {
        expect(redact('1 Jan 1980')).toBe('[DATE]');
      });

      it('should scrub with suffixes form', () => {
        expect(redact('1st January 1980')).toBe('[DATE]');
      });

      it('should scrub slashed text form', () => {
        expect(redact('01/Jan/1980')).toBe('[DATE]');
      });

      it('should scrub slashed numerical form', () => {
        expect(redact('01/1/1980')).toBe('[DATE]');
      });

      it('should scrub dashed form', () => {
        expect(redact('01-01-1980')).toBe('[DATE]');
      });

      it('should scrub dotted form', () => {
        expect(redact('1.1.1980')).toBe('[DATE]');
      });
    });
  });
});
