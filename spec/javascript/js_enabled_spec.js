import 'js_enabled';

describe('js_enabled', () => {
  it('includes the css js_enabled class in the html element', () => {
    expect(document.documentElement.classList).toContain('js-enabled');
  });
});
