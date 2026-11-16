export default class Redacter {
  static postcodeMatcher = /[A-Z][A-HJ-Y]?\d[A-Z\d]? ?\d[A-Z]{2}|GIR ?0A{2}/m;
  static emailMatcher = /[^\s]+@[^\s]+/m;
  static dateMatcher =
    /\b\d\d?(st|nd|rd|th)?[ ./-]([a-zA-Z]+|[012]?\d?)[ ./-]\d\d\d{2}?\b/m;

  originalText = null;

  constructor(string) {
    this.originalText = string;
  }

  get redacted() {
    let redacted = this.redactEmailAddresses(this.originalText);
    redacted = this.redactPostcodes(redacted);
    redacted = this.redactDates(redacted);

    return redacted;
  }

  redactEmailAddresses(text) {
    return text.replace(Redacter.emailMatcher, '[EMAIL]');
  }

  redactPostcodes(text) {
    return text.replace(Redacter.postcodeMatcher, '[POSTCODE]');
  }

  redactDates(text) {
    return text.replace(Redacter.dateMatcher, '[DATE]');
  }
}
