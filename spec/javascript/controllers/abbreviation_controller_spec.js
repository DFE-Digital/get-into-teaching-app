import { Application } from '@hotwired/stimulus';
import AbbreviationController from 'abbreviation_controller.js';

describe('AbbreviationController', () => {
  const original = `
    <article data-controller="abbreviation">
      <p>You need a <abbr id="abbr-1" title="Postgraduate Certificate in Education">PGCE</abbr> to get <abbr title="Qualified Teacher Status">QTS<abbr>.</p>
    </article>
  `;

  document.body.innerHTML = original;

  const application = Application.start();
  application.register('abbreviation', AbbreviationController);

  describe('when loaded', () => {
    it('should not do anything by default', () => {
      const abbr = document.querySelector('abbr#abbr-1');
      expect(abbr.textContent).toEqual('PGCE');
    });
  });

  describe('when clicked', () => {
    it('replaces the abbr element with the title value', () => {
      document.querySelector('abbr').click();
      // note the first is expanded but not the second
      const p = document.querySelector('p');
      expect(p.textContent).toEqual(
        'You need a Postgraduate Certificate in Education to get QTS.'
      );
    });
  });
});
