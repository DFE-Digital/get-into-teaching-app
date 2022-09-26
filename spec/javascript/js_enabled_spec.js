import 'js_enabled';

describe('js_enabled', () => {
  it('includes the js-enabled class in the html element', () => {
    expect(document.documentElement.classList).toContain('js-enabled');
  });

  it('includes the js-enabled class in the body element', () => {
    expect(document.body.classList).toContain('js-enabled');
  });
});
