import { Application } from 'stimulus'
import ScribbleController from 'scribble_controller' ;

describe('ScribbleController', () => {
  var scribble;

  beforeEach(() => {
    document.body.innerHTML = `
      <div id="scribble" data-controller="scribble" data-scribble-id="123"></div>
    `;

    const application = Application.start();
    application.register('scribble', ScribbleController);
    scribble = document.getElementById('scribble');
  })

  it('sets the scribble data-src and class', () => {
    expect(scribble.dataset.src).toEqual('123');
    expect(scribble.classList.contains('scrbbl-embed')).toBeTruthy();
  });

  it('initialises the service', () => {
    expect(window.scribble).not.toBe(undefined);
  });
})
