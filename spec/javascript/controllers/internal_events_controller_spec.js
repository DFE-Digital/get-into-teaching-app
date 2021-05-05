import InternalEventsController from 'internal_events_controller.js';

describe('InternalEventsController', () => {
  let controller;

  beforeEach(() => {
    controller = new InternalEventsController();
  });

  describe('#formatDate()', () => {
    it('returns an empty string when date an empty string', () => {
      const result = controller.formatDate('');

      expect(result).toBe('');
    });

    it('returns a formatted date', () => {
      const result = controller.formatDate('2021-05-15T10:51');

      expect(result).toBe('210515');
    });
  });

  describe('#formatName()', () => {
    it('returns an empty string when name an empty string', () => {
      const result = controller.formatName('');

      expect(result).toBe('');
    });

    it('trims surrounding whitespace', () => {
      const result = controller.formatName(' name ');

      expect(result).toBe('name');
    });

    it('converts characters to lower case', () => {
      const result = controller.formatName('TEST');

      expect(result).toBe('test');
    });

    it('replaces internal whitespace with hyphens', () => {
      const result = controller.formatName('event name');

      expect(result).toBe('event-name');
    });
  });

  describe('#generatePartialUrl()', () => {
    it('returns an empty string when date is an empty string', () => {
      const result = controller.generatePartialUrl('', 'name');

      expect(result).toBe('');
    });

    it('returns an empty string when name is an empty string', () => {
      const result = controller.generatePartialUrl('date', '');

      expect(result).toBe('');
    });

    it('returns a formatted partial URL', () => {
      const result = controller.generatePartialUrl('210515', 'event-name');

      expect(result).toBe('210515-event-name');
    });
  });
});
